import 'package:hive/hive.dart';
part 'addpter.g.dart';




@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;



  Note({
     required this.title,
     required this.content,
   // this.timeDetail
  });
}
