import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:room_reserve_admin_app/models/lodge_model.dart';
import '../controllers/lodge_controller.dart';
import '../controllers/rooms_controllelr.dart';
import '../controllers/user_controller.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Methods {

  FirebaseFirestore _fs = FirebaseFirestore.instance;
  RoomsController _roomsController = Get.find();
  UserController _userController = Get.find();
  LodgeController _lodgeController = Get.find();


  Future<LatLng?> getDeviceLocation() async {
    // Check for location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error retrieving location: $e');
      return null;
    }
  }
  Future<void> uploadImageToFirebase(List<dynamic> images, {required String name, required String price, required dynamic amenities}) async {
    if (images == null || images.isEmpty) return;


    print(images);
    List<String> uploadedImages = [];

  /*  for (var image in images) {
      // Check if image is of type File. If it's not, convert it.
      File fileToUpload;

      fileToUpload = File(image);

      // Create a unique file name
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        // Upload the file to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child(fileName);
        final uploadTask = storageRef.putFile(fileToUpload);

        // Wait until the upload is complete
        await uploadTask;

        // Get the download URL of the uploaded file
        final downloadUrl = await storageRef.getDownloadURL();
        print("Download URL: $downloadUrl");

        uploadedImages.add(downloadUrl);
      } catch (e) {
        print("Upload failed: $e");
      }
    }*/

    // Upload the data to Firestore
    Map<String, dynamic> toUploadData = {
      "name": name,
      "amenities": amenities,
      "price": price,
      "images": uploadedImages, // Add the uploaded image URLs
    };

    await FirebaseFirestore.instance.collection('rooms').add(toUploadData);
    print("Data uploaded successfully.");
  }
  Future<bool> fetchAllRooms()async{
    List<RoomModel> rooms = [];

    var roomData = await _fs.collection('rooms').get();

    if(roomData.docs.isNotEmpty){

      for(var roomDoc in roomData.docs){
        RoomModel room = RoomModel(name: roomDoc.get('name'), price: roomDoc.get('price').toString(), uid: roomDoc.id, amenities: roomDoc.get('amenities').map((e)=>e.toString()).toList(), images: roomDoc.get('images').map((e)=>e.toString()).toList(), isBooked: roomDoc.get('isBooked'), lodgeID: roomDoc.get('lodgeID'));

        rooms.add(room);
      }

      _roomsController.rooms.value = rooms;
      _roomsController.update();
    } 


    return true;
  }
  Future<bool> fetchAllUsers()async{
    List<UserModel> users = [];

    var usersData = await _fs.collection('users').get();

    if(usersData.docs.isNotEmpty){

      for(var userDoc in usersData.docs){
        UserModel user = UserModel(uid: userDoc.id, fullname: userDoc.get('fullname'), phone: userDoc.get('phone'), email: userDoc.get('email'), password: userDoc.get('password')
        );

        users.add(user);
      }

      _userController.user.value = users;
      _roomsController.update();
    }


    return true;
  }
  Future<bool>addRoom(name,price,amenities,images,lodgeID)async{

    List<String> uploadedImages = [];

    /*  for (var image in images) {
      // Check if image is of type File. If it's not, convert it.
      File fileToUpload;

      fileToUpload = File(image);

      // Create a unique file name
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        // Upload the file to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child(fileName);
        final uploadTask = storageRef.putFile(fileToUpload);

        // Wait until the upload is complete
        await uploadTask;

        // Get the download URL of the uploaded file
        final downloadUrl = await storageRef.getDownloadURL();
        print("Download URL: $downloadUrl");

        uploadedImages.add(downloadUrl);
      } catch (e) {
        print("Upload failed: $e");
      }
    }*/

    // Upload the data to Firestore
    Map<String, dynamic> toUploadData = {
      "name": name,
      "amenities": amenities,
      "price": price,
      "images": uploadedImages, // Add the uploaded image URLs
      "lodgeID":lodgeID
    };

    await FirebaseFirestore.instance.collection('rooms').add(toUploadData);

    return true;
  }
  Future<bool>prefetchData()async{
    return true;//await fetchAllUsers() && await fetchAllRooms();
  }

  Future<bool>approveBooking(bookingId, roomId)async{
    await _fs.collection('bookings').doc(bookingId).update({"status":"approved"});
    await _fs.collection('rooms').doc(roomId).update({"isBooked":true});

    return true;
  }

  Future<bool>cancelBooking(bookingId)async{

    await _fs.collection('bookings').doc(bookingId).update({"status":"cancelled"});

    return true;
  }

  Future<bool>addLodge(lodgeName,phoneNumber,password,LatLng location)async{
    var _lodgeData = await _fs.collection('lodge').add(
        {
          "lodgeName":lodgeName,
          "phone":phoneNumber,
          "latitude":location.latitude,
          "longitude":location.longitude,
          "password":password,
          "image":"",
        }
    );

    LodgeModel lodge = LodgeModel(uid: _lodgeData.id, name: lodgeName, phone: phoneNumber, latlng: '${location.latitude},${location.latitude}', password: password);

    _lodgeController.lodge.value.add(lodge);
    _lodgeController.update();

    return true;
  }

  Future<bool>login(phone,password)async{
    var userData = await _fs.collection('lodge').where('phone', isEqualTo: phone).where('password', isEqualTo: password).get();

    if(userData.docs.isNotEmpty){

        for(var _lodge in userData.docs){
          LodgeModel lodge = LodgeModel(uid: _lodge.id, name: _lodge.get('lodgeName'), phone: _lodge.get('phone'), latlng: '${_lodge.get('latitude')},${_lodge.get('longitude')}', password: _lodge.get('password'));

          _lodgeController.lodge.value.add(lodge);
          _lodgeController.update();

        }
      return true;
    }

    return false;
  }

}