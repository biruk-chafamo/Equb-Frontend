import 'package:choice/choice.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EqubCreationScreen extends StatefulWidget {
  const EqubCreationScreen({super.key});

  @override
  EqubCreationScreenState createState() => EqubCreationScreenState();
}

class EqubCreationScreenState extends State<EqubCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController =
      TextEditingController(text: '100');
  final TextEditingController maxMembersController =
      TextEditingController(text: '2');
  final TextEditingController daysController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  String? selectedCycle = 'Monthly';
  final List<String> cycleOptions = ['Weekly', 'Monthly', 'Yearly', 'Custom'];
  bool isPrivate = false;

  double _getFontSize(String text) {
    int length = text.length;
    if (length <= 4) {
      return 50.0;
    } else if (length <= 6) {
      return 40.0;
    } else if (length <= 8) {
      return 30.0;
    } else {
      return 20.0;
    }
  }

  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    maxMembersController.dispose();
    daysController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintTextStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context)
              .colorScheme
              .onSecondaryContainer
              .withOpacity(0.5),
          fontWeight: FontWeight.bold,
        );
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: AppPadding.globalPadding,
          margin: AppMargin.globalMargin,
          child: Text(
            'Create Equb',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: Container(
              margin: AppMargin.globalMargin,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: BlocBuilder<EqubBloc, EqubDetailState>(
                        builder: (context, state) {
                          return ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: AppPadding.globalPadding,
                                child: TextFormField(
                                  focusNode: _nameFocusNode,
                                  controller: nameController,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Equb Name',
                                    hintStyle: hintTextStyle,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  autocorrect: false,
                                ),
                              ),
                              ...potentialParamError(state, "name"),
                              const SizedBox(height: 10),
                              SectionTitleTile(
                                "Members",
                                Icons.group_sharp,
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 8),
                                          content: Text(
                                              'You can invite members to join the equb once the equb is created. The equb will not start until all members have joined.')),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                includeDivider: false,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 50),
                                    onPressed: () {
                                      int currentValue = int.tryParse(
                                              maxMembersController.text) ??
                                          2;
                                      if (currentValue > 2) {
                                        setState(() {
                                          maxMembersController.text =
                                              (currentValue - 1).toString();
                                        });
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: maxMembersController,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25.0, // Larger font size
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        size: 50),
                                    onPressed: () {
                                      int currentValue = int.tryParse(
                                              maxMembersController.text) ??
                                          2;
                                      setState(() {
                                        maxMembersController.text =
                                            (currentValue + 1).toString();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              ...potentialParamError(state, "max_members"),
                              const SizedBox(height: 10),
                              SectionTitleTile(
                                "Total Amount",
                                Icons.monetization_on_rounded,
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 8),
                                          content: Text(
                                              "The total amount is the sum of payments that each member makes to the winner of an equb cycle. If members decide to place bids to win the equb, the highest bid amount will be deducted from each members contribution.")),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                includeDivider: false,
                              ),
                              TextFormField(
                                controller: amountController,
                                style: TextStyle(
                                  fontSize: _getFontSize(
                                    amountController.text,
                                  ),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  suffix: Padding(
                                    padding: AppPadding.globalPadding,
                                    child: Text(
                                      'per cycle',
                                      style: hintTextStyle,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.5),
                                    size: _getFontSize(amountController.text),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                autocorrect: false,
                              ),
                              ...potentialParamError(state, "amount"),
                              if (int.tryParse(maxMembersController.text) ==
                                      null ||
                                  double.tryParse(amountController.text) ==
                                      null)
                                const SizedBox()
                              else
                                Padding(
                                  padding: AppPadding.globalPadding,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: equbAmountNumberFormat.format(
                                            double.parse(
                                                    amountController.text) /
                                                int.parse(
                                                    maxMembersController.text),
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiary),
                                        ),
                                        TextSpan(
                                          text: ' per member per cycle',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              SectionTitleTile(
                                "Cycle Length",
                                Icons.calendar_month,
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 8),
                                          content: Text(
                                              "Since each member has to win an equb cycle exactly once, the number of cycles is equal to the number of equb member. The winner of an equb cycle is determined at the end of each cycle.")),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                includeDivider: false,
                              ),
                              Choice<String>.inline(
                                clearable: false,
                                value: ChoiceSingle.value(selectedCycle),
                                onChanged: ChoiceSingle.onChanged((value) {
                                  setState(() {
                                    selectedCycle = value;
                                  });
                                }),
                                itemCount: cycleOptions.length,
                                itemBuilder: (state, i) {
                                  return ChoiceChip(
                                    selected: state.selected(cycleOptions[i]),
                                    showCheckmark: false,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedCycle = cycleOptions[i];
                                      });
                                    },
                                    label: Text(cycleOptions[i]),
                                  );
                                },
                                listBuilder: ChoiceList.createScrollable(
                                  spacing: 10,
                                  padding: const EdgeInsets.all(16.0),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (selectedCycle == 'Custom') ...[
                                Padding(
                                  padding: AppPadding.globalPadding,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: daysController,
                                          decoration: const InputDecoration(
                                            labelText: 'Days',
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: hoursController,
                                          decoration: const InputDecoration(
                                            labelText: 'Hours',
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value != null &&
                                                value.isNotEmpty &&
                                                int.tryParse(value) == null) {
                                              return 'Enter valid hours';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: AppPadding.globalPadding,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: minutesController,
                                          decoration: const InputDecoration(
                                            labelText: 'Minutes',
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value != null &&
                                                value.isNotEmpty &&
                                                int.tryParse(value) == null) {
                                              return 'Enter valid minutes';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...potentialParamError(state, "cycle"),
                                const SizedBox(height: 10),
                              ],
                              SectionTitleTile(
                                "Visibility",
                                Icons.remove_red_eye,
                                IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            showCloseIcon: true,
                                            duration: Duration(seconds: 8),
                                            content: Text(
                                                'Public equbs will show up as recommendations to your trusted firends and they can request to join. Private equbs are seen only by those you invite.')),
                                      );
                                    },
                                    icon: Icon(Icons.info_outline)),
                                includeDivider: false,
                              ),
                              Padding(
                                padding: AppPadding.globalPadding,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ToggleButtons(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        isSelected: [isPrivate, !isPrivate],
                                        borderColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        selectedBorderColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        onPressed: (int index) {
                                          setState(() {
                                            isPrivate = index == 0;
                                          });
                                        },
                                        children: const ['Private', 'Public']
                                            .map((text) => Padding(
                                                  padding:
                                                      AppPadding.globalPadding,
                                                  child: Text(
                                                    text,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                ),
                                child: BlocListener<EqubBloc, EqubDetailState>(
                                  listener: (context, state) {
                                    if (state.status ==
                                        EqubDetailStatus.success) {
                                      GoRouter.of(context)
                                          .goNamed('pending_equbs_overview');
                                    }
                                  },
                                  child: CustomOutlinedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        String cycle = '';
                                        switch (selectedCycle) {
                                          case 'Weekly':
                                            cycle = '7 00:00:00';
                                            break;
                                          case 'Monthly':
                                            cycle = '30 00:00:00';
                                            break;
                                          case 'Yearly':
                                            cycle = '365 00:00:00';
                                            break;
                                          case 'Custom':
                                            cycle =
                                                '${daysController.text.isNotEmpty ? "${daysController.text} " : ""}'
                                                '${hoursController.text.isNotEmpty ? "${hoursController.text.padLeft(2, "0")}:" : ""}'
                                                '${minutesController.text.isNotEmpty ? "${minutesController.text.padLeft(2, "0")}:00" : ""}';
                                            break;
                                          default:
                                            cycle = '1 00:00:00';
                                        }

                                        final equbCreationDTO = EqubCreationDTO(
                                          name: nameController.text,
                                          amount: double.parse(
                                              amountController.text),
                                          maxMembers: maxMembersController
                                                      .text ==
                                                  ""
                                              ? 0
                                              : int.parse(
                                                  maxMembersController.text),
                                          cycle: cycle,
                                          isPrivate: isPrivate,
                                        );
                                        context
                                            .read<EqubBloc>()
                                            .add(CreateEqub(equbCreationDTO));
                                      }
                                    },
                                    child: Text(
                                      'Create Equb',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> potentialParamError(EqubDetailState state, String equbParam) {
  if (state.status == EqubDetailStatus.failure &&
      state.parameterErrorJSON[equbParam] != null) {
    return state.parameterErrorJSON[equbParam]
        .map<Widget>(
          (e) => Padding(
            padding: AppPadding.globalPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                e.toString(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        )
        .toList();
  }
  return [];
}
