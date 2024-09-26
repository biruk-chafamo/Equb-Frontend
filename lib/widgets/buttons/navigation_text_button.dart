import 'package:flutter/material.dart';

class NavigationTextButton extends StatelessWidget {
  final String data;
  final Function()? onPressed;
  const NavigationTextButton({
    super.key,
    required this.data,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            data,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 15,)
      ],
    );
  }
}
