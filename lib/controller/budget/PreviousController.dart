import 'dart:async';
import 'package:budairy/model/budget/DateRecordModel.dart';
import 'package:budairy/model/budget/YearMonthResponseModel.dart';

import '../../database/BudgetDatabase.dart';

class PreviousRecordController {

  PreviousRecordController();

  final dbHelper = BudgetDatabaseHelper.instance;

  var url = 'https://sleepy-ridge-61110.herokuapp.com/v1/records/';


  Future<String> deleteRecord(String recordId) async {

    await dbHelper.delete(recordId);

    return "deleted";
  }




  Future<List<YearMonthResponseModel>> getRecordByYears() async {

     var res= await dbHelper.yearRecords();


      List<YearMonthResponseModel> responseRecordModel=(res as List).map((i)=>
          YearMonthResponseModel.fromJson(i)).toList();

      return responseRecordModel;

  }

  Future<List<YearMonthResponseModel>> getRecordByYearMonths(String year) async {

    var res= await dbHelper.monthRecords(year);


    List<YearMonthResponseModel> responseRecordModel=(res as List).map((i)=>
        YearMonthResponseModel.fromJson(i)).toList();

    return responseRecordModel;

  }


  Future<List<YearMonthResponseModel>> getRecordByYearMonthDates(String year,String month) async {

    var res= await dbHelper.dateRecords(year,month);


    List<YearMonthResponseModel> responseRecordModel=(res as List).map((i)=>
        YearMonthResponseModel.fromJson(i)).toList();

    return responseRecordModel;


  }


  Future<List<BudgetRecordModel>> getSpecificRecords(String year,String month,String date) async {

    var res=await dbHelper.specificDate(year, month, date);

    print(res);

    List<BudgetRecordModel> responseRecordModel=(res as List).map((i)=>
        BudgetRecordModel.fromJson(i)).toList();


      return responseRecordModel;
    }

  }



/*Future<List<ResponseRecordModel>> getRecords(String userId) async {

    var url1 = this.url+userId;

    var response = await http.get(url1,
        headers: {"Content-Type": "application/json"});

    var res =  json.decode(response.body);

    List<ResponseRecordModel> responseRecordModel=(res as List).map((i)=>
        ResponseRecordModel.fromJson(i)).toList();

    print(responseRecordModel.length);

    return responseRecordModel;

  }*/


