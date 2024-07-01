import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE borrower_profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        borrower TEXT NOT NULL, 
        borrow_amount INTEGER, 
        monthly_payment INTEGER, 
        total_repayment_amount INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('loanchal.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<int> createItem(String borrower, int borrow_amount,
      int monthly_payment, int total_repayment_amount) async {
    final db = await SQLHelper.db();
    final data = {
      'borrower': borrower,
      'borrow_amount': borrow_amount,
      'monthly_payment': monthly_payment,
      'total_repayment_amount': total_repayment_amount
    };

    final id = await db.insert('borrower_profile', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('borrower_profile', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('borrower_profile',
        where: "id= ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String borrower, int borrow_amount,
      int monthly_payment, int total_repayment_amount) async {
    final db = await SQLHelper.db();
    final data = {
      'borrower': borrower,
      'borrow_amount': borrow_amount,
      'monthly_payment': monthly_payment,
      'total_repayment_amount': total_repayment_amount,
      'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('borrower_profile', data, where: "id =?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("borrower_profile", where: "id =?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting item from database");
    }
  }
}
