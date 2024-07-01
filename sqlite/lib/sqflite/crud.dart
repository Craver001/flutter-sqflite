// import 'package:sqflite/sqflite.dart';

// Future<int> insertItem(Database database, String name) async {
//   return await database.insert(
//     'items',
//     {'name': name},
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<List<Map<String, dynamic>>> retrieveItems(Database database) async {
//   return await database.query('items');
// }

// Future<int> updateItem(Database database, int id, String name) async {
//   return await database.update(
//     'items',
//     {'name': name},
//     where: 'id = ?',
//     whereArgs: [id],
//   );
// }

// Future<int> deleteItem(Database database, int id) async {
//   return await database.delete(
//     'items',
//     where: 'id = ?',
//     whereArgs: [id],
//   );
// }
