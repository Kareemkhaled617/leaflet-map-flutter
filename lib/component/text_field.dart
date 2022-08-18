import 'package:flutter/material.dart';

TextFormField buildTextFormField({
  required String hint,
  required String label,
  Widget? pIcon,
  Widget? sIcon,
  required TextInputType type,
  required Function() validate,
  required Function() onSave,
}) {
  return TextFormField(
    keyboardType: type,
    validator: validate(),
    onSaved: onSave(),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 15,
        color: Colors.grey[700],
      ),
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 2,
        color: Colors.grey[700],
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45),
        // borderSide: const BorderSide(color: Colors.black, width: 1.2)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(45),
        // borderSide: const BorderSide(color: Colors.black, width: 1.2)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        // borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
      prefixIcon: pIcon,
      suffixIcon: sIcon,
    ),
  );
}