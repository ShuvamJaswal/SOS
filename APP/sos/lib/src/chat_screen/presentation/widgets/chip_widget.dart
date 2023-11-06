import 'package:flutter/material.dart';

class ChipWidget extends StatefulWidget {
  final String label;
  final Function onTap;
  final Icon? icon;
  const ChipWidget(
      {super.key, required this.label, this.icon, required this.onTap});
  @override
  State<ChipWidget> createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            color = Colors.green[100];
          });
          await widget.onTap();
          setState(() {
            color = null;
          });
        },
        child: Chip(
          backgroundColor: color,
          avatar: widget.icon == null ? CircleAvatar() : widget.icon,
          label: Text(
            widget.label,
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}
