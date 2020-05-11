import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:budairy/controller/budget/RecordController.dart';
import 'package:budairy/model/backup/backupModel.dart';
import 'package:budairy/model/budget/DateRecordModel.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'diary/DiaryController.dart';

class SettingsController {
  BudgetRecordController bc;
  DiaryController dc;

  SettingsController() {
    bc = new BudgetRecordController();
    dc = new DiaryController();
  }

  Future<void> backup() async {
    BackupModel bm = new BackupModel(
        diaryRecordModels: await dc.getAllRecords(),
        budgetRecordModels: await bc.getAllRecords());

    await Share.file('budget', 'budget.json',
        utf8.encode(jsonEncode(bm.toMap())), 'application/json');
  }

  backUpToDevice() async {
    String downloadsDirectory =
        await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_DOWNLOADS);
    if (await Permission.storage.request().isGranted) {
      BackupModel bm = new BackupModel(
          diaryRecordModels: await dc.getAllRecords(),
          budgetRecordModels: await bc.getAllRecords());
      var json = jsonEncode(bm.toMap());
      final File file = File('${downloadsDirectory}/backup.json');
      await file.writeAsString(json);
      return ("Backup created in downloads folder");
    } else {
      return ("PERMISSION DENIED");
    }
  }

  Future<String> getbackup(String path) async {
    List<DiaryRecordModel> drm;
    List<BudgetRecordModel> brm;

    if (path.split('.').last == 'json') {
      File file = new File(path);
      String contents = await file.readAsStringSync();

      try {
        Map<String, dynamic> map = json.decode(contents);

        drm = (map["diaryRecordModels"] as List)
            .map((i) => DiaryRecordModel.fromJson(i))
            .toList();

        brm = (map["budgetRecordModels"] as List)
            .map((i) => BudgetRecordModel.fromJson(i))
            .toList();
      } on Exception catch (e) {
        return ("File corupted");
      }
      BackupModel backup =
          new BackupModel(diaryRecordModels: drm, budgetRecordModels: brm);

      await dc.addRecords(drm);
      await bc.addRecords(brm);

      return ("Backup Success");
    } else {
      return ("illegal file format");
    }
  }

  Future<String> deleteBudgetRecords() async {
    await bc.deleteAllRecords();
    return ("all records cleared");
  }

  Future<String> deleteDiaryRecords() async {
    await dc.deleteAllRecords();
    return ("all records cleared");
  }
}

///data/user/0/com.deep.budairy/app_flutter/diary.json
