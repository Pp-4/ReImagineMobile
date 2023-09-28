import 'package:flutter/material.dart';
import 'package:reimagine_mobile/point.dart';
import 'package:reimagine_mobile/widgets/my_dropdown.dart';

class OptionsBar extends StatefulWidget {
  OptionsBar({Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
  Kolor kolor = Kolor(0, 0, 0, 0);
  MyDropdown dropdown = MyDropdown(title:"Wybór 1",list: const ["Julia","Mandelbrott","Płonący statek","Płonący statek - Julia"]);

  var update = (){};
}

class _OptionsBarState extends State<OptionsBar> {


  @override
  Widget build(BuildContext context) {
    initState(){
      widget.dropdown.kolor = widget.kolor;
    }
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
          child: const Text("ReImage",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),
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
                Text("Modyfikator B:  ${double.parse((widget.kolor.kolor1).toStringAsFixed(2))}",),
                Slider(value: widget.kolor.kolor1 , onChanged: (double value){
                  setState(() {
                    widget.kolor.kolor1 = value;
                    widget.update();
                  });
                },min: 0,max: 1,label: "Modyfikator B: ${widget.kolor.kolor1}",),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Modyfikator G:  ${double.parse((widget.kolor.kolor2).toStringAsFixed(2))}",),
                    Slider(value: widget.kolor.kolor2 , onChanged: (double value){
                      setState(() {
                        widget.kolor.kolor2 = value;
                        widget.update();
                      });
                    },min: 0,max: 1,label: "Modyfikator G: ${widget.kolor.kolor2}",),
                  ]),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Modyfikator R:  ${double.parse((widget.kolor.kolor3).toStringAsFixed(2))}",),
                    Slider(value: widget.kolor.kolor3 , onChanged: (double value){
                      setState(() {
                        widget.kolor.kolor3 = value;
                        widget.update();
                      });
                    },min: 0,max: 1,label: "Modyfikator R: ${widget.kolor.kolor3}",),
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