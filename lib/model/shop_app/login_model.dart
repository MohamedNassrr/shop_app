class ShopLoginModel{
  bool? status;
  String? message;
  UserData? data;

   ShopLoginModel.fromJson(Map<String, dynamic>json){

    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']): null;
  }
}

class UserData{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? point;
  int? credit;
  String? token;

 // named constructor
  UserData.fromJson(Map<String, dynamic>json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    point = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}