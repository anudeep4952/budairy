import 'package:budairy/controller/budget/PreviousController.dart';
import 'package:budairy/model/budget/YearMonthResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'monthRecords.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {

  List<YearMonthResponseModel> responseYearModel = [];
  Widget display;



  @override
  void initState() {
    display=shim();
    getYearRecords();
    super.initState();
  }


  getYearRecords() async {
    display=shim();
    PreviousRecordController previousRecordController = new PreviousRecordController();
    responseYearModel =
    await previousRecordController.getRecordByYears();
    if (responseYearModel.isEmpty)
      display=empty();

    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          yearWidget(context)
        ],
      ),
    );
  }


  Widget yearWidget(BuildContext) {
    return responseYearModel.isEmpty
        ? Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: Center(child: display)
    )
        : ListView.builder(
          itemCount: responseYearModel.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: yearItem,
        );
  }

  Widget yearItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1)
        ),
        child: InkWell(
          onTap: () async {
           await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  monthRecords(year: responseYearModel[index].key)),
            );
           responseYearModel=[];
           getYearRecords();
          },
          child: ListTile(
              title: Text(responseYearModel[index].key),
              trailing: Text('₹' + responseYearModel[index].amount.toString(),
                style: TextStyle(fontSize: 20),)

          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}

Widget shim(){
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: SingleChildScrollView(
      child: Column(
          children: new List<int>.generate(20, (i) => i + 1)
              .map((_) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(

                title:Container(
                  width: 50,
                  height: 8.0,
                  color: Colors.white,
                ),
                trailing: Container(width: 40,height: 40,color:Colors.white )
            ),
          ))
              .toList()

      ),
    ),
  );

}

Widget empty (){
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text('No Records'),
        ),
      ],
  );
}
