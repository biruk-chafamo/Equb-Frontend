import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final bool showBorder;
  final bool showBackground;
  final Function()? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.showBorder = true,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.globalPadding,
      child: ElevatedButton(
        onPressed: onPressed,
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
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String child;
  final bool showBorder;
  final bool showBackground;
  final Function()? onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.showBorder = true,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shadowColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: showBorder
              ? BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                )
              : const BorderSide(width: 0, color: Colors.transparent),
          backgroundColor: showBackground
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          foregroundColor: showBackground
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        child: Text(child, style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
