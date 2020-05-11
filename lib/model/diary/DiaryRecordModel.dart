class DiaryRecordModel{
  String recordId;
  String year;
  String month;
  String date;
  String time;
  String title;
  String notes;

  DiaryRecordModel({this.recordId, this.year, this.month, this.date,
    this.title, this.notes,this.time});

  factory DiaryRecordModel.fromJson(Map<String, dynamic> json){
    return DiaryRecordModel(
        year:json['year'],
        month:json['month'],
        date:json['date'],
        title:json['title'],
        notes:json['notes'],
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
    map['title']=title;
    map['notes']=notes;
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