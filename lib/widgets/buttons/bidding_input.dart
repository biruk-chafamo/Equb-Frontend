import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double step;

  final ValueChanged<double> onChanged;

  const NumericStepButton(
      {super.key,
      this.minValue = 0,
      this.maxValue = 10,
      this.step = 0.5,
      required this.onChanged});

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  double counter = 0;
  double currentMinValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorder.radius,
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                onPressed: () {
                  setState(() {
                    if (counter >= currentMinValue + widget.step) {
                      counter = counter - widget.step;
                      print('current min vaue is $currentMinValue');
                    }
                    widget.onChanged(counter);
                  });
                },
              ),
              Text(
                '${counter.toStringAsFixed(1)}%',
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
                onPressed: () {
                  setState(() {
                    if (counter <= widget.maxValue + widget.step) {
                      counter = counter + widget.step;
                    }
                    widget.onChanged(counter);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
