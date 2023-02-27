import 'dart:convert';

import 'package:calo_flutter_app/main.dart';
import 'package:calo_flutter_app/screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:http/http.dart' as http;
class AddProfileScreen extends StatelessWidget{
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: MainScreen(),
    );
  }
}
class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState()=>_MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  late String fullname='';
  late String height='';
  late String weight='';
  late String sex='';
  late String age='';
  late String address='';
  void setFullname(val){
    setState(() {
      fullname=val;
    });
  }
  void setHeight(val){
    setState(() {
      height=val;
    });
  }
  void setWeight(val){
    setState(() {
      weight=val;
    });
  }
  void setSex(val){
    setState(() {
      sex=val;
    });
  }
  void setAge(val){
    setState(() {
      age=val;
    });
  }
  void setEmail(val){
    setState(() {
      address=val;
    });
  }

  @override
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width:300,
              height: 550,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 0.5),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Text("Thông tin cá nhân",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                        ),),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: '',
                        labelText: 'Tên đầy đủ',
                      ),
                      onChanged: (val)async{
                        await Future.delayed(Duration(milliseconds: 500));
                        setFullname(val);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không được bỏ trống ';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Chiều cao',
                      ),
                      onChanged: (value){
                        setHeight(value);
                      }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Cân nặng',
                      ),
                      onChanged: (value){
                        setWeight(value);
                      }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống ';
                        }
                          return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Giới tính',
                      ),
                      onChanged: (value){
                        setSex(value);
                      }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống ';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Tuổi',
                      ),
                      onChanged: (value){
                        setAge(value);
                        print(age);
                        }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống ';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Email',
                      ),
                      onChanged: (value){
                        setEmail(value);
                      }

                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 0.0, top: 20.0),
                        child: new ElevatedButton(
                            child: const Text('Xác nhận'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                createProfile(fullname, weight, height, sex, age, address);
                              }

                            }
                        )),


                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
Future<http.Response> createProfile(String fullName, String weight, String height, String sex,String age, String email ) async {

  SharedPreferences perfs= await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    Uri.parse('http://192.168.50.106:5000/profile'),
    body: {
      'fullName':fullName,
      'weight':weight,
      'height':height,
      'sex':sex,
      'age':age,
      'email':email,
    },
    headers: <String, String>{

      'iduser': perfs.getString('idUser')!
    },
  );
  print(response.body);
  return response;
}