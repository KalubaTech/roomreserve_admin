import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:room_reserve_admin_app/components/kalubtn.dart';
import 'package:room_reserve_admin_app/components/kalutext.dart';
import 'package:room_reserve_admin_app/controllers/lodge_controller.dart';
import 'package:room_reserve_admin_app/helpers/methods.dart';
import 'package:room_reserve_admin_app/utils/colors.dart';
import 'package:room_reserve_admin_app/views/admin.dart';
import 'package:room_reserve_admin_app/views/auth/sign_in.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  LodgeController _lodgeController = Get.find();

  TextEditingController _lodgeNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late GoogleMapController _googleMapController;

  var _isLoading = false.obs;

  var _currentLocation = LatLng(0, 0).obs;

  // Add a marker set to track the markers
  var _markers = <Marker>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '- LODGE REGISTRATION -',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Container(
              child: Column(
                children: [
                  Kalutext(
                    backgroundColor: Colors.white,
                    controller: _lodgeNameController,
                    hintText: 'Lodge Name',
                    labelText: 'Lodge Name: ',
                    labelTextStyle: TextStyle(),
                  ),
                  Kalutext(
                    backgroundColor: Colors.white,
                    controller: _phoneController,
                    hintText: 'Phone Number',
                    labelText: 'Phone Number: ',
                    isNumber: true,
                    labelTextStyle: TextStyle(),
                  ),
                  Kalutext(
                    backgroundColor: Colors.white,
                    controller: _passwordController,
                    hintText: 'Set your password',
                    labelText: 'Password: ',
                    labelTextStyle: TextStyle(),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LOCATION",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            )),
                        width: 50,
                        height: 50,
                        child: Center(
                          child: FutureBuilder(
                              future: Methods().getDeviceLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _currentLocation.value = LatLng(
                                      snapshot.data!.latitude,
                                      snapshot.data!.longitude);
                                  _updateMarker(_currentLocation.value); // Update marker
                                  return Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: Colors.green,
                                  );
                                } else {
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pick location',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Press and hold on a map to select location',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 200,
                      child: Obx(
                            () => GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(-15.3875, 28.3228), // Default to Lusaka, Zambia
                                zoom: 17, // Set an appropriate zoom level
                              ),
                              onMapCreated: (controller) {
                                _googleMapController = controller;
                              },
                              onLongPress: (loc) {
                                _currentLocation.value = LatLng(loc.latitude, loc.longitude);
                                _updateMarker(_currentLocation.value); // Update marker when user selects a new location
                              },
                              markers: _markers.value,
                            ),

                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
                  () => Center(
                child: !_isLoading.value
                    ? Kalubtn(
                    label: 'REGISTER',
                    onclick: () async {
                      if (_lodgeNameController.text.isNotEmpty &&
                          _phoneController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty) {
                        _isLoading.value = true;
                        await Methods().addLodge(
                            _lodgeNameController.text,
                            _phoneController.text,
                            _passwordController.text,
                            _currentLocation.value
                        );
                        Get.offAll(() => AdminDashboard());
                      }
                      _isLoading.value = false;
                    })
                    : CircularProgressIndicator(
                  color: Karas.primary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text('OR'),
            ),
            TextButton(onPressed: (){
              Get.to(()=>SignIn());
            }, child: Text('SIGN IN'))
          ],
        ),
      ),
    );
  }

  // Update the marker on the map
  void _updateMarker(LatLng position) {
    _markers.value = {
      Marker(
        markerId: MarkerId("current_location"),
        position: position,
        infoWindow: InfoWindow(title: "Selected Location"),
      ),
    };
  }
}
