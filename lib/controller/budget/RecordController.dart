import 'dart:async';
import 'package:budairy/model/budget/DateRecordModel.dart';
import '../../database/BudgetDatabase.dart';
import 'package:intl/intl.dart';

class BudgetRecordController {


  final dbHelper = BudgetDatabaseHelper.instance;

  Future<String> addRecord(String month,String date,String year,int amount,String need ) async {

   String time=DateFormat('kk:mm').format(DateTime.now());
   String recordId="BUD"+(DateTime.now().millisecondsSinceEpoch/100).floor().toString();
    BudgetRecordModel data = new BudgetRecordModel(
        recordId:recordId, year:year, month:month, date:date, amount:amount, need:need,time: time);
    //encode Map to JSON
    var body=data.toMap();
    await dbHelper.insert(body);
    return ('success');

  }


  addRecords(List<BudgetRecordModel> brm){
    brm.forEach((i) async {
      await dbHelper.insert(i.toMap());
    });
  }

  Future<String> updateRecord(String recordId,String month,String date,String year,int amount,String need ) async {

    BudgetRecordModel data = new BudgetRecordModel(
        recordId:recordId, year:year, month:month, date:date, amount:amount, need:need);
    //encode Map to JSON
    var body=data.toMap();
    await dbHelper.update(body);
    return ('success');

  }

  Future<List<BudgetRecordModel>> getAllRecords() async {

    var res= await dbHelper.queryAllRows();
    List<BudgetRecordModel> responseRecordModel=(res as List).map((i)=>
        BudgetRecordModel.fromJson(i)).toList();

    return responseRecordModel;
  }

  deleteAllRecords() async {
    await dbHelper.deleteAllRecords();
  }


}



/*var bodydata = json.encode(body);

    var response = await http.post(url,
        body: bodydata,
        headers: {"Content-Type": "application/json"});
    var mapRes = json.decode(response.body);
    if (response.statusCode == 200) {
      return(mapRes['message']);

    } else {
      // If that response was not OK, throw an error.
      return ("connection error");
      //throw Exception('Failed to load ConversationRepo');
    }*/
