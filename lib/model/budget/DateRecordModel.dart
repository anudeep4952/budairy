import 'package:budairy/model/diary/DiaryRecordModel.dart';

class BudgetRecordModel{
  String recordId;
  String year;
  String month;
  String date;
  String time;
  int amount;
  String need;

  BudgetRecordModel({this.recordId, this.year, this.month, this.date,
    this.amount, this.need,this.time});

  factory BudgetRecordModel.fromJson(Map<String, dynamic> json){
    return BudgetRecordModel(
      year:json['year'],
      month:json['month'],
      date:json['date'],
      amount:json['amount'],
      need:json['need'],
      time: json['time'],
      recordId:json['recordId']
    );
  }

  Map<String,dynamic> toMap(){
    final Map<String,dynamic> map = new Map<String, dynamic>();
    map['year']=year;
    map['month']=month;
    map['date']=date;
    map['time']=time;
    map['amount']=amount;
    map['need']=need;
    map['recordId']=recordId;
    return map;
  }

  static List encondeToJson(List<DiaryRecordModel>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toMap())
    ).toList();
    return jsonList;
  }


}