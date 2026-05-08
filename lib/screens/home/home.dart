import 'package:advsw/screens/home/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> arr = ['test', 'test2', 'test3', 'test4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        leading: const Icon(Icons.person_rounded),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              //GO TO NOTI PAGE
            },
            icon: const Icon(Icons.notifications),
          )
        ],
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('HELLO USER', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TitleCard(Title: 'My Projects'),
              const SizedBox(height: 10),
              SizedBox(
                height: 160, // Increased height to prevent overflow
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: arr.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ProjectCard(name: arr[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TitleCard(Title: 'My Tasks'),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return TaskCard(name: "task ${index}", description: "description ${index}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
