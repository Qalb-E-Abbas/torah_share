import 'package:flutter/material.dart';

import '../../widgets/widgets_exporter.dart';

class PrimaryLabelAndField extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool isPasswordField;
  final TextInputType keyboardType;

  const PrimaryLabelAndField({
    Key key,
    @required this.controller,
    @required this.label,
    @required this.hint,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.visiblePassword,
  }) : super(key: key);

  @override
  _PrimaryLabelAndFieldState createState() => _PrimaryLabelAndFieldState();
}

class _PrimaryLabelAndFieldState extends State<PrimaryLabelAndField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallLessPrimaryText(value: widget.label),
          const SizedBox(height: 10.0),
          PrimaryField(
            controller: widget.controller,
            hint: widget.hint,
            isPasswordField: widget.isPasswordField,
            keyboardType: widget.keyboardType,
          ),
        ],
      ),
    );
  }
}
