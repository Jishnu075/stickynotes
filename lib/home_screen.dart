import 'package:flutter/material.dart';
import 'package:stickynotes/add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sticky Notes"), centerTitle: false, actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()));
          },
          child: const Icon(Icons.add)),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [
          Container(color: Colors.amber, child: Text("data")),
          Container(color: Colors.amber, child: Text("data")),
          Container(color: Colors.amber, child: Text("data")),
          Container(color: Colors.amber, child: Text("data")),
        ],
      ),
    );
  }
}
