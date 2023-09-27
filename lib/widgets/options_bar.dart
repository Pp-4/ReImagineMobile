import 'package:flutter/material.dart';
import 'package:reimagine_mobile/widgets/my_dropdown.dart';


class OptionsBar extends StatelessWidget {
  const OptionsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _builLogo(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {

            },
          ),
          MyDropdown(title:"Wybór 1",list: const ["Opcja 1","Opcja 2"]),
          MyDropdown(title:"Wybór 1",list: const ["Opcja 1","Opcja 2"]),


        ],
      ),
    );
  }
}
