import 'package:budairy/controller/budget/PreviousController.dart';
import 'package:budairy/model/budget/YearMonthResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'dateRecords.dart';







class monthRecords extends StatefulWidget {

  String year;

  monthRecords({this.year});

  @override
  _monthRecordsState createState() => _monthRecordsState(year: this.year);
}

class _monthRecordsState extends State<monthRecords> {

   String year;

  _monthRecordsState({this.year});


  List<YearMonthResponseModel> responseMonthModel=[];


   Widget display;


  @override
  void initState() {
    getMonthRecords(this.year);
    super.initState();
    display=shim();
  }




  getMonthRecords(String year) async {
    PreviousRecordController previousRecordController=new PreviousRecordController();
    responseMonthModel= await previousRecordController.getRecordByYearMonths(year);
    display=shim();
    if (responseMonthModel.isEmpty)
      display=empty();

    setState(() {

    });
  }



  @override
  Widget build(BuildContext context)  {
    return  Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('$year',
        style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18) ,)
        ),
    body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             Padding(
               padding: const EdgeInsets.only(top: 16),
               child: monthWidget(context, year),
             )
            ],
          ),
        ),
      ),
    );
  }




  Widget monthWidget(BuildContext,String year){
    return responseMonthModel.isEmpty
        ?Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: Center(child: display)
    )
        :Container(
      height: MediaQuery.of(context).size.height*0.8,
      child: ListView.builder(
        itemCount: responseMonthModel.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (ctxt, Index) => monthItem(ctxt, Index, year),
      ),
    );
  }

  Widget monthItem(BuildContext context,int index,String year){

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      dateRecords(month: responseMonthModel[index].key,year: this.year,)),
                );
                
                responseMonthModel=[];
                getMonthRecords(this.year);
                
              },
              child: ListTile(
                  title: Text(responseMonthModel[index].key+','+year),
                  trailing: Text('₹'+responseMonthModel[index].amount.toString(),
                    style: TextStyle(fontSize:20),)

              ),
            ),
          ),
        ),
        Divider(color: Colors.black,thickness: 2,)
      ],
    );
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
  return Container(
    child: Text('No Records'),
  );
}