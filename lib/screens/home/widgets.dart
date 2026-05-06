import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  String name;
  ProjectCard({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.folder_special_rounded, size: 30,),
          Text(name),
      ],
      ),
    );
  }
}
