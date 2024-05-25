import 'package:flutter/material.dart';

class NavigationTextButton extends StatelessWidget {
  final String data;
  const NavigationTextButton({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: null,
          child: Text(data),
        ),
        const Icon(Icons.arrow_forward_rounded)
      ],
    );
  }
}
