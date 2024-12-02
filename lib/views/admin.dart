import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';
import 'package:room_reserve_admin_app/utils/colors.dart';
import 'package:room_reserve_admin_app/views/auth/sign_in.dart';
import 'package:room_reserve_admin_app/views/components/dashboarI_item.dart';

import 'add_rooms.dart';
import 'all_rooms.dart';
import 'bookings.dart';
import 'dashboard/admin_settings.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  LodgeController _lodgeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Karas.primary,
        foregroundColor: Karas.secondary,
        title: Text('${_lodgeController.lodge.first.name}', style: TextStyle(fontWeight: FontWeight.bold,),),
        actions: [
          IconButton(
              onPressed: (){
                Get.offAll(()=>SignIn());
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Container(
        child: GridView(
          padding: EdgeInsets.symmetric(vertical: 45),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            DashboariItem(title: 'Add Rooms', icon: Icon(Icons.add, color: Colors.green,size: 50,), onclick: () { Get.to(()=>AddRooms()); },),
            DashboariItem(title: 'All Rooms', icon: Icon(Icons.room_service_sharp, color: Colors.orange,size: 50,), onclick: () { Get.to(()=>AllRooms()); },),
            DashboariItem(title: 'Bookings', icon: Icon(Icons.bookmark, color: Colors.lightBlue,size: 50), onclick: () { Get.to(()=>Bookings()); },),
            DashboariItem(title: 'Settings', icon: Icon(Icons.settings, color: Colors.deepPurpleAccent,size: 50), onclick: () { Get.to(()=>AdminSettings()); },),

          ],
        ),
      ),
    );
  }
}
