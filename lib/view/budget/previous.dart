import 'package:budairy/controller/budget/PreviousController.dart';
import 'package:budairy/controller/budget/RecordController.dart';
import 'package:budairy/model/budget/DateRecordModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:toast/toast.dart';

class Previous extends StatefulWidget {
  @override
  _PreviousState createState() => _PreviousState();
}

class _PreviousState extends State<Previous> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = new DateTime.now();
  PreviousRecordController previousRecordController =
      new PreviousRecordController();
  final dateFormat = DateFormat("MMMM-d-yyyy");
  DateTime value;
  DateTime now = DateTime.now();
  var response;

  List<BudgetRecordModel> responseRecordModel = [];
  List l;

  getRecords(String year, String month, String date) async {
    responseRecordModel =
        await previousRecordController.getSpecificRecords(year, month, date);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    BudgetRecordController rc = new BudgetRecordController();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
            child: DateTimeField(
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.date_range,color: Colors.black,),
                    focusColor: Colors.green,
                    hintText: 'MM-DD-YYYY',
                ),
              validator: (val) {
                if (val == null) return 'cant be empty';
              },
              initialValue: DateTime.now(),
              format: dateFormat,
              onShowPicker: (context, currentValue) async {
                await showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoDatePicker(
                        maximumDate: new DateTime(
                            new DateTime.now().year,
                            new DateTime.now().month,
                            new DateTime.now().day + 1),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime date) {
                          value = date;
                        },
                      );
                    });
                setState(() {
                  this.selectedDate = value;
                });
                return value;
              },
            ),
          ),
          ///////////////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: EdgeInsets.only(
                top: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.blue,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String dt = dateFormat.format(selectedDate);
                        l = dt.split("-");
                        await getRecords(l[2], l[0], l[1]);
                        if (responseRecordModel.isEmpty)
                          Toast.show("No Records Found", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                      }
                    },
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Get Records',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.get_app,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ///////////////////////////////////////////////////////
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  recordWidget(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget recordWidget(BuildContext context) {
    return responseRecordModel.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(child: Container()))
        : Container(

            child: ListView.builder(
                itemCount: responseRecordModel.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: recordItem),
          );
  }

  Widget recordItem(BuildContext context, int index) {
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
              border: Border(right: BorderSide(color: Colors.black, width: 1))),
          child: IconSlideAction(
            caption: 'Edit',
            color: Colors.white,
            iconWidget: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Edit Record"),
                    content: new FullScreenDialog(
                      responseRecordModel: responseRecordModel[index],
                    ),
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
              ).then((_) {
                getRecords(l[2], l[0], l[1]);
              });
            },
          ),
        ),
        IconSlideAction(
            caption: 'Delete',
            color: Colors.white,
            iconWidget: Icon(Icons.delete, color: Colors.black),
            onTap: () => showDialog(
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
                            response =
                                await previousRecordController.deleteRecord(
                                    responseRecordModel[index].recordId);
                            responseRecordModel.removeAt(index);
                            Toast.show("Deleted", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                            Navigator.of(context).pop();
                            setState(() {});
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
                )),
      ],
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  BudgetRecordModel responseRecordModel;

  FullScreenDialog({this.responseRecordModel});

  @override
  FullScreenDialogState createState() => new FullScreenDialogState(
      this.responseRecordModel.year,
      this.responseRecordModel.month,
      this.responseRecordModel.date);
}

class FullScreenDialogState extends State<FullScreenDialog> {
  DateTime selectedDate;

  final dateFormat = new DateFormat("MMMM-d-yyyy");
  DateTime value;

  final _formKey = GlobalKey<FormState>();

  BudgetRecordController rc = new BudgetRecordController();

  var y;
  var m;
  var d;

  FullScreenDialogState(this.y, this.m, this.d) {
    this.selectedDate = dateFormat.parse(this.m + '-' + this.d + '-' + this.y);
  }

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController(
        text: widget.responseRecordModel.amount.toString());
    final reasonController =
        TextEditingController(text: widget.responseRecordModel.need);

    return SizedBox(
      height: 300,
      child: new Scaffold(
          body: new Padding(
        child: Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new DateTimeField(
                validator: (val) {
                  if (val == null) return 'cant be empty';
                },
                initialValue: selectedDate,
                format: dateFormat,
                onShowPicker: (context, currentValue) async {
                  await showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoDatePicker(
                          maximumDate: new DateTime(
                              new DateTime.now().year,
                              new DateTime.now().month,
                              new DateTime.now().day + 1),
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime date) {
                            value = date;
                          },
                        );
                      });
                  setState(() {
                    this.selectedDate = value;
                    print(selectedDate.toString());
                  });
                  return value;
                },
              ),
              new Theme(
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
                  new Expanded(
                      child: new RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        FocusScope.of(context).requestFocus(FocusNode());
                        String dt = dateFormat.format(selectedDate);
                        List l1 = dt.split("-");
                        print(dt);
                        await rc.updateRecord(
                            widget.responseRecordModel.recordId,
                            l1[0],
                            l1[1],
                            l1[2],
                            int.parse(amountController.text),
                            reasonController.text);
                        Navigator.of(context).pop();
                        Toast.show('edited', context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    },
                    child: new Text("Save"),
                  ))
                ],
              )
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
      )),
    );
  }
}
