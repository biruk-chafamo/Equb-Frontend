import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final bool showBorder; //optional
  final bool showBackground; //optional

  const CustomElevatedButton({
    super.key,
    required this.child,
    this.showBorder = true,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shadowColor: Theme.of(context).colorScheme.primary,
        side: showBorder
            ? BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
            : const BorderSide(width: 0, color: Colors.transparent),
        backgroundColor: showBackground
            ? Theme.of(context).colorScheme.secondaryContainer
            : Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      child: child,
    );
  }
}
