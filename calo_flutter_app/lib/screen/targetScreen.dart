import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void loadTime() async{
  await Future.delayed(Duration(seconds: 3));
}
class TargetScreen extends StatelessWidget{
  @override
  Widget build (BuildContext context){

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      appBar: AppBar(
        title: Text("Mục tiêu hàng ngày"),
      ),
      body:Column(
        children:[
          TargetMainScreen(),
        ]

      )
    );
  }
}
class TargetMainScreen extends StatefulWidget{
  @override
  _TargetMainScreenState createState()=>_TargetMainScreenState();
}
class _TargetMainScreenState extends State<TargetMainScreen>{
  late Future<dataTarget> datatarget;
  late String newCalo='', newCar='', newPro='', newLip='';
  late String idUser;
  void initState(){
    super.initState();
    getIdUser();
  }
  void getIdUser()async{
    SharedPreferences perfs=await SharedPreferences.getInstance();
    setState(() {
      idUser=perfs.getString("idUser")!;
    });
    setState(() {
      datatarget=FetchTarget(idUser);
    });
  }
  @override
  Widget build (BuildContext context){
    return FutureBuilder(
      future: datatarget,
      builder: (context, abc){
        if(abc.hasData){
          return Container(
            margin: EdgeInsets.all(18),
            width: MediaQuery.of(context).size.width*90/100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 18, 0, 0),
                        width: 384*40/100,
                        child: Text("Dinh dưỡng",
                          style: TextStyle(
                              color: Colors.red
                          ),),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                          width: 384*45/100,
                          child: Text("Mục tiêu đặt ra hàng ngày",
                              style: TextStyle(
                                  color: Colors.red
                              ))
                      )
                    ],
                  ),
                ),
                Tag(title: "Năng lượng (Kcal)",data: abc.data!.dataRes['calo'],callback: (val){setState(() {
                  newCalo=val;
                  print(newCalo);
                });},),
                Tag(title: "Tổng chất béo (g)",data: abc.data!.dataRes['lipit'],callback: (val){setState(() {
                  newLip=val;
                  print(newLip);
                });},),
                Tag(title: "Cacbohydrate (g)",data: abc.data!.dataRes['cacbohydrate'],callback: (val){ setState ((){
                  newCar = val;
                });}),
                Tag(title: "Protein (g)",data: abc.data!.dataRes['protein'],callback: (val){setState(() {
                  newPro=val;
                });}),
                ElevatedButton(onPressed: (){
                  changeTarget(newCalo,newCar,newLip,newPro,idUser);
                }, child:Text("Save") )
              ],
            ),
          );
        }else if(!abc.data!.dataRes['status']){
          return Container(
            margin: EdgeInsets.all(18),
            width: MediaQuery.of(context).size.width*90/100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 18, 0, 0),
                        width: 384*40/100,
                        child: Text("Dinh dưỡng",
                          style: TextStyle(
                              color: Colors.red
                          ),),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                          width: 384*45/100,
                          child: Text("Mục tiêu đặt ra hàng ngày",
                              style: TextStyle(
                                  color: Colors.red
                              ))
                      )
                    ],
                  ),
                ),
                Tag(title: "Năng lượng (Kcal)",data: 0,callback: (val){setState(() {
                  newCalo=val;
                  print(newCalo);
                });},),
                Tag(title: "Tổng chất béo (g)",data: 0,callback: (val){setState(() {
                  newLip=val;
                  print(newLip);
                });},),
                Tag(title: "Cacbohydrate (g)",data: 0,callback: (val){ setState ((){
                  newCar = val;
                });}),
                Tag(title: "Protein (g)",data: 0,callback: (val){setState(() {
                  newPro=val;
                });}),
                ElevatedButton(onPressed: (){
                  createTarget(newCalo,newCar,newLip,newPro,idUser);
                }, child:Text("Save") )
              ],
            ),
          );
        }else if(abc.hasError) {
          return Text("");
        }else{
          return CircularProgressIndicator();
        }
      },
    ) ;
  }
}
typedef void StringCallback(String val);
class Tag extends StatefulWidget{
  @override
  _TagState createState()=>_TagState();
  final String title;
  final num data;
  final StringCallback callback;
  Tag({
    required this.title,
    required this.data,
    required this.callback
});
}
class _TagState extends State<Tag>{
  late TextEditingController _controller=new TextEditingController();
  void initState(){
    super.initState();
    _controller.text=widget.data.toString();
  }
  @override
  Widget build (BuildContext context){
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 18, 0, 0),
            width: 384*40/100,
            child: Text("${widget.title}",
            style: TextStyle(
              fontWeight: FontWeight.w500
            ),),
          ),
          Container(
            width: 384*45/100,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              onChanged: (val){
                widget.callback(val);
              },
            )
          )
        ],
      ),
    );
  }
}
class dataTarget{
  final bool status;
  final Map dataRes;
  dataTarget({
    required this.status,
    required this.dataRes
});
  factory dataTarget.fromJson(Map<String, dynamic> json){
    return dataTarget(
      status: json['status'],
      dataRes: json['data'],
    );
  }
}
Future<dataTarget> FetchTarget(String idUser) async{
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'idUser':idUser,
  };
  var url=Uri.parse("http://192.168.50.106:5000/target");
  final response = await http.get(url,headers: requestHeaders);
  if (response.statusCode == 200) {
    print(response.body);
    return dataTarget.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
Future<http.Response> changeTarget(String newCalo, String newCar, String newLip, String newPro,String idUser ) async {

  final http.Response response = await http.put(
    Uri.parse('http://192.168.50.106:5000/target'),
    body: {
      'calo':newCalo,
      'cacbohydrate':newCar,
      'lipit':newLip,
      'protein':newPro,
    },
    headers: <String, String>{
      'iduser': idUser
    },
  );
  print(response.body);
  return response;
}
Future<http.Response> createTarget(String newCalo, String newCar, String newLip, String newPro,String idUser ) async {

  final http.Response response = await http.post(
    Uri.parse('http://192.168.50.106:5000/target'),
    body: {
      'calo':newCalo,
      'cacbohydrate':newCar,
      'lipit':newLip,
      'protein':newPro,
    },
    headers: <String, String>{
      'iduser': idUser
    },
  );
  print(response.body);
  return response;
}