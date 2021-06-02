import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key, this.label = '', required this.onPressed})
      : super(key: key);

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).accentColor,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
