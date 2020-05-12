import 'package:budairy/controller/budget/RecordController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:toast/toast.dart';

class Usage extends StatefulWidget {
  @override
  _UsageState createState() => _UsageState();
}

class _UsageState extends State<Usage> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  DateTime selectedDate=new DateTime.now();

  final dateFormat = DateFormat("MMMM-d-yyyy");
  DateTime value;
  DateTime now=DateTime.now();
  var response;

  @override
  Widget build(BuildContext context) {
    BudgetRecordController rc=new BudgetRecordController();
    return Form(key: _formKey,
      child:SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24,bottom: 8,left: 8,right: 8),
            child: DateTimeField(
              decoration: new InputDecoration(
                prefixIcon: Icon(Icons.date_range,color: Colors.black,),
                hintText: 'MM-DD-YYYY',
              ),
              validator: (val){
                if(val==null)
                  return 'cant be empty';
              },
              initialValue: DateTime.now(),
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
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
              child: new Theme(
                  data: new ThemeData(
                    cursorColor: Colors.black,
                    primaryColor: Colors.black,
                    primaryColorDark: Colors.black,
                  ),
                  child: new TextFormField(
                    controller: amountController,
                    style: TextStyle(fontSize: 60),
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
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(fontSize: 60),
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
            ),
          ),

          /////////////////////////////////////////////////////////////////////

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Theme(
                data: new ThemeData(
                  cursorColor: Colors.black,
                  primaryColor: Colors.black,
                  primaryColorDark: Colors.black,
                ),
                child: new TextFormField(
                  controller: reasonController,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Reason cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: new InputDecoration(
                    hintText: "What's this for ?",
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                )),
          ),
          ///////////////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: EdgeInsets.only(
              top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: MaterialButton(
                    onPressed: ()  async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        FocusScope.of(context).requestFocus(FocusNode());
                        String dt=dateFormat.format(selectedDate);
                        List l=dt.split("-");
                        response=await rc.addRecord(l[0], l[1], l[2], int.parse(amountController.text), reasonController.text);

                          amountController.clear();
                          reasonController.clear();
                        Toast.show(response, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      }
                      },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.send,
                      size: 28,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),

        ],
    ),
      ) ,);
  }


}
