import 'package:flutter/material.dart';

class EditInput extends StatefulWidget {
  final String label;
  final int selectedValue;
  final void Function(int? value) onChanged;

  const EditInput({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<EditInput> createState() => _EditInputState();
}

class _EditInputState extends State<EditInput> {

  late double value;
  late String trailing;
  
  @override
  void initState() {
    super.initState();
    value = (widget.selectedValue).toDouble();
    trailing = (widget.label == 'Sessions') ? '' : 'minutes';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final textStyle = TextStyle(
      fontSize: (width / 20).clamp(12, 24),
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        title: Text(
          '${widget.label}: ${value.ceil()} $trailing',
          style: textStyle,
        ),
        subtitle: Slider(
          min: 1,
          max: widget.label == 'Sessions' ? 10 : (widget.label == 'Break' ? 15 : 100),
          value: value,
          onChanged: (val) {
            setState(() => value = val);
            widget.onChanged(value.ceil().toInt());
          },
        ),
      ),
    );
  }
}