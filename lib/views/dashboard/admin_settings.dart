import 'package:flutter/material.dart';
import 'package:room_reserve_admin_app/components/kalubtn.dart';
import 'package:room_reserve_admin_app/components/kalutext.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';
import 'package:room_reserve_admin_app/models/lodge_model.dart';
import 'package:room_reserve_admin_app/utils/colors.dart';
import 'package:get/get.dart';

class AdminSettings extends StatelessWidget {
  AdminSettings({super.key});

  final LodgeController _lodgeController = Get.find();


  @override
  Widget build(BuildContext context) {

    LodgeModel lodge = _lodgeController.lodge.first;
    TextEditingController _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Karas.primary,
        foregroundColor: Karas.secondary,
        title: Text('SETTINGS'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(lodge.name, style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text('Lodge Name', style: TextStyle(color: Colors.grey, fontSize: 12),),
              trailing: InkWell(
                onTap: (){
                  Get.bottomSheet(
                      Container(
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: BorderDirectional(top: BorderSide(width: 4, color: Karas.primary)),
                          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(30), topStart: Radius.circular(30))
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                          child: Column(
                            children: [
                              Text('EDIT NAME', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Karas.primary),),
                              SizedBox(height: 20,),
                              Kalutext(
                                  controller: _nameController,
                                  hintText: lodge.name,
                              ),
                              SizedBox(height: 20,),
                              Kalubtn(
                                  label: 'SAVE',
                                  width: 100,
                                  onclick: (){

                                  })
                            ],
                          ),
                        ),
                      )
                  );
                },
                child: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            ListTile(
              title: Text(lodge.phone, style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text('Phone Number',style: TextStyle(color: Colors.grey, fontSize: 12),),
              trailing: InkWell(
                onTap: (){
                  Get.bottomSheet(
                      Container(
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: BorderDirectional(top: BorderSide(width: 4, color: Karas.primary)),
                          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(30), topStart: Radius.circular(30))
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                          child: Column(
                            children: [
                              Text('EDIT PHONE NUMBER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Karas.primary),),
                              SizedBox(height: 20,),
                              Kalutext(
                                  controller: _nameController,
                                  hintText: lodge.phone,
                              ),
                              SizedBox(height: 20,),
                              Kalubtn(
                                  label: 'SAVE',
                                  width: 100,
                                  onclick: (){

                                  })
                            ],
                          ),
                        ),
                      )
                  );
                },
                child: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            ListTile(
              title: Row(children: [...List.generate(5, (i){
                return Row(children: [CircleAvatar(radius: 5,backgroundColor: Colors.black,), SizedBox(width: 4,)],);
              })],),
              subtitle: Text('Password',style: TextStyle(color: Colors.grey, fontSize: 12),),
              trailing: InkWell(
                onTap: (){
                  Get.bottomSheet(
                      Container(
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: BorderDirectional(top: BorderSide(width: 4, color: Karas.primary)),
                          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(30), topStart: Radius.circular(30))
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                          child: Column(
                            children: [
                              Text('CHANGE PASSWORD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Karas.primary),),
                              SizedBox(height: 20,),
                              Kalutext(
                                  controller: _nameController,
                                  hintText: '.......',
                              ),
                              SizedBox(height: 20,),
                              Kalubtn(
                                  label: 'SAVE',
                                  width: 100,
                                  onclick: (){

                                  })
                            ],
                          ),
                        ),
                      )
                  );
                },
                child: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.topLeft,
              width: 200,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logo Image'),
                  SizedBox(height: 5,),
                  Icon(Icons.image, color: Colors.grey, size: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
