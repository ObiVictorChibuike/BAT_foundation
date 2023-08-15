import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/constants.dart/string.dart';
import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({
    Key? key,
    this.width,
    this.height,
    this.imageWidget, this.color,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Widget? imageWidget;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color ?? Colors.transparent, width: 1),
          ),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
        child: Center(child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageWidget ?? Image.network(imagePlaceHolder, fit: BoxFit.cover,height: 120, width: 180))),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Icon(icon, color: Colors.white, size: 48),
        //     const SizedBox(height: 12),
        //     Text(
        //       label,
        //       style: const TextStyle(
        //         color: Colors.white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
