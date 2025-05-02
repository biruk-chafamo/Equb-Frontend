import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumericStepButton extends StatefulWidget {
  final int equbId;
  final double minValue;
  final double maxValue;
  final double step;
  final bool isWonByUser;

  const NumericStepButton({
    super.key,
    required this.equbId,
    required this.minValue,
    required this.maxValue,
    required this.isWonByUser,
    this.step = 0.005,
  });

  @override
  State<NumericStepButton> createState() => _NumericStepButtonState();
}

class _NumericStepButtonState extends State<NumericStepButton> {
  late double counter;
  late double currentMinValue;

  _NumericStepButtonState();

  @override
  void initState() {
    super.initState();
    counter = widget.minValue;
    currentMinValue = widget.minValue;
  }

  @override
  Widget build(BuildContext context) {
    final equbBloc = context.read<EqubBloc>();

    return Container(
      decoration: PrimaryBoxDecor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: currentMinValue < counter
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.3),
                ),
                iconSize: 50.0,
                color: Theme.of(context).primaryColor,
                onPressed: widget.isWonByUser
                    ? null
                    : () {
                        setState(() {
                          if (counter >= currentMinValue + widget.step) {
                            counter = counter - widget.step;
                          }
                        });
                      },
              ),
              Text(
                '${(counter * 100).toStringAsFixed(1)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                iconSize: 50.0,
                color: Theme.of(context).primaryColor,
                onPressed: widget.isWonByUser
                    ? null
                    : () {
                        setState(() {
                          if (counter <= widget.maxValue + widget.step) {
                            counter = counter + widget.step;
                          }
                        });
                      },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomOutlinedButton(
              child: 'place bid',
              onPressed: widget.isWonByUser
                  ? null
                  : () {
                      setState(() {
                        currentMinValue = counter;
                        equbBloc.add(PlaceBid(widget.equbId, counter));
                      });
                    },
            ),
          )
        ],
      ),
    );
  }
}
