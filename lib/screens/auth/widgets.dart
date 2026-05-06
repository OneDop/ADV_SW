import 'package:flutter/material.dart';

class BuildLabel extends StatelessWidget {
  String label;

  BuildLabel({super.key, required this.label});


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsGeometry.only(left: 4, bottom: 8),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1
          ),
        )
    );
  }
}

class BuildTextField extends StatefulWidget {
  String hint;
  IconData icon;
  bool ispassword;
  bool obscurePassword;
  String? Function(String?)? validator;
  TextEditingController controller;
  final Color lightGreyBg = const Color(0xFFF2F4F6);

  BuildTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.ispassword = false,
    this.validator,
    required this.controller,
    this.obscurePassword = true
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.ispassword && widget.obscurePassword,
      validator: widget.validator,
      decoration: InputDecoration(
        hint: Text(widget.hint, style: TextStyle(color: Colors.grey),),
        prefixIcon: Icon(widget.icon, color: Colors.grey[600],),
        suffixIcon: widget.ispassword
          ? IconButton(onPressed:() => setState((){widget.obscurePassword = !widget.obscurePassword;}),// here
            icon: widget.obscurePassword ?Icon(Icons.lock_outline,color: Colors.grey[600],):Icon(Icons.lock_open,color: Colors.grey[600],))
            : null,
        filled: true,
        fillColor: widget.lightGreyBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        contentPadding: EdgeInsetsGeometry.symmetric(vertical: 18)
      ),
    );
  }
}