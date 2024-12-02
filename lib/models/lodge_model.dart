class LodgeModel {
  String uid;
  String name;
  String phone;
  String latlng;
  String? logo;
  String password;


  LodgeModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.latlng,
    this.logo,
    required this.password
  });
}