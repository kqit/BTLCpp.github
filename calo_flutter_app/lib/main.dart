import 'package:flutter/material.dart';
import 'dart:async';
import 'package:calo_flutter_app/screen/homescreen.dart';
import 'package:calo_flutter_app/screen/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  @override
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp>{
  late String idUser="";
  initState() {
    super.initState();
    getData();
  }
  void getData() async{
    SharedPreferences perfs = await SharedPreferences.getInstance();
    if(perfs.getKeys().contains("idUser")){
      setState(() {
        idUser=perfs.getString("idUser")!;
      });
    }else{
      setState(() {
        idUser="";
      });
    }
  }
  @override
  Widget build(BuildContext context){
    if(idUser!=""){
      return MaterialApp(
        home: HomeScreen(),
      );
    }else{
      return MaterialApp(
        home: LoginScreen(),
      );
    }

  }

}
