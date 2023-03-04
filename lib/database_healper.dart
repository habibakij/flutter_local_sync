
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data_model.dart';

class DatabaseHelper{

  /*static late DatabaseHelper _databaseHelper;
  static late Database _database;
  DatabaseHelper.createInstance();
  factory DatabaseHelper(){
    _databaseHelper ??= DatabaseHelper.createInstance();
    return _databaseHelper;
  }*/

  static late Database _database;
  final String _databaseName= "akij.db";
  String tableName= "akij_table";
  String colID= "id";
  String colName= "name";
  String colDesignation= "designation";
  String colCompany= "company";
  String colExperience= "experience";

  // this opens the database (and creates it if it doesn't exist)
  Future<void> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// create db
  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colDesignation TEXT, $colCompany TEXT, $colExperience INTEGER)');
  }
  /// insert data
  Future<int> insertData(DataStoredModel model) async {
    //Database database= await this.database;
    var result= await _database.insert(tableName, model.toMap());
    return result;
  }
  /// fetch data
  Future<List<Map<String, dynamic>>> fetchDataList() async {
    //Database database= await this.database;
    var result= await _database.query(tableName, orderBy: "$colID ASC");
    return result;
  }
  /// update
  Future<int> updateData(DataStoredModel model) async {
    //Database database= await this.database;
    var result= await _database.update(tableName, model.toMap(), where: "$colID = ?", whereArgs: [model.id]);
    return result;
  }
  /// delete
  Future<int> deleteData(int id) async {
    //Database database= await this.database;
    var result= await _database.rawDelete("DELETE FROM $tableName WHERE $colID =  $id");
    return result;
  }
  /// get total number of data
  Future<int?> getCount() async {
    //Database database= await this.database;
    List<Map<String, dynamic>> list= await _database.rawQuery("SELECT COUNT (*) from $tableName");
    int? result= Sqflite.firstIntValue(list);
    return result;
  }
  /// get map type data and converted data model type
  Future<List<DataStoredModel>> getAllConvertedData() async {
    var dataMapList= await fetchDataList();
    int count= dataMapList.length;
    List<DataStoredModel> dataModelList= [];
    for(int i= 0; i<count; i++){
      dataModelList.add(DataStoredModel.fromMapToObject(dataMapList[i]));
    }
    return dataModelList;
  }



}