import 'package:choice/choice.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Theme.of(context).colorScheme.surface,
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
      body: Center(
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
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Name
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            autocorrect: false,
                          ),
                        ),
                        const SizedBox(height: 10),

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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 1) {
                              return 'Please enter a number greater than 1';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          autocorrect: false,
                        ),

                        const SizedBox(height: 10),

                        SectionTitleTile(
                          "Members",
                          Icons.group_sharp,
                          Container(),
                          includeDivider: false,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 50),
                              onPressed: () {
                                int currentValue =
                                    int.tryParse(maxMembersController.text) ??
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter number of members';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (int.tryParse(value)! < 2) {
                                    return 'Please enter a number greater than 1';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_up_rounded,
                                  size: 50),
                              onPressed: () {
                                int currentValue =
                                    int.tryParse(maxMembersController.text) ??
                                        2;
                                setState(() {
                                  maxMembersController.text =
                                      (currentValue + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        SectionTitleTile(
                          "Cycle",
                          Icons.calendar_month,
                          Container(),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: daysController,
                                  decoration: const InputDecoration(
                                    labelText: 'Days',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        int.tryParse(value) == null) {
                                      return 'Enter valid days';
                                    }
                                    return null;
                                  },
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
                          const SizedBox(height: 10),
                          Row(
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
                          const SizedBox(height: 10),
                        ],

                        Padding(
                          padding: AppPadding.globalPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ToggleButtons(
                                  borderRadius: BorderRadius.circular(8.0),
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
                                            padding: AppPadding.globalPadding,
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    child: CustomOutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Map the selected cycle to the correct time delta
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

                          if (cycle.replaceAll(RegExp(r'[0: ]'), '').isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a non-zero cycle'),
                              ),
                            );
                            return;
                          }

                          final equbCreationDTO = EqubCreationDTO(
                            name: nameController.text,
                            amount: double.parse(amountController.text),
                            maxMembers: int.parse(maxMembersController.text),
                            cycle: cycle,
                            isPrivate: isPrivate,
                          );
                          context
                              .read<EqubBloc>()
                              .add(CreateEqub(equbCreationDTO));
                          GoRouter.of(context).pop();
                        }
                      },
                      child: Text(
                        'Create Equb',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
