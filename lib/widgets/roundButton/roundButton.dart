import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool loading;
  const RoundButton(
      {this.loading = false,
      super.key,
      required this.title,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: Appcolor.buttonclolor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
            child: loading == false
                ? Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  )),
      ),
    );
  }
}
