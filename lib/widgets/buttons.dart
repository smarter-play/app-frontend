import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.colored = true,
    this.colorOverride,
    this.fgColorOverride,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool colored;
  final Color? colorOverride;
  final Color? fgColorOverride;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.zero,
          backgroundColor:
              colorOverride ?? (colored ? Colors.black : Colors.white),
        ),
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: fgColorOverride ??
                (colored
                    ? Colors.white
                    : onPressed != null
                        ? Colors.black
                        : const Color(0xFFd8d4f9)),
          ),
        ),
      ),
    );
  }
}
