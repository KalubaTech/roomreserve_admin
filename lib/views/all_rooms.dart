import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';
import 'package:get/get.dart';
import '../models/room_model.dart';


class AllRooms extends StatelessWidget {
  AllRooms({super.key});

  LodgeController _lodgeController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Rooms'),
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('rooms').where('lodgeID', isEqualTo: _lodgeController.lodge.first.uid).snapshots(),
            builder: (c,s){
              if (s.hasData && s.data!.docs.isNotEmpty) {

                return ListView.builder(
                  itemCount: s.data!.docs.length,
                  itemBuilder: (c,i){
                    var room = RoomModel(name: s.data!.docs[i].get('name'), price: s.data!.docs[i].get('price'), uid: s.data!.docs[i].id, amenities: s.data!.docs[i].get('amenities').map<String>((e)=>e.toString()).toList(), images: s.data!.docs[i].get('images').map<String>((e)=>e.toString()).toList(), isBooked: s.data!.docs[i].get('isBooked'), lodgeID: s.data!.docs[i].get('lodgeID'));

                    return ListTile(
                      onTap: (){
                        
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                          borderRadius: BorderRadius.circular(6)
                        ),
                      ),
                      title: Text(room.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      subtitle: Text("ZMK ${room.price}", style: TextStyle(fontSize: 12, color: Colors.grey),),
                      trailing: InkWell(
                        onTap: (){
                          FirebaseFirestore.instance.collection('rooms').doc(room.uid).delete();
                        },
                        child: Icon(Icons.delete_outline, color: Colors.red,),
                      ),
                    );
                  }
              );
              } else {
                return Container();
              }}
        ),
      ),
    );
  }
}
