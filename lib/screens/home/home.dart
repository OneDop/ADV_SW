import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person_rounded),
        title: Text('Dashboard'),
        actions: [IconButton(
            onPressed: (){
              //GO TO NOTI PAGE
            },
            icon: Icon(Icons.notifications))],
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text('HELLO USER',style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            Text('My Projects', textAlign: TextAlign.start),
            SizedBox(height: 10,),
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20,//edit this
              itemBuilder: (context, index) {
                return Container();// make it custom widget here
              },
            ),
            SizedBox(height: 20,),
            Text('My Tasks', textAlign: TextAlign.start,),
            SizedBox(height: 10,),
            ListView.builder(
              scrollDirection: Axis.vertical,
                itemCount: 20, //edit this
                itemBuilder: (context, index) {
                return Container(); // make it custom widgets
                }
            ),
          ],
        ),
      ),) ,
    );
  }
}
