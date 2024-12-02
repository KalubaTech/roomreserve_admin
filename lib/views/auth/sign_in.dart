import 'package:flutter/material.dart';
import 'package:room_reserve_admin_app/components/kalubtn.dart';
import 'package:room_reserve_admin_app/components/kalutext.dart';
import 'package:get/get.dart';
import 'package:room_reserve_admin_app/helpers/methods.dart';
import 'package:room_reserve_admin_app/views/admin.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _isloading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN IN'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              child: Image.asset('assets/ic_launcher.png'),
            ),
            Kalutext(
              controller: _phoneNumberController,
              hintText: 'Phone Number',
              labelText: 'Phone Number',
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 10,),
            Kalutext(
              controller: _passwordController,
              hintText: 'Password',
              labelText: 'Password',
              isObscured: true,
              showEye: true,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 40,),
            Obx(()=>!_isloading.value?Kalubtn(
                label: 'SIGN IN',
                onclick: ()async{
                  _isloading.value = true;

                  bool isLoggedIn = await Methods().login(_phoneNumberController.text, _passwordController.text);
                  _isloading.value = false;
                  if(isLoggedIn){
                    Get.offAll(()=>AdminDashboard());
                  }
                }
            ):Container(
              child: Center(
                  child: CircularProgressIndicator()
              ),
            ))
          ],
        ),
      ),
    );
  }
}
