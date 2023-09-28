import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  MyDropdown({Key? key, required this.title, required this.list})
      : super(key: key);

  String title;
  List<String> list;
  late String currentValue;

  @override
  State<MyDropdown> createState() => _MyDropdownState();

  addToList(String value) {
    list.add(value);
  }
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  void initState() {
    super.initState();
    widget.currentValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(widget.title),
        SizedBox(height: 5,),
        DropdownMenu<String>(
          width: 120,
          initialSelection: widget.list.first,
          onSelected: (String? value) {
            setState(() {
              widget.currentValue = value!;
            });
          },
          dropdownMenuEntries:
              widget.list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        )
      ]),
    );
  }
}
