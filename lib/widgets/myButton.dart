import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';

class Mybutton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isLoading;
  const Mybutton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.button.withOpacity(0.6)
              : AppColors.button,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.buttonText,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
