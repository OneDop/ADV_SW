import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  String name;
  ProjectCard({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.folder_special_rounded, size: 100, color: Colors.green,),
          Text(name),
      ],
      ),
    );
  }
}

class TitleCard extends StatelessWidget {
  String Title;
  TitleCard({super.key, required this.Title});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightBlue
        ),
        padding: EdgeInsets.all(5),
        child: Text(
            Title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            )
        )
    );
  }
}

class TaskCard extends StatelessWidget {
  String name;
  String? description;
  TaskCard({super.key, required this.name, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(color: Colors.white),),
        subtitle: Text(description ?? '', style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.check_circle_outline),
      )
    );
  }
}
