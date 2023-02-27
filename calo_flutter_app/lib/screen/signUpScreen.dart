import 'dart:convert';

import 'package:calo_flutter_app/main.dart';
import 'package:calo_flutter_app/screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:http/http.dart' as http;
class SignUpScreen extends StatelessWidget{
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
  late String username='';
  late String password='';
  late String rePassword='';
  late String notifi='';
  void setUsername(val){
    setState(() {
      username=val;
    });
  }
  void setPassword(val){
    setState(() {
      password=val;
    });
  }
  void setNotifi(val){
    setState(() {
      notifi=val;
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
            height: 450,
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
                      child: Text("Đăng kí",
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
                        labelText: 'Tên đăng nhập',
                      ),
                      onChanged: (val)async{
                        await Future.delayed(Duration(milliseconds: 500));
                        setUsername(val);
                        print(val);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không được bỏ trống tên đăng nhập';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText:true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.key),
                        hintText: '',
                        labelText: 'Mật khẩu',
                      ),
                      onChanged: (value){
                        setPassword(value);
                      }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống mật khẩu';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText:true,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.question_mark),
                        hintText: '',
                        labelText: 'Nhập lại mật khẩu',
                      ),
                      onChanged: (value){
                      }
                      ,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Không bỏ trống ';
                        }else if(value!=password){
                          return 'Mật khẩu không khớp';
                        }else
                        return null;
                      },
                    ),

                    Container(
                        padding: const EdgeInsets.only(left: 0.0, top: 20.0),
                        child: new ElevatedButton(
                            child: const Text('Đăng kí'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                createUser(username, password).then((value) {
                                  if(!json.decode(value.body)['signupStatus']){
                                    setNotifi(json.decode(value.body)['notification']);
                                  }else{
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  };
                                });
                              }

                            }
                        )),
                    Text("${notifi}",
                      style:TextStyle(
                        fontSize: 14,
                        color: Colors.red
                      )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(43, 0, 0, 0),
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Bạn đã có tài khoản ?",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                                TextButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text("Đăng nhập",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue
                                    )
                                ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
Future<http.Response> createUser(String username,String password) async{
  final response= await http.post(
    Uri.parse("http://192.168.50.106:5000/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    body: jsonEncode(<String, String>{
      'username':username,
      'password':password
    }),
  );
  print(response.body);
  return response;
}