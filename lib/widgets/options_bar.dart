import 'package:flutter/material.dart';
import 'package:reimagine_mobile/widgets/my_dropdown.dart';


class OptionsBar extends StatefulWidget {
  OptionsBar({Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
  var currentSliderOneValue = 0.2;
  var currentSliderTwoValue = 0.6;
  var currentSliderThreeValue = 1.0;
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
                Text("Opcja 1:  " + double.parse((widget.currentSliderOneValue).toStringAsFixed(2)).toString(),),
                Slider(value: widget.currentSliderOneValue , onChanged: (double value){
                  setState(() {
                    widget.currentSliderOneValue = value;
                  });
                },min: 0,max: 1,label: "Opcja 1: " + widget.currentSliderOneValue.toString(),),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Opcja 1:  " + double.parse((widget.currentSliderTwoValue).toStringAsFixed(2)).toString(),),
                    Slider(value: widget.currentSliderTwoValue , onChanged: (double value){
                      setState(() {
                        widget.currentSliderTwoValue = value;
                      });
                    },min: 0,max: 1,label: "Opcja 1: " + widget.currentSliderTwoValue.toString(),),
                  ]),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Opcja 1:  " + double.parse((widget.currentSliderThreeValue).toStringAsFixed(2)).toString(),),
                    Slider(value: widget.currentSliderThreeValue , onChanged: (double value){
                      setState(() {
                        widget.currentSliderThreeValue = value;
                      });
                    },min: 0,max: 1,label: "Opcja 1: " + widget.currentSliderThreeValue.toString(),),
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