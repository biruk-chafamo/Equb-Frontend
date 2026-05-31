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

ButtonStyle? getCustomButtonStyle(
    BuildContext context, bool showBorder, bool showBackground,
    {Color? backgroundColor}) {
  backgroundColor ??= Theme.of(context).colorScheme.secondary;
  return OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
    backgroundColor: showBackground ? backgroundColor : Colors.transparent,
    foregroundColor: showBackground
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.onSecondaryContainer,
  );
}

class CustomOutlinedButton extends StatelessWidget {
  final String child;
  final bool showBorder;
  final bool showBackground;
  final Widget? leading;
  final Color? backgroundColor;
  final Function()? onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.showBorder = true,
    this.showBackground = true,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: getCustomButtonStyle(context, showBorder, showBackground,
            backgroundColor: backgroundColor),
        child: leading != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leading!,
                  const SizedBox(width: 8),
                  Text(child, style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              )
            : Text(child, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
