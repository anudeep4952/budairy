import 'dart:async';
import 'package:budairy/database/DiaryDatabase.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';
import 'package:intl/intl.dart';

class DiaryController {


  final dbHelper = DiaryDatabaseHelper.instance;

  Future<DiaryRecordModel> addRecord(String month,String date,String year,String title,String notes ) async {
    String time=DateFormat('kk:mm').format(DateTime.now());
    String recordId="DIA"+(DateTime.now().millisecondsSinceEpoch/100).floor().toString();
    DiaryRecordModel data = new DiaryRecordModel(
        recordId:recordId, year:year, month:month, date:date,time: time,title: title,notes: notes);
    //encode Map to JSON
    var body=data.toMap();
    await dbHelper.insert(body);
    return data;

  }

  addRecords(List<DiaryRecordModel> drm){
    drm.forEach((i) async {
      await dbHelper.insert(i.toMap());
    });
  }

  Future<String> updateRecord(DiaryRecordModel data ) async {

    //encode Map to JSON
    var body=data.toMap();
    await dbHelper.update(body);
    return ('updated');

  }

  Future<List<DiaryRecordModel>> getSpecificRecords(String year,String month,String date) async {

    var res=await dbHelper.specificDate(year, month, date);

    List<DiaryRecordModel> responseRecordModel=(res as List).map((i)=>
        DiaryRecordModel.fromJson(i)).toList();


    return responseRecordModel;
  }

  Future<String> deleteRecord(String recordId) async {

    await dbHelper.delete(recordId);

    return "deleted";
  }

  Future<List<DiaryRecordModel>> getAllRecords() async {

    var res= await dbHelper.queryAllRows();
    List<DiaryRecordModel> responseRecordModel=(res as List).map((i)=>
        DiaryRecordModel.fromJson(i)).toList();

    return responseRecordModel;


  }

  deleteAllRecords() async {
    await dbHelper.deleteAllRecords();
  }

}




