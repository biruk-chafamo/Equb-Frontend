import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          children: [
            Text(
              "Payment Method",
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
                  padding: AppPadding.globalPadding,
                  margin: AppMargin.globalMargin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<String>(
                        value: selectedService,
                        hint: const Text("Select a service"),
                        isExpanded: true,
                        items: availableServices.map((String service) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Text(service),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedService = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _detailController,
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
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      const SizedBox(height: 20),

                      // Create button
                      CustomOutlinedButton(
                        onPressed: () {
                          if (selectedService != null &&
                              _detailController.text.isNotEmpty) {
                            if (selectedService == 'Bank Transfer' &&
                                _detailController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Account number must be 10 digits'),
                                ),
                              );
                            } else {
                              context.read<PaymentMethodBloc>().add(
                                    CreatePaymentMethod(
                                      service: selectedService!,
                                      detail: _detailController.text,
                                    ),
                                  );
                              context
                                  .read<UserBloc>()
                                  .add(const FetchCurrentUser());
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
                    ],
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
