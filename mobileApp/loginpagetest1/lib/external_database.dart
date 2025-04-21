// Currently using Direct Database Access but plan to move to flask backend

import 'package:mysql1/mysql1.dart';
import 'package:bcrypt/bcrypt.dart';
import 'login_page.dart';



class ExternalDatabase {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com',  // Should be correct for DDA at least
    port: 3306,   // Should be correct
    user: 'lizzetttapia',   // Need this
    password: 'admin123',   // Need this
    db: 'Inventory_Tracker',   // Need this (this is probably the issue)
    timeout: Duration(seconds: 30),
  );

  // Get Users Table
  Future<List<Map<String, dynamic>>> getUsers() async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var results = await conn.query('SELECT * FROM users');
      return results.map((r) => r.fields).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    } finally {
      await conn?.close();
    }
  }

  // Get Items Table
  Future<List<Map<String, dynamic>>> getItems() async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var results = await conn.query('SELECT * FROM items');

      List<Map<String, dynamic>> itemList = results.map((r) => r.fields).toList();

      print("Fetched items: $itemList");

      return itemList;
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    } finally {
      await conn?.close();
    }
  }



  // Get Items Table from Search (only specific Items of that name)
  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var results = await conn.query(
          "SELECT * FROM items WHERE name LIKE ?", ['%$query%']
      );
      return results.map((r) => r.fields).toList();
    } catch (e) {
      print("Error searching items: $e");
      return [];
    } finally {
      await conn?.close();
    }
  }

  // Get Orders Table
  Future<List<Map<String, dynamic>>> getOrders() async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var results = await conn.query('SELECT * FROM Orders');
      return results.map((r) => r.fields).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    } finally {
      await conn?.close();
    }
  }

  Future<bool> isUserExists(String email) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var results = await conn.query(
          'SELECT COUNT(*) FROM users WHERE email = ?', [email]
      );

      int count = results.first.fields.values.first;



      return count > 0;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    } finally {
      await conn?.close();
    }
  }

  Future<int> registerUser(String email, String password, String name) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
          'INSERT INTO users (email, password, name) VALUES (?, ?, ?)',
          [email, password, name]
      );


      return result.insertId ?? -1;
    } catch (e) {
      print("Error registering user: $e");
      return -1;
    } finally {
      await conn?.close();
    }
  }

  Future<bool> loginUser(String email, String password) async {
    MySqlConnection? conn;
    try {

      conn = await MySqlConnection.connect(settings);
      var results = await conn.query(

          'SELECT password FROM users WHERE email = ?', [email]
      );
      if (results.isEmpty) {
        return false; // User not found
      }

      String encryptedPassword = results.first.fields['password'];
      return BCrypt.checkpw(password, encryptedPassword);
    } catch (e) {
      print("Error logging in: $e");
      return false;
    } finally {
      await conn?.close();

    }
  }

  Future<int> updateItemQuantity(int itemId, int newQuantity) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);


      var result = await conn.query(
        'UPDATE items SET Quantity = ? WHERE Id = ?',

        [newQuantity, itemId],
      );

      return result.affectedRows ?? 0; // Returns how many rows were affected
    } catch (e) {
      print("Error updating item quantity: $e");
      return 0; // Return 0 if update failed
    } finally {
      await conn?.close();
    }
  }

  Future<int> addCheckoutList(int itemId, String itemName, String email, int quantity) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);


      // Check if entry already exists
      var existing = await conn.query(
        'SELECT quantity FROM returns WHERE item_id = ? AND email = ?',
        [itemId, email],
      );

      if (existing.isNotEmpty) {
        int existingQuantity = int.tryParse(existing.first['quantity'].toString()) ?? 0;
        int newQuantity = existingQuantity + quantity;

        print('Updating existing return entry:');
        print('  itemId = $itemId');
        print('  email = "$email"');
        print('  existing quantity = $existingQuantity');
        print('  new quantity = $newQuantity');


        var updateResult = await conn.query(
          'UPDATE returns SET quantity = ? WHERE item_id = ? AND email = ?',
          [newQuantity, itemId, email],
        );

        print('  Rows affected by update: ${updateResult.affectedRows}');

        return updateResult.affectedRows ?? 0;
      } else {
        // If not exists, insert new entry
        var insertResult = await conn.query(
          'INSERT INTO returns (item_id, item_name, email, quantity) VALUES (?, ?, ?, ?)',
          [itemId, itemName, email, quantity],
        );

        return insertResult.insertId ?? -1;
      }
    } catch (e) {
      print("Error adding to checkout list: $e");
      return -1;
    } finally {
      await conn?.close();
    }
  }

  Future<int> addOrdersList(int itemId, String itemName, String email, int quantity) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);

      // Check if entry already exists


        // If not exists, insert new entry
        var insertResult = await conn.query(
          'INSERT INTO orders (item_id, item_name, user_email, quantity) VALUES (?, ?, ?, ?)',
          [itemId, itemName, email, quantity],
        );

        return insertResult.insertId ?? -1;

    } catch (e) {
      print("Error adding to checkout list: $e");
      return -1;
    } finally {
      await conn?.close();
    }
  }

  Future<int> subtractCheckoutList(int itemId, String itemName, String email, int quantity) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);

      // Check if entry exists
      var existing = await conn.query(
        'SELECT quantity FROM returns WHERE item_id = ? AND email = ?',
        [itemId, email],
      );

      if (existing.isNotEmpty) {
        int existingQuantity = int.tryParse(existing.first['quantity'].toString()) ?? 0;
        int newQuantity = existingQuantity - quantity;

        if (newQuantity > 0) {
          // Update to new quantity if above 0
          var updateResult = await conn.query(
            'UPDATE returns SET quantity = ? WHERE item_id = ? AND email = ?',
            [newQuantity, itemId, email],
          );
          return updateResult.affectedRows ?? 0;
        } else if (newQuantity == 0) {
          // Delete entry if quantity reaches 0
          var deleteResult = await conn.query(
            'DELETE FROM returns WHERE item_id = ? AND email = ?',
            [itemId, email],
          );
          return deleteResult.affectedRows ?? 0;
        } else {
          // If trying to subtract more than exists, return -1 as error code
          return -1;
        }
      } else {
        // No entry to subtract from
        return -1;
      }
    } catch (e) {
      print("Error subtracting from checkout list: $e");
      return -1;
    } finally {
      await conn?.close();
    }
  }

  Future<bool> isItemReturnable(int itemId) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
        'SELECT returnable FROM items WHERE id = ?',
        [itemId],
      );
      return result.isNotEmpty && result.first['returnable'] == 1;
    } catch (e) {
      print('Error checking returnable status: $e');
      return false;
    } finally {
      await conn?.close();
    }
  }

  Future<int> getCheckedOutQuantity(int itemId, String userEmail) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
        'SELECT quantity FROM returns WHERE item_id = ? AND email = ?',
        [itemId, userEmail],
      );
      if (result.isNotEmpty) {
        return result.first['quantity'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching checked-out quantity: $e');
      return 0;
    } finally {
      await conn?.close();
    }
  }





}


