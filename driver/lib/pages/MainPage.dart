import 'package:driver/assets/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int selectedDestination = 0;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.green),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              color: AppColors.green,
            ),
            ListTile(
              leading: Icon(Icons.fact_check_outlined, color: Colors.black),
              title: Text('Verification Status', style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.error_outline_outlined, color: Colors.red),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/VerificationStatusPage');

              },
            )
          ],
        )
      ),
      body: Container(
        child: Text('HomePage'),
      ),
    );
  }
}