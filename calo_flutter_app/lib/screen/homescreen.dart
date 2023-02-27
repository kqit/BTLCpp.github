import 'dart:convert';
import 'package:calo_flutter_app/screen/fullTagScreen.dart';
import 'package:flutter/material.dart';
import 'package:calo_flutter_app/screen/fullTagScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:calo_flutter_app/screen/menu.dart';
import 'package:calo_flutter_app/screen/addTagScreen.dart';
import 'package:http/http.dart' as http ;

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState()=> _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late DateTime _time=DateTime.now();
  late String abc;
  set time(DateTime value) => setState(() => _time = value);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child:Scaffold(
          appBar: AppBar(
            title:Text("Calories") ,
            actions: [DatePickerDemo(callback:(val) =>setState(() {
              _time=val;
            }),)],
            bottom: TabBar(
              tabs: [
                Tab(text: "Bữa sáng"),
                Tab(text: "Bữa trưa"),
                Tab(text: "Bữa tối"),
                Tab(text: "Bữa khác"),
              ],
            ),
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            overlayStyle: ExpandableFabOverlayStyle(
              blur: 5,
            ),
            onOpen: () {
              debugPrint('onOpen');
            },
            afterOpen: () {
              debugPrint('afterOpen');
            },
            onClose: () {
              debugPrint('onClose');
            },
            afterClose: () {
              debugPrint('afterClose');
            },
            children: [
              FloatingActionButton.small(
                heroTag: null,
                child: Text("Sáng"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTagScreen(buoi: "Bữa sáng",time: _time,)),
                  );
                },
              ),
              FloatingActionButton.small(
                heroTag: null,
                child: Text("Trưa"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTagScreen(buoi: "Bữa trưa",time: _time)),
                  );
                },
              ),
              FloatingActionButton.small(
                heroTag: null,
                child: const Text("Tối"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTagScreen(buoi: "Bữa tối",time: _time)),
                  );
                },
              ),
              FloatingActionButton.small(
                heroTag: null,
                child: Text("Khác"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTagScreen(buoi: "Bữa khác",time: _time)),
                  );
                },
              ),
            ],
          ),
            drawer: Drawer(
            child: menu(),
          ),
          backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
          body: TabBarView(
            children:[
              schedule(buoi: "Bữa sáng",date: "${_time.year}-${_time.month}-${_time.day}",),
              schedule(buoi: "Bữa trưa",date: "${_time.year}-${_time.month}-${_time.day}"),
              schedule(buoi: "Bữa tối",date: "${_time.year}-${_time.month}-${_time.day}"),
              schedule(buoi: "Bữa khác",date: "${_time.year}-${_time.month}-${_time.day}"),
            ]
          )
          )
        );
  }
}
typedef void StringCallback(DateTime val);
class DatePickerDemo extends StatefulWidget {
  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
  final StringCallback callback;

  DatePickerDemo({
    required this.callback,

  });
}

class _DatePickerDemoState extends State<DatePickerDemo> {

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, 
      firstDate: DateTime(2000),
      lastDate: DateTime(2025)
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
      widget.callback(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Icon(Icons.date_range)
            ),
            Text(
              "${selectedDate.day} thg ${selectedDate.month}",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
class schedule extends StatefulWidget{
  final String buoi;
  final String date;
  const schedule({
    required this.buoi,
    required this.date
});
  @override
  _scheduleState createState() =>_scheduleState();
}
class _scheduleState extends State<schedule>{
  @override
  late Future<ListTag> listtag;
  late String session;
  late int count=0;
  late String idUser="";

  void initState() {
    super.initState();
    if(widget.buoi=="Bữa sáng"){
      session="morning";
    }else if(widget.buoi=="Bữa trưa"){
      session="afternoon";
    }else if(widget.buoi=="Bữa tối"){
      session="night";
    }else if(widget.buoi=="Bữa khác"){
      session="other";
    };
    getIdUser();

  }
  void getIdUser()async{
    SharedPreferences perfs= await SharedPreferences.getInstance();
    setState(() {
      idUser=perfs.getString("idUser")!;
    });
    print(idUser);
    listtag = fetchListTag(idUser,widget.date,session);
  }
  void setCount(){
    setState(() {
      count+=1;
    });
  }
  Widget build (BuildContext context){
    return(FutureBuilder(
        future: listtag,
        builder: (context , xyz) {
          if(xyz.hasData && xyz.data!.status==true){
            return Column(
              children: [
                Container(margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width:400 ,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("Tổng cộng",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                      Container(
                        child:Text("${
                          xyz.data!.DataRes.fold(0.0,(value, element) => value+=element['mass']/100*element['calo_per_100gr'])
                        } kcal")
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                  ListView.builder(
                      itemCount: xyz.data!.DataRes.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          title:OutlinedButton(
                              onPressed: (){
                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => FullTagScreen(
                                        title: xyz.data!.DataRes[index]['name'],
                                        idTag: xyz.data!.DataRes[index]['id_tag'],

                                      )),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white
                              ),
                              child: Container(
                                width: 400,
                                height: 70,
                                padding: EdgeInsets.all(15.0),
                                margin: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all( Radius.circular(15))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("${xyz.data!.DataRes[index]["name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            fontSize: 18
                                          ),
                                        ),
                                        Text("${xyz.data!.DataRes[index]["mass"]} g - ${xyz.data!.DataRes[index]["mass"]/100*xyz.data!.DataRes[index]["calo_per_100gr"]} calo")
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: (){
                                        deleteTag(xyz.data!.DataRes[index]['id_tag']);
                                      },
                                      child: Icon(Icons.close),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(228, 228, 228, 1)),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          )
                        );
                      }
                  ),

                ),
              ],
            );
          }
          else if(!xyz.hasData){
            return Text("");
          }else if(xyz.hasData&&xyz.data!.status==false){
            return Text("Chưa có khẩu phần ăn nào");
          }

          return CircularProgressIndicator();
        }
    )
    );
  }
}
class User{
  final String notification;
  final String idUser;
  const User({
    required this.notification,
    required this.idUser
});
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      notification: json['notification'],
      idUser: json['idUser']
    );
  }
}
Future<User> fetchUser() async {
  var url=Uri.parse("http://192.168.50.106:5000/login");
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'username':'huyhoang',
    'password':'huyhoang'
  };
  final response = await http.get(url,headers: requestHeaders );
  if (response.statusCode == 200) {
    print(response.body);
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
class ListTag{
  final bool status;
  final List DataRes;
  const ListTag({
    required this.status,
    required this.DataRes
  });
  factory ListTag.fromJson(Map<String, dynamic> json){
    return ListTag(
        status: json['status'],
        DataRes: json['data']
    );
  }
}
Future<ListTag> fetchListTag(String idUser,String date, String session) async {
  var url=Uri.parse("http://192.168.50.106:5000/session");
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'idUser':idUser,
    'date':date,
    'session':session
  };
  final response = await http.get(url,headers: requestHeaders );
  if (response.statusCode == 200) {
    print(response.body);
    return ListTag.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
Future<http.Response> deleteTag(String idTag) async {
  final http.Response response = await http.delete(
    Uri.parse('http://192.168.50.106:5000/tag'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'idTag': idTag
    },
  );
  return response;
}