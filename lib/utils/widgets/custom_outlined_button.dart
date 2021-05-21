import 'package:flutter/material.dart';
import 'package:marine_watch/utils/color_utils.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.grey,
        side: BorderSide(
          color: ColorUtils.white87,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.button!.copyWith(
              color: ColorUtils.white87,
            ),
      ),
    );
  }
}
