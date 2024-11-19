import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'login_page.dart';
import 'itemlistscreen.dart';
// all packages and other pages referenced for this page ^




class AuthenticationDB {

  static final AuthenticationDB _instance = AuthenticationDB._internal();
  static Database? _database;

  factory AuthenticationDB() {
    return _instance;
  }

  static const String _dbName = 'auth.db';
  static const int _dbVersion = 1;

  static const String _tableName = 'users';
  static const String columnId = 'id';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  static const String _table2Name = 'items';
  static const String columnId2 = 'id2';
  static const String columnItem = 'item';
  static const String columnQuantity = 'quantity';
  static const String columnAvailability = 'availability';
  static const String columnReturnable = 'returnable';


  static const String _table3Name = 'checkoutList';
  static const String columnId3 = 'id3';
  static const String columnUserEmail = 'userEmail';
  static const String columnCheckoutItem = 'checkoutItem';
  static const String columnCheckoutQuantity = 'checkoutQuantity';



  AuthenticationDB._internal();

  // factory AuthenticationDB() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $_tableName('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnEmail TEXT NOT NULL UNIQUE,'
        '$columnPassword TEXT NOT NULL)');

    await db.execute('CREATE TABLE $_table2Name('
        '$columnId2 INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnItem TEXT NOT NULL,'
        '$columnQuantity TEXT NOT NULL,'
        '$columnAvailability TEXT NOT NULL,'
        '$columnReturnable INTEGER NOT NULL DEFAULT 0)');

    await db.execute('CREATE TABLE $_table3Name('
        '$columnId3 INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnUserEmail TEXT NOT NULL,'
        '$columnCheckoutItem TEXT NOT NULL,'
        '$columnCheckoutQuantity TEXT NOT NULL)');
  }


  // Register user
  Future<int> registerUser(String email, String password) async {
    final db = await database;
    try {
      return await db.insert(
        _tableName,
        {
          columnEmail: email,
          columnPassword: password,
        },
      );
    } catch (e) {
      return -1;  // If email already exists, return error code
    }
  }

  Future<int> addItem(String item, String quantity, {bool returnable = false}) async {
    final db = await database;
    int integerQuantity = int.tryParse(quantity) ?? 0;
    String availability = (integerQuantity > 0) ? 'YES' : 'NO';
    int returnability = returnable ? 1 : 0;
    try {
      return await db.insert(
        _table2Name,  // 'items' table
        {
          columnItem: item,        // Ensure these match the column names in the table
          columnQuantity: quantity,
          columnAvailability: availability,
          columnReturnable: returnability,
        },
      );
    } catch (e) {
      print("Error inserting item: $e");  // Check what error is printed
      return -1;
    }
  }

  Future<int> addCheckoutList(String item, String quantity) async {
    final db = await database;

    if (userEmail == null) {
      userEmail = 'usernotfound';
    }

    final existingEntry = await db.query(
      _table3Name,
      where: '$columnUserEmail = ? AND $columnCheckoutItem = ?',
      whereArgs: [userEmail, item],
    );


    if ( existingEntry.isNotEmpty ) {
      int existingQuantity = int.tryParse(existingEntry[0][columnCheckoutQuantity].toString()) ?? 0;
      int checkoutQuantity = int.tryParse(quantity)?? 0;
      int newQuantity = existingQuantity + checkoutQuantity;
      int entryId = existingEntry[0][columnId3] as int;
      try {
        int result = await db.update(
          _table3Name,
          {
            columnCheckoutQuantity: newQuantity.toString(),
          },
          where: '$columnId3 = ?', // Ensure this corresponds to your column name
          whereArgs: [entryId],
        );

        return result; // Return the number of affected rows
      } catch (e) {
        return 0; // Return 0 if an error occurs
      }

    }
    else {
      try {
        return await db.insert(
          _table3Name, // 'items' table
          {
            columnUserEmail: userEmail,
            // Ensure these match the column names in the table
            columnCheckoutItem: item,
            columnCheckoutQuantity: quantity,
          },
        );
      } catch (e) {
        print("Error inserting item: $e"); // Check what error is printed
        return -1;
      }
    }
  }

  Future<int> subtractCheckoutList(String item, String quantity) async {
    final db = await database;

    if (userEmail == null) {
      userEmail = 'usernotfound';
    }

    final existingEntry = await db.query(
      _table3Name,
      where: '$columnUserEmail = ? AND $columnCheckoutItem = ?',
      whereArgs: [userEmail, item],
    );


    if ( existingEntry.isNotEmpty ) {
      int existingQuantity = int.tryParse(
          existingEntry[0][columnCheckoutQuantity].toString()) ?? 0;
      int checkoutQuantity = int.tryParse(quantity) ?? 0;
      int newQuantity = existingQuantity - checkoutQuantity;
      int entryId = existingEntry[0][columnId3] as int;
      if (newQuantity < 0) {
        return -1;
      }
      else if (newQuantity == 0) {

        try {
          int result = await db.delete(
            _table3Name,
            where: '$columnId3 = ?',
            whereArgs: [entryId],
          );
          return result;
        } catch (e) {
          return 0; // Return 0 if an error occurs
        }

      }
      else {

      try {
        int result = await db.update(
          _table3Name,
          {
            columnCheckoutQuantity: newQuantity.toString(),
          },
          where: '$columnId3 = ?',
          // Ensure this corresponds to your column name
          whereArgs: [entryId],
        );

        return result; // Return the number of affected rows
      } catch (e) {
        return 0; // Return 0 if an error occurs
      }
    }

    }
    else {
        return -1;
    }
  }



  Future<int> deleteUser(String email, String password) async {
    final db = await database;
    try {
      return await db.delete(
        _tableName,
      );
    } catch (e) {
      return 1;  // If email already exists, return error code
    }
  }

  // Login user
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$columnEmail = ? AND $columnPassword = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  // Check if user exists
  Future<bool> isUserExists(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM items');  // Using rawQuery to ensure only 'items' table is queried
  }
  Future<List<Map<String, dynamic>>> getCheckoutList() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM checkoutList');  // Using rawQuery to ensure only 'items' table is queried
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database; // Reference to your SQLite database

    return await db.query(
      'items', // Table name
      where: "item LIKE ?", // Search condition, assuming 'name' is the column you're searching
      whereArgs: ['%$query%'], // This enables partial matching
    );
  }

  Future<List<Map<String, dynamic>>> searchCheckoutList(String query) async {
    final db = await database; // Reference to your SQLite database

    return await db.query(
      'checkoutList', // Table name
      where: "userEmail LIKE ?", // Search condition, assuming 'name' is the column you're searching
      whereArgs: ['%$query%'], // This enables partial matching
    );
  }

  Future<List<Map<String, dynamic>>> searchDropdownItems(String query) async {
    final db = await database; // Reference to your SQLite database

    return await db.query(
      'items', // Table name
      where: "item LIKE ? OR availability LIKE ?", // Search condition for both columns
      whereArgs: ['%$query%', '%$query%'], // Partial matching for both columns
    );
  }


  /* Future<List<Map<String, dynamic>>> getItems() async {
     final db = await database;
     return await db.query('items');
   }
   delete later
  Future<void> insertItem(String name) async {
    final db = await database;
    await db.insert('items', {'name': name});
  } */

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);
    print('Database deleted');
  }

  Future<int> updateItemQuantity(int itemId, int newQuantity) async {
    final db = await database;

    print('Updating item with ID $itemId to new quantity $newQuantity');

    try {
      int result = await db.update(
        _table2Name,
        {
          columnQuantity: newQuantity.toString(),
          columnAvailability: newQuantity > 0 ? 'YES' : 'NO',
        },
        where: '$columnId2 = ?', // Ensure this corresponds to your column name
        whereArgs: [itemId],
      );

      print('Update result: $result rows affected.');
      return result; // Return the number of affected rows
    } catch (e) {
      print('Error updating item quantity: $e'); // Log any error
      return 0; // Return 0 if an error occurs
    }
  }



}




