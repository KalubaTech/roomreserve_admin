import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';
import 'package:room_reserve_admin_app/utils/colors.dart';
import 'package:room_reserve_admin_app/views/admin.dart';
import 'package:room_reserve_admin_app/views/auth/sign_up.dart';

import 'controllers/rooms_controllelr.dart';
import 'controllers/user_controller.dart';
import 'helpers/methods.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(RoomsController());
  Get.put(UserController());
  Get.put(LodgeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADMIN APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Methods().prefetchData(),
        builder: (context, s) {
          return s.hasData && s.data!?SignUp()://AdminDashboard():
          Scaffold(
            body: Center(
              child: Container(
                width: 200,
                child: LoadingIndicator(indicatorType: Indicator.ballRotateChase, colors: [Karas.primary, Karas.secondary, Colors.red, Colors.blue],),
              ),
            ),
          )
          ;
        }
      ),
    );
  }
}
