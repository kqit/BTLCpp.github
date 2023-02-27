import 'dart:convert';

import 'package:calo_flutter_app/main.dart';
import 'package:calo_flutter_app/screen/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:http/http.dart' as http;
class LoginScreen extends StatelessWidget{
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
class _MainScreenState extends State<MainScreen>{
  @override
  final _formKey = GlobalKey<FormState>();

  late String username;
  late String password;
  void initState(){
    super.initState();
  }
  void setUsername(value){
    setState(() {
      username=value;
    });
  }
  void setPassword(value){
    setState(() {
      password=value;
    });
  }
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
                    child: Text("Đăng nhập",
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

                  Container(
                      padding: const EdgeInsets.only(left: 0.0, top: 20.0),
                      child: new ElevatedButton(
                        child: const Text('Đăng nhập'),
                        onPressed: ()async {
                          if (_formKey.currentState!.validate()) {
                            await fetchGetIdUser(username, password);
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          }
                        }
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(43, 0, 0, 0),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Bạn chưa có tài khoản ?",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        TextButton(onPressed: (){
                          print("ok");
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                            child: Text("Đăng kí",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue
                                )
                            )
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
class Login {
  final bool status;
  final String notification;
  final String idUser;
  Login({
    required this.status,
    required this.notification,
    required this.idUser
});
  factory Login.fromJson(Map<String, dynamic> json){
    return Login(
        status: json['status'],
        notification: json['notification'],
        idUser: json['idUser']
    );
  }
}
Future<Login> fetchGetIdUser(String username,String password) async {
  var url=Uri.parse("http://192.168.50.106:5000/login");
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'username':username,
    'password':password
  };
  final response = await http.get(url,headers: requestHeaders );
  SharedPreferences perfs = await SharedPreferences.getInstance();
  if (response.statusCode == 200) {
    perfs.setString("idUser", json.decode(response.body)['idUser']);
    print(perfs.get("idUser"));
    return Login.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}