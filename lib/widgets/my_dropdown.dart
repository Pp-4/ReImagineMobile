import 'package:flutter/material.dart';
import 'package:reimagine_mobile/point.dart';
class MyDropdown extends StatefulWidget {
  MyDropdown({Key? key, required this.title, required this.list})
      : super(key: key);
  var update = (){};
  String title;
  List<String> list;
  late String currentValue;
  Kolor kolor = Kolor(0, 0, 0, 0);
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
        const SizedBox(height: 5,),
        DropdownMenu<String>(
          width: 120,
          initialSelection: widget.list[widget.kolor.rownanie],
          onSelected: (String? value) {
            setState(() {
              widget.currentValue = value!;
              switch(widget.currentValue){
                case 'Julia':
                  widget.kolor.rownanie = 0;
                case 'Mandelbrott':
                  widget.kolor.rownanie = 1;
                case 'Płonący statek - Julia':
                  widget.kolor.rownanie = 2;
                case 'Płonący statek':
                  widget.kolor.rownanie = 3;
                default:
                  widget.kolor.rownanie = 0;
              }
              widget.update();
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
