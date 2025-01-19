import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePaymentMethodScreen extends StatefulWidget {
  const CreatePaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<CreatePaymentMethodScreen> createState() =>
      _CreatePaymentMethodScreenState();
}

class _CreatePaymentMethodScreenState extends State<CreatePaymentMethodScreen> {
  final TextEditingController _detailController = TextEditingController();
  String? selectedService;

  @override
  void initState() {
    selectedService = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Create Payment Method",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            )
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
            builder: (context, state) {
              if (state.status == PaymentMethodStatus.success) {
                final List<String> availableServices = state.services
                    .where((service) => service != 'Cash')
                    .toList();

                return Container(
                  margin: AppMargin.globalMargin,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SectionTitleTile(
                            'Available Services',
                            Icons.payment,
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      showCloseIcon: true,
                                      duration: Duration(seconds: 8),
                                      content: Text(
                                          'The selected service will be used to send and recieve payments.')),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                            ),
                            includeDivider: false,
                          ),
                          Padding(
                            padding: AppPadding.globalPadding,
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: List<Widget>.generate(
                                  availableServices.length, (i) {
                                final service = availableServices[i];
                                return ChoiceChip(
                                  selected: selectedService == service,
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedService = service;
                                        _detailController.clear();
                                      });
                                    }
                                  },
                                  label: Text(service),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              SectionTitleTile(
                                'Payment Details',
                                Icons.payment,
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 8),
                                          content: Text(
                                              'Other users will use this information to make payments to you.')),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                includeDivider: false,
                              ),
                              Padding(
                                padding: AppPadding.globalPadding,
                                child: TextFormField(
                                  controller: _detailController,
                                  inputFormatters:
                                      selectedService == 'Bank Transfer'
                                          ? <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ]
                                          : null,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.8), // Input text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    // if selected servicce is bank, hint text will be 'Bank Name', otherwise 'Equb Name'
                                    hintText: selectedService == 'Bank Transfer'
                                        ? 'Account Number'
                                        : 'username',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                    border: const UnderlineInputBorder(),
                                    focusedBorder: const UnderlineInputBorder(),
                                  ),
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: AppPadding.globalPadding,
                            child: CustomOutlinedButton(
                              onPressed: () {
                                if (selectedService != null &&
                                    _detailController.text.isNotEmpty) {
                                  if (selectedService == 'Bank Transfer' &&
                                      _detailController.text.length != 10) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Account number must be 10 digits'),
                                      ),
                                    );
                                  } else {
                                    context.read<PaymentMethodBloc>().add(
                                          CreatePaymentMethod(
                                            service: selectedService!,
                                            detail: _detailController.text,
                                          ),
                                        );
                                    GoRouter.of(context).pop();
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select a service and fill in the details'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add a Payment Method'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
