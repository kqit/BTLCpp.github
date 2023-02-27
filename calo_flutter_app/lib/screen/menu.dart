import 'package:calo_flutter_app/main.dart';
import 'package:calo_flutter_app/screen/InformationScreen.dart';
import 'package:calo_flutter_app/screen/homescreen.dart';
import 'package:calo_flutter_app/screen/loginScreen.dart';
import 'package:calo_flutter_app/screen/targetScreen.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:flutter/material.dart';


var check=0;
class menu extends StatelessWidget{
  @override
  void logOut() async{
    SharedPreferences perfs = await SharedPreferences.getInstance();
    perfs.remove("idUser");
  }
  Widget build(BuildContext context){
    return Drawer(
        child:  ListView(
          children: <Widget>[
             DrawerHeader(
              child: Container(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/iconApp.png",
                          width: 90,
                          height: 90,
                        ),
                        Text("Theo dõi dinh dưỡng",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              width: 60,
                              height: 60,
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 0,
                                          color: Colors.grey
                                      )
                                  )
                              )
                          ),
                          Text("Hoàng Huy",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              decoration:  BoxDecoration(
                  color: Colors.blue
              ),
            ),
            ListTile(
              onTap: ()=>{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                )
              },
              leading: Icon(Icons.list_alt),
              title: Text('Trang chủ'),
            ),
            ListTile(
              onTap: ()=>{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TargetScreen()),
                )
              },
              leading: Icon(Icons.cable),
              title: Text('Mục tiêu'),
            ),
            ListTile(
              onTap: ()=>{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Information()),
                )
              },
              leading: Icon(Icons.person),
              title: Text('Thông tin cá nhân'),
            ),


              check!=0?ListTile(
                leading: Icon(Icons.login),
                title: Text("Đăng nhập"),
                onTap: ()=>{
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  )
                },
              ):ListTile(
                leading: Icon(Icons.login),
                title: Text("Đăng xuất"),
                onTap: (){
                  logOut();
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              )
        ]
        )
    );
  }
}
