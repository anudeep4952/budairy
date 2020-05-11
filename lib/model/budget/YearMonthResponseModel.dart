class YearMonthResponseModel{
  int amount;
  String key;


YearMonthResponseModel({this.amount,this.key});

  factory YearMonthResponseModel.fromJson(Map<String, dynamic> json){
    return YearMonthResponseModel(
      amount:json['amount'],
      key:json['key'],
    );
  }

}