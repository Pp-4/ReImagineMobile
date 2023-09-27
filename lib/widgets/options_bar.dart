import 'package:flutter/material.dart';
import 'package:reimagine_mobile/point.dart';
import 'package:reimagine_mobile/widgets/my_dropdown.dart';
import '/point.dart';

class OptionsBar extends StatefulWidget {
  OptionsBar({Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
  Kolor kolor = Kolor(0, 0, 0);
  MyDropdown dropdown = MyDropdown(title:"Wybór 1",list: ["Opcja 1","Opcja 2","Opcja 3","Opcja 4"]);
}

class _OptionsBarState extends State<OptionsBar> {


  @override
  Widget build(BuildContext context) {

    getSelectedSet(){
      return widget.dropdown.currentValue;
    }


    double height =  MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _builLogo(){
      return SizedBox(
        height: height/6,
        child: DrawerHeader(child:Container(


          alignment: Alignment.centerLeft,
          child: Text("ReImage",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),
        )),
      );
    }


    _buildSliders(){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Opcja 1:  " + double.parse((widget.kolor.kolor1).toStringAsFixed(2)).toString(),),
                Slider(value: widget.kolor.kolor1 , onChanged: (double value){
                  setState(() {
                    widget.kolor.kolor1 = value;
                  });
                },min: 0,max: 1,label: "Opcja 1: " + widget.kolor.kolor1.toString(),),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Opcja 1:  " + double.parse((widget.kolor.kolor2).toStringAsFixed(2)).toString(),),
                    Slider(value: widget.kolor.kolor2 , onChanged: (double value){
                      setState(() {
                        widget.kolor.kolor2 = value;
                      });
                    },min: 0,max: 1,label: "Opcja 1: " + widget.kolor.kolor2.toString(),),
                  ]),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Opcja 1:  " + double.parse((widget.kolor.kolor3).toStringAsFixed(2)).toString(),),
                    Slider(value: widget.kolor.kolor3 , onChanged: (double value){
                      setState(() {
                        widget.kolor.kolor3 = value;
                      });
                    },min: 0,max: 1,label: "Opcja 1: " + widget.kolor.kolor3.toString(),),
                  ]),
            ),

          ],
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _builLogo(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.dropdown,
          ),
          _buildSliders()



        ],
      ),
    );
  }
}