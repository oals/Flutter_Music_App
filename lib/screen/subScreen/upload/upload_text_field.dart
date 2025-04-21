import 'package:flutter/material.dart';

class UploadTextField extends StatefulWidget {
  const UploadTextField(
      {super.key,
      required this.label,
      required this.maxLines,
      required this.controller,
      required this.isReadOnly,
      required this.isOnTap,
      required this.callBack});

  final String label;
  final int? maxLines;
  final TextEditingController controller;
  final bool isReadOnly;
  final bool isOnTap;
  final Function callBack;

  @override
  State<UploadTextField> createState() => _UploadTextFieldState();
}

class _UploadTextFieldState extends State<UploadTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 3,right: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        onTap: widget.isOnTap ? () {
          widget.callBack();
        } : null ,
        controller: widget.controller,
        maxLines: widget.maxLines,
        readOnly: widget.isReadOnly,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),

        ),
      ),
    );
  }
}
