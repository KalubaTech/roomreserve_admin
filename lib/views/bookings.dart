import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_reserve_admin_app/models/user_model.dart';

import '../../components/kalubtn.dart';
import '../../controllers/user_controller.dart';
import '../../models/book_model.dart';
import '../../models/room_model.dart';
import '../../utils/colors.dart';
import '../controllers/lodge_controller.dart';
import '../controllers/rooms_controllelr.dart';
import '../helpers/methods.dart';

class Bookings extends StatefulWidget {
  Bookings({super.key});

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final UserController _userController = Get.find();
  final RoomsController _roomsController = Get.find();
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  final LodgeController _lodgeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Rooms'),
        backgroundColor: Karas.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: _fs
            .collection('bookings')
            .where('lodgeID', isEqualTo: _lodgeController.lodge.first.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var bookingDoc = documents[index];

                // Fetch room data based on the roomId from the booking document
                return FutureBuilder<DocumentSnapshot>(
                  future: _fs.collection('rooms').doc(bookingDoc.get('roomId')).get(),
                  builder: (context, roomSnapshot) {
                    if (roomSnapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading room...'),
                      );
                    }

                    if (roomSnapshot.hasData && roomSnapshot.data != null) {
                      var roomData = roomSnapshot.data!;
                      RoomModel room = RoomModel.fromFirestore(roomData); // Assuming you have a factory to create the RoomModel

                      BookModel booking = BookModel(
                        room: room,
                        nights: bookingDoc.get('reservedDates'),
                        totalPrice: bookingDoc.get('totalPrice').toString(),
                        dateBooked: bookingDoc.get('dateBooked'),
                        status: bookingDoc.get('status'),
                      );

                      return ListTile(
                        onTap: (){
                          Get.bottomSheet(
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${booking.room.name.toUpperCase()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Karas.primary),),
                                          booking.status=="pending"?Kalubtn(
                                              width: 100,
                                              label: 'Approve',
                                              onclick: ()async{
                                                Methods().approveBooking(bookingDoc.id, room.uid);
                                                Get.back();
                                              }):Container()
                                        ],
                                      )
                                  ),
                                  Divider(),
                                  Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Text('Dates (${booking.nights.length} Nights)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),)),
                                            Container(
                                              height: 60,
                                              width: double.infinity,
                                              child: ListView(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                children: [
                                                  ...booking.nights.map((day){
                                                    return Row(
                                                      children: [
                                                        Chip(
                                                          label: Text('${day}'),
                                                          onDeleted: (){
                                                            //addedDays.remove(day);
                                                          },
                                                          padding: EdgeInsets.symmetric(horizontal: 0),
                                                          deleteIcon: Icon(Icons.cancel),
                                                          deleteIconColor: Colors.red,
                                                        ),
                                                        SizedBox(width: 5,)
                                                      ],
                                                    );
                                                  })
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Text('PRICE: '),
                                                  Text('ZMK ${booking.totalPrice}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: StreamBuilder(
                                                stream: FirebaseFirestore.instance.collection('clients').doc(bookingDoc.get('user')).snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {

                                                    UserModel user = UserModel(
                                                        uid: snapshot.data!.id,
                                                        fullname: snapshot.data!.get('fullname'),
                                                        phone: snapshot.data!.get('phone'),
                                                        email: snapshot.data!.get('email'),
                                                        password: snapshot.data!.get('password')
                                                    );

                                                    return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Client Details', style: TextStyle(fontWeight: FontWeight.bold, ),),
                                                      ListTile(
                                                        leading: Icon(Icons.person),
                                                        title: Text('${user.fullname}'),
                                                        subtitle: Text('Full Name'),
                                                      ),
                                                      ListTile(
                                                        leading: Icon(Icons.phone_android),
                                                        title: Text('${user.phone}'),
                                                        subtitle: Text('Phone Number'),
                                                      ),
                                                    ],
                                                  );
                                                  } else {
                                                    return Container();
                                                  }
                                                }
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        leading: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                          child: Image.asset('assets/lodge1.jpg',),
                        ),
                        title: Text('${booking.room.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(
                          'Booked for ${booking.nights.length} nights at K${booking.totalPrice}', style: TextStyle(fontSize: 12),),
                        trailing: Container(
                          width: 90,
                          child: Column(
                            children: [
                              Text('${booking.status.capitalize}', style: TextStyle(color: booking.status=='approved'?Colors.green:booking.status=='cancelled'?Colors.red:Karas.primary),),
                              booking.status=='pending'?Kalubtn(
                                  width: 60,
                                  height: 28,
                                  label: 'Cancel',
                                  labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                                  onclick: (){
                                    Methods().cancelBooking(bookingDoc.id);
                                  }
                              ):Container()
                            ],
                          ),
                        ),
                      );
                    }

                    // Handle case if room data is not available
                    return ListTile(
                      title: Text('Unknown Room'),
                      subtitle: Text('Room details not available'),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No bookings found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
