import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'package:calo_flutter_app/screen/homescreen.dart';

class FullTagScreen extends StatefulWidget{
  @override
  _FullTagScreenState createState()=>_FullTagScreenState();
  final String title;
  final String idTag;
  FullTagScreen({
    required this.title,
    required this.idTag,
});
}
class _FullTagScreenState extends State<FullTagScreen>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: MainScreen(idTag: widget.idTag,),
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
    );
  }
}
class MainScreen extends StatefulWidget{
  @override
  final String idTag;
  MainScreen({
    required this.idTag
});
  _MainScreenState createState()=>_MainScreenState();

}
class _MainScreenState extends State<MainScreen>{
  late Future<fullTag> fulltag;
  late int mass;
  late TextEditingController _controllerMass= TextEditingController();
  void initState(){
    super.initState();
    fulltag=fetchFullTag(widget.idTag) ;
    mass=0;
  }
  void setMass(int value){
    setState(() {
      mass=value;
    });
  }
  @override
  Widget build (BuildContext context){
    return FutureBuilder(
      future: fulltag,
      builder: (context,abc){
        _controllerMass.text=abc.data!.dataRes['mass'].toString();
        if(abc.hasData) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                Text("Thành phần dinh dưỡng",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 384 * 20 / 100,
                        height: 50,

                        padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "${abc.data!.dataRes['mass']}"
                          ),
                          onChanged: (value){
                            setMass(int.parse(value));
                          },
                        ),
                      ),
                      Container(
                        width: 384 * 70 / 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.fromLTRB(125, 14, 125, 14),
                        child: Text("g"),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 90 / 100,
                    color: Colors.white,
                    child: Row(
                        children: [
                          Container(
                            width: 190,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Chart(
                              car: abc.data!.dataRes['cacbohydrate_per_100gr']*3.7,
                              lip: abc.data!.dataRes['lipit_per_100gr']*9.0,
                              pro: abc.data!.dataRes['protein_per_100gr']*4.0,),
                          ),
                          Container(
                            width: 135,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      color: Colors.white,
                                    ),

                                    Text("Calo   ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text("${
                                        mass==0?
                                        abc.data!.dataRes['calo_per_100gr']*abc.data!.dataRes['mass']/100:
                                        double.parse((abc.data!.dataRes['calo_per_100gr']*mass/100).toString()).toStringAsFixed(1)
                                    } Kcal")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      color: Color.fromRGBO(147, 0, 119, 1),
                                    ),
                                    Text("Carb   "),
                                    Text("${
                                        mass==0?
                                        abc.data!.dataRes['cacbohydrate_per_100gr']*abc.data!.dataRes['mass']/100:
                                        double.parse((abc.data!.dataRes['cacbohydrate_per_100gr']*mass/100).toString()).toStringAsFixed(1)
                                    } g")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      color: Color.fromRGBO(228, 0, 124, 1),
                                    ),
                                    Text("Lip      "),
                                    Text("${
                                        mass==0?
                                        abc.data!.dataRes['lipit_per_100gr']*abc.data!.dataRes['mass']/100:
                                        double.parse((abc.data!.dataRes['lipit_per_100gr']*mass/100).toString()).toStringAsFixed(1)
                                    } g")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 15,
                                      height: 15,
                                      color: Color.fromRGBO(255,189,57,1),
                                    ),
                                    Text("Pro      "),
                                    Text("${
                                        mass==0?
                                        abc.data!.dataRes['protein_per_100gr']*abc.data!.dataRes['mass']/100:
                                        double.parse((abc.data!.dataRes['protein_per_100gr']*mass/100).toString()).toStringAsFixed(1)
                                    } g")
                                  ],
                                )
                              ],
                            ),
                          )
                        ]
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ElevatedButton(
                    onPressed: (){
                      updateTag(widget.idTag, mass);
                      Navigator.pop(context,true);
                    },
                    child: Text("Save"),
                  )
                )
              ],
            ),
          );
        }else {
          return Container(
            child: Text("Không có dữ liệu"),
          );
        }
      }
    );
  }
}
class Chart extends StatefulWidget{
  _ChartState createState()=> _ChartState();
  final double car;
  final double lip;
  final double pro;
  Chart({
    required this.car,
    required this.lip,
    required this.pro
});
}
class _ChartState extends State<Chart>{
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Steve', widget.car, Color.fromRGBO(147,0,119,1),"${(widget.car/(widget.car+widget.pro+widget.lip)*100).toStringAsFixed(1)}%"),
      ChartData('Jack', widget.lip, Color.fromRGBO(228,0,124,1),"${(widget.lip/(widget.car+widget.pro+widget.lip)*100).toStringAsFixed(1)}%"),
      ChartData('Others', widget.pro, Color.fromRGBO(255,189,57,1),"${(widget.pro/(widget.car+widget.pro+widget.lip)*100).toStringAsFixed(1)}%")
    ];
    return Container(
        child: Center(
            child: Container(
                child: SfCircularChart(
                    series: <CircularSeries>[
                      // Renders doughnut chart
                      DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper:(ChartData data,  _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                        dataLabelMapper: (ChartData data,_)=>data.text,
                        radius: '80%',
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true
                        )
                      )
                    ]
                )
            )
        )
    );
  }
}
class ChartData {
  ChartData(this.x, this.y, this.color, this.text);
  final String text;
  final String x;
  final double y;
  final Color color;
}
//////API///////
class fullTag{
  final bool status;
  final Map dataRes;
  fullTag({
    required this.status,
    required this.dataRes,
  });
  factory fullTag.fromJson(Map<String, dynamic> json){
    return fullTag(
        status: json['status'],
        dataRes: json['data'],
    );
  }
}
Future<fullTag> fetchFullTag(String idTag) async {
  var url=Uri.parse("http://192.168.50.106:5000/tag");
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'id_tag':idTag,
  };
  final response = await http.get(url,headers: requestHeaders );
  if (response.statusCode == 200) {
    print(response.body);
    return fullTag.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
Future<http.Response> updateTag(String idTag, int newMass) async {
  final http.Response response = await http.put(
    Uri.parse('http://192.168.50.106:5000/tag'),
    body: {
      'idTag':idTag,
      'newMass':newMass.toString()
    }
  );
  return response;
}