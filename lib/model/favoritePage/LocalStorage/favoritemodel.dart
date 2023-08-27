import 'package:hive/hive.dart';
part 'favoritemodel.g.dart';

//import 'package:localsotrage_handeling/modle/notesmodel.dart';

class Boxes {
  static Box<FavoriteModel> getData() => Hive.box<FavoriteModel>('favorite');
}

@HiveType(typeId: 0)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  String images;

  @HiveField(1)
  String name;

  @HiveField(2)
  String id;

  FavoriteModel(
    this.images,
    this.name,
    this.id,
  );
}
