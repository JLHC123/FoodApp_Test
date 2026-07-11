import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food.dart';

class FoodDatabase {
    Database? _database;

    // initalize the database
    Future<void> initializeDatabase() async {
        final databasePath = await getDatabasesPath();
        // Create new database seperate from the original food_app.db in case we need to continue testing in the original python code
        final path = join(databasePath, 'food_expiration_database.db');

        _database = await openDatabase(
            path,
            version: 1,
            onCreate: (db, version) async {
                await db.execute('''
                    CREATE TABLE food(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        expirationDate TEXT NOT NULL
                    )
                ''');
            },
        );
    }

    Future<void> insertFood(Food food) async {
        await _database?.insert(
            'food',
            {
                'name': food.name,
                'expirationDate': food.expirationDate.toIso8601String(),
            },
        );
    }

    Future<List<Food>> getAllFoods() async {
        final List<Map<String, Object?>> rows = await _database!.query('food');
        return rows.map((row) {
            return Food(
                id: row['id'] as int,
                name: row['name'] as String,
                expirationDate: DateTime.parse(row['expirationDate'] as String)
            );
        }).toList();
    }

    Future<void> deleteFood(int id) async {
        await _database?.delete(
            'food', 
            where: 'id = ?',
            whereArgs: [id]
        );
    }
}

