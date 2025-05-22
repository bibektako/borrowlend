import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget{
  const DashboardView({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<DashboardView>{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Dashboard page",
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold
          ),
          )
        ],
      ),
    );
  }
}