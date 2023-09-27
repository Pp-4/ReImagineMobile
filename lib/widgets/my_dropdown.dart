import 'dart:js_interop';

import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  MyDropdown({Key? key,required this.list}) : super(key: key);

  List<String> list;
  @override
  State<MyDropdown> createState() => _MyDropdownState();

  addToList(String value){
    !list.isNull? list.add(value):null;
  }
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>()
  }
}
