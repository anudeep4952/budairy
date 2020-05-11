import 'package:budairy/controller/budget/PreviousController.dart';
import 'package:budairy/model/budget/YearMonthResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'individualRecords.dart';







class dateRecords extends StatefulWidget {

  String month;
  String year;

  dateRecords({this.month,this.year});

  @override
  _dateRecordsState createState() => _dateRecordsState(month: this.month,year: this.year);
}

class _dateRecordsState extends State<dateRecords> {

  String year;
  String month;

  _dateRecordsState({this.year,this.month});


  List<YearMonthResponseModel> responseDateModel=[];

  Widget display;



  @override
  void initState() {
    display=shim();
    getDateRecords(this.year,this.month);
    super.initState();
  }


  getDateRecords(String year,String month) async {
    PreviousRecordController previousRecordController=new PreviousRecordController();
    responseDateModel= await previousRecordController.getRecordByYearMonthDates(year,month);
    display=shim();
    if (responseDateModel.isEmpty)
      display=empty();

    setState(() {

     });
  }



  @override
  Widget build(BuildContext context)  {
    return  Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('$year > $month',
        style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18) ,)
        ),
    body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             dateWidget(context, year, month)
            ],
          ),
        ),
      ),
    );
  }




  Widget dateWidget(BuildContext,String year,String month){
    return responseDateModel.isEmpty
        ?Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: Center(child: display)
    )
        :Container(
      height: MediaQuery.of(context).size.height*0.8,
      child: ListView.builder(
        itemCount: responseDateModel.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (cntxt,Index)=> dateItem(cntxt,Index,year,month),
      ),
    );
  }

  Widget dateItem(BuildContext context,int index,String year,String month){

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: InkWell(
              onTap: () async {
               await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      individualRecords(month:this.month,year: this.year,date:responseDateModel[index].key)),
                );

               responseDateModel=[];
               getDateRecords(this.year, this.month);

              },
              child: ListTile(
                  title: Text(responseDateModel[index].key+' ,'+month+' '+year),
                  trailing: Text('₹'+responseDateModel[index].amount.toString(),
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