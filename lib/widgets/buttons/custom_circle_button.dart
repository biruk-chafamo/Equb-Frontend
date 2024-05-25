import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final Widget child;
  final bool showBorder; //optional
  final bool showBackground; //optional
  final double radius; //optional

  const CustomCircleButton({
    super.key,
    required this.child,
    this.showBorder = true,
    this.showBackground = true,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        minimumSize: Size(radius * 2, radius * 2),
        shape: const CircleBorder(),
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
