import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class TextFormFields extends StatefulWidget {
  final TextEditingController controllerValue;
  final String hintValue;
  final IconData? icon;

  const TextFormFields({
    Key? key,
    required this.controllerValue,
    required this.hintValue,
    this.icon,
  }) : super(key: key);

  @override
  State<TextFormFields> createState() => _TextFormFieldsState();
}

class _TextFormFieldsState extends State<TextFormFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controllerValue,
      cursorColor: Appcolor.buttonclolor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hoverColor: Appcolor.buttonclolor,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Appcolor.buttonclolor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Appcolor.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 223, 78, 68), width: 2),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Appcolor.buttonclolor,
        ),
        hintText: widget.hintValue,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter ${widget.hintValue}";
        }
        return null;
      },
    );
  }
}
