import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboariItem extends StatelessWidget {
  String title;
  Widget icon;
  Function()onclick;
  
  DashboariItem({required this.title, required this.icon, required this.onclick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        child: Column(
          children: [
            icon,
            SizedBox(height: 30,),
            Text('$title', style: TextStyle(fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}
