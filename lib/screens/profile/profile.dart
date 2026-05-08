import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Icon(Icons.person, size: 120, color: Colors.blue),
                  SizedBox(height: 10,),
                  Text('JAMES JOHNS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5),
                  Text('james44@outlook.com' , style: TextStyle(color: Colors.blue)),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                          'hi im james johns and i like niggers and other things',
                          style: TextStyle(color: Colors.white),
                      )
                  ),
                  SizedBox(height: 5,),
                  Text('Active')
                ]
              ),
            ),
      )
      ),
    );
  }
}
