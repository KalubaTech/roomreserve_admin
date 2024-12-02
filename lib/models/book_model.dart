
import 'package:room_reserve_admin_app/models/room_model.dart';
import 'package:room_reserve_admin_app/models/user_model.dart';


class BookModel {
  RoomModel room;
  List nights;
  String totalPrice;
  String dateBooked;
  String status;

  BookModel({required this.room, required this.nights, required this.totalPrice, required this.dateBooked, required this.status});
}