import 'dart:convert';

import 'package:calo_flutter_app/screen/addProfileScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:calo_flutter_app/screen/menu.dart';
import 'package:http/http.dart' as http;

/*class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();

}*/
class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      appBar: AppBar(

        title: Text("Thế Huy Hoàng"),
      ),
      drawer: menu(),
      body: mainInforScreen()
    );
  }
}

class mainInforScreen extends StatefulWidget{
  @override
  _mainInforScreenState createState()=>_mainInforScreenState();
}
class _mainInforScreenState extends State<mainInforScreen>{
  late Future<ProfileUser> profileuser;
  late String idUser;
  void initState(){
    super.initState();
    getIdUser();
  }
  void getIdUser ()async{
    SharedPreferences perfs= await SharedPreferences.getInstance();
    setState(() {
      idUser=perfs.getString("idUser")!;
      profileuser=fetchProfileUser(idUser);
    });
    print(idUser);
  }
  @override
  Widget build(BuildContext context){
    return  FutureBuilder(
      future: profileuser,
      builder: (context,abc){
        if(abc.data!.status){
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 320,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("Chỉ số khối cơ thể (BMI) ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    padding: EdgeInsets.all(15),
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Container(
                                width: 158,
                                height: 70,
                                child:Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 7.5, 0, 0),
                                      child: Text("BMI",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24
                                        ),
                                      ),
                                    ),
                                    Text("${(abc.data!.dataRes['weight']/(abc.data!.dataRes['height']/50)).toStringAsFixed(1)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(""),
                                width: 158,
                              ),
                            ]
                        ),
                        Row(
                          children: [
                            Container(
                              width: 158,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Chiều cao",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400
                                        ),),
                                      Text("${abc.data!.dataRes['height']} cm",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600
                                          )),
                                    ],
                                  ),
                                  AlertDialogTextField(title: "Chiều cao", itemChange: "height")
                                ],
                              ),
                            ),
                            Container(
                              width: 158,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Cân nặng",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400
                                        ),),
                                      Text("${abc.data!.dataRes['weight']} kg",style: TextStyle(
                                          fontWeight: FontWeight.w600
                                      )),
                                    ],
                                  ),
                                 AlertDialogTextField(title: "Cân nặng", itemChange: "weight")
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                width: 320,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child:Text("Thông tin cá nhân",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),),
              ),
              Card(title: "Tên", value: abc.data!.dataRes['full_name'],item: 'full_name',),
              Card(title: "Giới tính", value: abc.data!.dataRes['sex'],item: 'sex',),
              Card(title: "Tuổi", value: abc.data!.dataRes['age'].toString(),item: 'age',),
              Card(title: "Địa chỉ",value: abc.data!.dataRes['address'],item: 'address',)

            ],
          ),
          );
        }else if(!abc.data!.status){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddProfileScreen()),
          );
          return Text("");
        }else{
          return Text("");
        }

      },

    );
  }
}

class Card extends StatefulWidget{
  @override
  _CardState createState()=>_CardState();
  final String title;
  final String value;
  final String item;
  Card({
    required this.value,
    required this.title,
    required this.item,
});
}

class _CardState extends State<Card>{
  @override
  Widget build (BuildContext context){
    return Container(
      width: 350,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding:EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 100,
                  child: Text("${widget.title}",
                      style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Container(
                  width:185,
                  child: Text("${widget.value.toString()}",style:TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                AlertDialogTextField( title: widget.title ,itemChange: widget.item,)

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileUser {
  final bool status;
  final Map dataRes;
  ProfileUser({
    required this.dataRes,
    required this.status
});
  factory ProfileUser.fromJson(Map<String, dynamic> json){
    return ProfileUser(
        status: json['status'],
        dataRes: json['data']
    );
  }
}
Future<ProfileUser> fetchProfileUser(String idUser) async {
  var url=Uri.parse("http://192.168.50.106:5000/profile");
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'iduser':idUser,
    'password':'huyhoang'
  };
  final response = await http.get(url,headers: requestHeaders );
  if (response.statusCode == 200) {
    print(response.body);
    return ProfileUser.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
class AlertDialogTextField extends StatefulWidget{
  @override
  _AlertDialogTextFieldState createState()=>_AlertDialogTextFieldState();
  final String title;
  final String itemChange;
  AlertDialogTextField({
    required this.title,
    required this.itemChange,
});
}

class _AlertDialogTextFieldState extends State<AlertDialogTextField> {
  TextEditingController _textFieldController = TextEditingController();
  late String newValue='';

  void setNewValue(val){
    setState(() {
      newValue=val;
    });
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Thay đổi ${widget.title}'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Nhập ${widget.title} mới của bạn"),
              onChanged: (val)=>setNewValue(val),
            ),
            actions: [
              new ElevatedButton(
                child: new Text('Save'),
                onPressed: () {
                  changeInfor(widget.itemChange, newValue, '27113153');
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Information()),
                  );
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 40, height: 30),
      child: ElevatedButton(
        onPressed: () => _displayDialog(context),
        child: Icon(Icons.change_circle_outlined),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0.0,
            shadowColor: Colors.white,
            foregroundColor: Colors.grey
        ),
      ),
    );
  }
}
Future<http.Response> changeInfor(String itemChange, String newValue, String idUser ) async {
  final http.Response response = await http.put(
    Uri.parse('http://192.168.50.106:5000/profile'),
    body: {
      'itemChange':itemChange,
      'newValue':newValue

    },
    headers: <String, String>{
      'iduser': idUser
    },
  );
  print(response.body);
  return response;
}