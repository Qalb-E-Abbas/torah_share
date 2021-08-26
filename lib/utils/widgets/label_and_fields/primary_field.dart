import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../util_exporter.dart';

class PrimaryField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final Color backgroundColor;
  final Widget prefixIcon, suffixIcon;

  const PrimaryField({
    Key key,
    @required this.controller,
    @required this.hint,
    @required this.keyboardType,
    this.isPasswordField = false,
    this.backgroundColor = AppColors.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _PrimaryFieldState createState() => _PrimaryFieldState();
}

class _PrimaryFieldState extends State<PrimaryField> {
  bool isObscure = false;

  @override
  void initState() {
    isObscure = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: widget.hint,
          hintStyle: Styles.smallBrightPrimaryRegularTS(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPasswordField
              ? InkWell(
                  onTap: () => _toggleObscureness(),
                  child: Icon(
                    isObscure
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: 16.0,
                    color: AppColors.darkPrimaryColor,
                  ),
                )
              : widget.suffixIcon,
        ),
        style: Styles.smallDarkPrimaryBoldTS(),
        obscureText: isObscure,
      ),
    );
  }

  void _toggleObscureness() {
    setState(() {
      isObscure = !isObscure;
    });
  }
}
