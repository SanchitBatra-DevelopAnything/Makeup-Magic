import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './photo.dart';

class DBHelper{

  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'photoName';
  static const String TABLE = 'photosTable';
  //static const String TABLE1 = 'hairTable' ;
  //static const String TABLE2 = 'partyTable';//bridal table , ese hi 2 aur table banaake getPhotos likhdo unke liye b.
  static const String DB_NAME = 'photos.db';

  Future<Database> get db async{
    if(null != _db)
    {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,DB_NAME);
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db,int version) async{
     await db.execute('CREATE TABLE $TABLE ($ID INTEGER , $NAME TEXT)');
  }

  Future<dynamic> clearDataOfBride() async{
    //await _db.execute('DELETE FROM $TABLE');
    var dbClient = await db;
    await dbClient.execute('DELETE FROM $TABLE');
  }

  

  

  Future<Photo> saveInBride(Photo photo) async{
    var dbClient = await db;
    photo.id = await dbClient.insert(TABLE, photo.toMap());
  }

  

  Future<List<Photo>> getPhotosOfBrides() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,columns : [ID,NAME]);
    List<Photo> photos = [];
    if(maps.length > 0)
    {
      for(int i=0;i<maps.length;i++)
      {
        photos.add(Photo.fromMap(maps[i]));
      }
    }
    return photos;
  }
  
  Future close() async{
    var dbClient = await db;
    dbClient.close(); 
  }

}
