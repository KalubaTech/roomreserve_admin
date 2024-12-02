import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';

import '../components/kalubtn.dart';
import '../components/kalutext.dart';
import '../helpers/methods.dart';
import '../utils/colors.dart';

class AddRooms extends StatefulWidget {
  AddRooms({super.key});

  @override
  State<AddRooms> createState() => _AddRoomsState();
}

class _AddRoomsState extends State<AddRooms> {
  TextEditingController _menitiesController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  var amenities = [].obs;
  List resultList=[];
  List images=[];


  LodgeController _lodgeController = Get.find();

  final _picker = HLImagePicker();

  List<HLPickerItem> _selectedImages = [];

  _openPicker() async {
    // Request storage permission before opening the picker
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final images = await _picker.openPicker(cropping: true);
      setState(() {
        _selectedImages = images;
      });
    } else {
      // Handle permission denied scenario
      print('Storage permission denied');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add room'),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Images (${images.length})', style: TextStyle(fontSize: 16),),
                      Spacer(),
                      Kalubtn(
                        borderRadius: 30,
                        width: 50,
                          label: 'Add',
                          onclick: ()async{
                            await _openPicker();
                            setState(() {
                                  images =_selectedImages;
                            });
                            }

                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Kalutext(
              controller: _nameController,
              border: Border.all(
                  color: Karas.primary
              ),
              labelText: 'Room Name',
            ),
            SizedBox(height: 10,),
            Kalutext(
              controller: _priceController,
              border: Border.all(
                  color: Karas.primary
              ),
              labelText: 'Price per night (ZMK)',
              isNumber: true,
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Karas.secondary),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Kalutext(
                    controller: _menitiesController,
                    border: Border.all(
                      color: Karas.primary
                    ),
                    labelText: 'Amenity',
                  ),
                  SizedBox(height: 10,),
                  Kalubtn(
                    width: 100,
                      backgroundColor: Karas.secondary,
                      borderRadius: 30,
                      label: 'Add',
                      onclick: (){
                        setState(() {
                          amenities.value.add(_menitiesController.text);
                          _menitiesController.clear();
                        });
                      },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Obx(
                      ()=> Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${amenities.length} Added', style: TextStyle(fontSize: 11),),
                          SizedBox(height: 10,),
                          ...amenities.map((a)=>Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${a}'),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    amenities.removeWhere((e)=>e==a);
                                  });
                                },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  )
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 60,),
            Kalubtn(
              height: 40,
                borderRadius: 40,
                label: 'Save Room',
                onclick: ()async{
                  Get.defaultDialog(
                    title: 'Uploading...',
                    titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    content: Container(
                    child: Center(
                      child: CircularProgressIndicator()),
                    ),

                  );
               await Methods().addRoom(
                 _nameController.text,
                   _priceController.text,
                   amenities.value,
                 images.map((img)=>img.name).toList(),
                   _lodgeController.lodge.first.uid
                  );

                  Get.back();
                  Get.back();
                }
            )
          ],
        ),
      ),
    );
  }
}
