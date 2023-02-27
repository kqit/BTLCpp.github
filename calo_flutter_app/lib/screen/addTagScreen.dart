import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:calo_flutter_app/screen/homescreen.dart';

class AddTagScreen extends StatefulWidget{

  @override
  final String buoi;
  final DateTime time;
  const AddTagScreen({
    required this.buoi,
    required this.time
  });
  _AddTagScreen createState()=>_AddTagScreen();
}
class _AddTagScreen extends State<AddTagScreen>{
  late Future<ListResult> listresult;
  late bool hasData=false;
  late String idUser;
  void initState(){
    super.initState();
    listresult=FetchListResult('');
  }

  void setListresult(String x){
    setState(() {
      listresult=FetchListResult(x);
      hasData=true;
    });
  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 1,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
            appBar: AppBar(
              title: Text("${widget.buoi}"),
              bottom: TabBar(
                tabs: [
                    TextField(
                      onChanged: (val){
                        setListresult(val);
                      },
                      decoration: InputDecoration(

                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.black54,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Tìm kiếm",
                    ),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MainScreen(session: widget.buoi,time: widget.time,listResult: listresult, hasData: hasData,)
              ],
            )
        )
    );
  }
}

class MainScreen extends StatefulWidget{
  final String session;
  final DateTime time;
  final Future<ListResult> listResult;
  final bool hasData;
  MainScreen({
    required this.session,
    required this.time,
    required this.listResult,
    required this.hasData
});

  @override
  _MainScreenState createState()=>_MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
  List<TextEditingController> _controller = [];
  late Future<ListFood> listfood;
  late List listMass=['100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100','100'];
  late String session;
  late String idUser;
  late String date;
  void initState(){
    super.initState();
    listfood=FetchListFood();
    getIdUser();
  }
  void setDate(){
    setState((){
      date="${widget.time.year}-${widget.time.month}-${widget.time.day}";
    });
    print(date);
  }
  void getIdUser()async{

    SharedPreferences perfs= await SharedPreferences.getInstance();
    setState(() {
      idUser=perfs.getString("idUser")!;
    });

  }
  void setListMass(index,value){
    setState(() {
      listMass[index]=value;
    });
  }
  void createSession(){
    if(widget.session=="Bữa sáng"){
      setState(() {
        session="morning";
      });
    }else if(widget.session=="Bữa trưa"){
      setState(() {
        session="afternoon";
      });
    }else if(widget.session=="Bữa tối"){
      setState(() {
        session="night";
      });
    }else if(widget.session=="Bữa khác"){
      setState(() {
        session="other";
      });
    }
  }
  @override

  Widget build(BuildContext context){
    if(!widget.hasData){
      return FutureBuilder(
          future: listfood,
          builder:(context,abc){
            print(double.parse(listMass[0]).runtimeType);
            if(abc.hasData){
              return Container(
                  child: Column(
                    children: [
                      Expanded(
                        child:
                        ListView.builder(
                            itemCount: abc.data!.dataRes.length,
                            itemBuilder: (context,index){
                              _controller.add(TextEditingController());
                              return ListTile(
                                  title: Container(
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
                                            Text("${abc.data!.dataRes[index]['name']}",
                                              style: TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 20,
                                                  child: TextField(
                                                    controller: _controller[index],
                                                    onChanged: (number){
                                                      if(number==""){
                                                        setListMass(index, "0");
                                                      }else{
                                                        setListMass(index, number);
                                                      }
                                                    },
                                                    keyboardType: TextInputType.number,
                                                  ),
                                                ),
                                                Text(" gam -   "),
                                                Text("${(abc.data!.dataRes[index]['calo_per_100gr']/100*double.parse(listMass[index])).toStringAsFixed(2)} kcal")
                                              ],
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            createSession();
                                            setDate();
                                            createTag(idUser, abc.data!.dataRes[index]['id_food'], date, session, double.parse(listMass[index]));
                                            print(date);
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => HomeScreen()),
                                            );
                                          },
                                          child: Icon(Icons.add),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(228, 228, 228, 1)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }
                        ),
                      )
                    ],
                  )
              );
            }
            else if(abc.hasError){
              return Container(
                child: Text("${abc.error}"),
              );
            }
            return CircularProgressIndicator();
          });
    }else{
      return FutureBuilder(
          future: widget.listResult,
          builder:(context,abc){
            print(double.parse(listMass[0]).runtimeType);
            if(abc.hasData){
              return Container(
                  child: Column(
                    children: [
                      Expanded(
                        child:
                        ListView.builder(
                            itemCount: abc.data!.dataRes.length,
                            itemBuilder: (context,index){
                              _controller.add(TextEditingController());
                              return ListTile(
                                  title: Container(
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
                                            Text("${abc.data!.dataRes[index]['name']}",
                                              style: TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 20,
                                                  child: TextField(
                                                    controller: _controller[index],
                                                    onChanged: (number){
                                                      if(number==""){
                                                        setListMass(index, "0");
                                                      }else{
                                                        setListMass(index, number);
                                                      }
                                                    },
                                                    keyboardType: TextInputType.number,
                                                  ),
                                                ),
                                                Text(" gam -   "),
                                                Text("${(abc.data!.dataRes[index]['calo_per_100gr']/100*double.parse(listMass[index])).toStringAsFixed(2)} kcal")
                                              ],
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            createSession();
                                            setDate();
                                            createTag(idUser, abc.data!.dataRes[index]['id_food'], date, session, double.parse(listMass[index]));
                                            print(date);
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => HomeScreen()),
                                            );
                                          },
                                          child: Icon(Icons.add),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(228, 228, 228, 1)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }
                        ),
                      )
                    ],
                  )
              );
            }
            else if(abc.hasError){
              return Container(
                child: Text(""),
              );
            }
            return CircularProgressIndicator();
          });
    }
  }
}

////////API//////////

class ListFood{
  final bool status;
  final List dataRes;
  ListFood({
    required this.status,
    required this.dataRes
});
  factory ListFood.fromJson(Map<String, dynamic> json){
    return ListFood(
        status: json['status'],
        dataRes: json['data'],
    );
  }
}
Future<ListFood> FetchListFood() async{
  var url=Uri.parse("http://192.168.50.106:5000/food?limit=10");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print(response.body);
    return ListFood.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
Future<http.Response> createTag(String idUser, String idFood, String date, String session, double mass) {

  return http.post(
    Uri.parse("http://192.168.50.106:5000/tag"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'idUser':idUser
    },
    body: jsonEncode(<String, String>{
      'idFood': idFood,
      'date' :date,
      'session':session,
      'mass': mass.toString(),
    }),
  );
}
Future<http.Response> deleteTag(String idTag) async {
  final http.Response response = await http.delete(
    Uri.parse("http://192.168.50.106:5000/tag"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'idTag': idTag
    },
  );
  return response;
}
class ListResult{
  final bool status;
  final List dataRes;
  ListResult({
    required this.status,
    required this.dataRes
});
  factory ListResult.fromJson(Map<String, dynamic> json){
    return ListResult(
      status: json['status'],
      dataRes: json['searchResult'],
    );
  }
}
Future<ListResult> FetchListResult(String searchLetter) async{
  var url=Uri.parse("http://192.168.50.106:5000/nutritionlookup?searchLetter=${searchLetter}&limit=15");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print(response.body);
    return ListResult.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}