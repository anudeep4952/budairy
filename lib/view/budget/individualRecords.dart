import 'package:budairy/controller/budget/PreviousController.dart';
import 'package:budairy/controller/budget/RecordController.dart';
import 'package:budairy/model/budget/DateRecordModel.dart';
import 'package:budairy/model/budget/YearMonthResponseModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';





class individualRecords extends StatefulWidget {

  String month;
  String year;
  String date;

  individualRecords({this.month,this.year,this.date});

  @override
  _individualRecordsState createState() => _individualRecordsState(month: this.month,year: this.year,date: this.date);
}

class _individualRecordsState extends State<individualRecords> {

  String year;
  String month;
  String date;

  _individualRecordsState({this.year,this.month,this.date});


  List<YearMonthResponseModel> responseDateModel=[];
  List<BudgetRecordModel> responseRecordModel=[];
  Widget display;



  @override
  void initState() {
    display=shim();
    getRecordsOfDate(this.year,this.month,this.date);
    super.initState();
  }



  getRecordsOfDate(String year,String month,String date) async {
    PreviousRecordController previousRecordController=new PreviousRecordController();
    responseRecordModel= await previousRecordController.getSpecificRecords( year, month, date);
    display=shim();
    if (responseRecordModel.isEmpty)
      display=empty();
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context)  {
    return  Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
      title: Text('$year > $month > $date',
        style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18) ,),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              recordWidget(context, year, month,date)
            ],
          ),
        ),
      ),
    );
  }





  Widget recordWidget(BuildContext context,String year,String month,String date){


    return responseRecordModel.isEmpty
        ?Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: Center(child: display)
    )
        : ListView.builder(
          itemCount: responseRecordModel.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (cntxt,Index)=> recordItem(cntxt,Index,year,month,date),
        );

  }

  Widget recordItem(BuildContext context,int index,String year,String month,String date){



    var response;
    PreviousRecordController previousRecordController=new PreviousRecordController();


    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Column(
        children: <Widget>[
          Container(
            decoration:BoxDecoration(
                border: Border.all(color: Colors.grey,width: 1)
            ),
            child: ListTile(
                title:  Text(responseRecordModel[index].need),
                subtitle:Text(responseRecordModel[index].time,style: TextStyle(color: Colors.green),),
                trailing: Text(
                  '₹' + responseRecordModel[index].amount.toString(),
                  style: TextStyle(fontSize: 20),
                )),
          ),

        ],
      ),
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black,width: 1))
          ),
          child: IconSlideAction(
            caption: 'Edit',
            color: Colors.white,
            iconWidget:Icon(Icons.edit,color: Colors.black,) ,
            onTap: (){
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Edit Record"),
                    content:  new FullScreenDialog(responseRecordModel: responseRecordModel[index],),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((_){
                getRecordsOfDate(this.year, this.month, this.date);
              });
            },
          ),
        ),
        IconSlideAction(
            caption: 'Delete',
            color: Colors.white,
            iconWidget: Icon(Icons.delete,color: Colors.black),
            onTap: () =>showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Delete ?"),
                  content: new Text("operation can't be undone"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Delete"),
                      onPressed: () async {
                        response=await previousRecordController.deleteRecord(responseRecordModel[index].recordId);
                        responseRecordModel.removeAt(index);
                        Toast.show("Deleted", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        Navigator.of(context).pop();
                        getRecordsOfDate(this.year, this.month, this.date);

                      },
                    ),
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            )
        ),
      ],
    );
  }


}


Widget shim(){
  return ListView(
    children: <Widget>[
      Text("No Records",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
      Shimmer.fromColors(
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
      ),
    ],
  );
}

Widget empty (){
  return Container(
    child: Text('No Records'),
  );
}


class FullScreenDialog extends StatefulWidget {

  BudgetRecordModel responseRecordModel;

  FullScreenDialog({this.responseRecordModel});


  @override
  FullScreenDialogState createState() => new FullScreenDialogState(this.responseRecordModel.year,this.responseRecordModel.month,this.responseRecordModel.date);
}

class FullScreenDialogState extends State<FullScreenDialog> {

  DateTime selectedDate;

  final dateFormat =new  DateFormat("MMMM-d-yyyy");
  DateTime value;

  final _formKey = GlobalKey<FormState>();

  BudgetRecordController rc=new BudgetRecordController();

  var y;
  var m;
  var d;
  FullScreenDialogState(this.y,this.m,this.d){
    this.selectedDate=dateFormat.parse(this.m+'-'+this.d+'-'+this.y);
  }


  @override
  Widget build(BuildContext context) {

    final amountController = TextEditingController(text: widget.responseRecordModel.amount.toString());
    final reasonController = TextEditingController(text: widget.responseRecordModel.need);

    /*var y=widget.responseRecordModel.year;
    var m=widget.responseRecordModel.month;
    var d=widget.responseRecordModel.date;
*/

    return SizedBox(
      height: 300,

      child: new Scaffold(
          body: new Padding(child: Form(
            key: _formKey,
            child: new ListView(
              children: <Widget>[
                new DateTimeField(
                  validator: (val){
                    if(val==null)
                      return 'cant be empty';
                  },
                  initialValue: selectedDate,
                  format: dateFormat,
                  onShowPicker: (context, currentValue) async {
                    await showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoDatePicker(
                            maximumDate: new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day+1),
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime date) {
                              value = date;
                            },
                          );
                        });
                    setState(() {
                      this.selectedDate=value;
                    });
                    return value;
                  },
                ),
                new  Theme(
                    data: new ThemeData(
                      cursorColor: Colors.black,
                      primaryColor: Colors.black,
                      primaryColorDark: Colors.black,
                    ),
                    child: new TextFormField(
                      controller: amountController,
                      maxLines: null,
                      validator: (val) {
                        if (val.length == 0) {
                          return 'amount cant be 0';
                        } else {
                          if (int.parse(val) < 1) {
                            return 'amount cant be 0';
                          } else {
                            return null;
                          }
                        }
                      },
                      decoration: new InputDecoration(
                        prefixIcon: const Icon(
                          FontAwesomeIcons.rupeeSign,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    )),
                new Theme(
                    data: new ThemeData(
                      cursorColor: Colors.black,
                      primaryColor: Colors.black,
                      primaryColorDark: Colors.black,
                    ),
                    child: new TextFormField(
                      controller: reasonController,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val.length == 0) {
                          return "Reason cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: new InputDecoration(
                        hintText: 'Spent For',
                        labelText: 'Reason',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.readme,
                          color: Colors.black,
                        ),
                      ),
                    )),
                new Row(
                  children: <Widget>[
                    new Expanded(child: new RaisedButton(onPressed: ()async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        FocusScope.of(context).requestFocus(FocusNode());
                        String dt=dateFormat.format(selectedDate);
                        List l=dt.split("-");
                        await rc.updateRecord(widget.responseRecordModel.recordId, l[0], l[1], l[2], int.parse(amountController.text), reasonController.text);
                        Navigator.of(context).pop();
                        Toast.show('edited', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      }
                    }, child: new Text("Save"),))
                  ],
                )
              ],
            ),
          ), padding: const EdgeInsets.symmetric(horizontal: 20.0),)
      ),
    );
  }


}