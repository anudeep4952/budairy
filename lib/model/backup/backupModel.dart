import 'dart:convert';

import 'package:budairy/model/budget/DateRecordModel.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';

class BackupModel{
  List<DiaryRecordModel> diaryRecordModels;
  List<BudgetRecordModel> budgetRecordModels;

  BackupModel({this.diaryRecordModels, this.budgetRecordModels});

  factory BackupModel.fromJson(Map<String, dynamic> json){

    var list1=json['budgetRecordModels'] as List;

    List<BudgetRecordModel> brm = list1.map((i) => BudgetRecordModel.fromJson(i)).toList();

    var list2=json['diaryRecordModels'] as List;

    List<DiaryRecordModel> drm = list2.map((i) => DiaryRecordModel.fromJson(i)).toList();


    return BackupModel(
        budgetRecordModels:brm ,
        diaryRecordModels:drm
    );
  }

  Map<String,dynamic> toMap(){

    List<Map<String,dynamic >> brm = this.budgetRecordModels != null ? this.budgetRecordModels.map((i) => i.toMap()).toList() : null;

    List<Map<String,dynamic >> drm = this.diaryRecordModels != null ? this.diaryRecordModels.map((i) => i.toMap()).toList() : null;


    final Map<String,dynamic> map = new Map<String, dynamic>();
    map['budgetRecordModels']=brm;
    map['diaryRecordModels']=drm;
    return map;
  }

}