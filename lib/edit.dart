
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  //runApp(MyApp());
  runApp(MaterialApp(
    home: first(),
  ));
}

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.readString(),
      content: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
  }
}

class first extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Note',
      color: Colors.black,
      // theme: ThemeData(

      // primarySwatch: Colors.blue,
      //),
      home: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade500,
      appBar: AppBar(backgroundColor: Colors.grey.shade800,
        title: Center(child: Text('Notes')),
      ),
      body: ValueListenableBuilder<Box<Note>>(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, box, _) {
          return  Container(
            margin: EdgeInsets.all(10),
            //decoration: BoxDecoration(border: Border.all(width: 2)),
            child: GridView.builder(
              itemCount: box.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,crossAxisSpacing: 20,mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                final note = box.getAt(index)!;
                return Container(
                  // height: 50,
                  // width: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.circular(20),),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 5,),
                      Container(
                        // decoration: BoxDecoration(border: Border.all(width: 2)),
                        child: Text(note.title),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(note.content),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {
                            box.deleteAt(index);

                          }, icon: Icon(Icons.delete)),
                          IconButton(onPressed: () {
                            //box.deleteAt(index);

                          }, icon: Icon(Icons.edit)),
                        ],
                      )
                    ],
                  ),
                );

              },),
          );

          // return ListView.builder(
          //   itemCount: box.length,
          //   itemBuilder: (context, index) {
          //     final note = box.getAt(index)!;
          //     return ListTile(
          //       title: Text(note.title),
          //       subtitle: Text(note.content),
          //       trailing: IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () {
          //           box.deleteAt(index);
          //         },
          //       ),
          //     );
          //   },
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.grey.shade800,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade500,
      appBar: AppBar(backgroundColor: Colors.grey.shade800,
        title: Center(child: Text('Add Note')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: contentController,style: TextStyle(backgroundColor: Colors.grey),
              decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  final noteBox = Hive.box<Note>('notes');
                  noteBox.add(Note(
                    title: title,
                    content: content,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}