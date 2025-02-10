// Currently using Direct Database Access but plan to move to flask backend

import 'package:mysql1/mysql1.dart';

class ExternalDatabase {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com',  // Should be correct for DDA at least
    port: 3306,   // Should be correct
    user: 'lizzetttapia',   // Need this
    password: 'admin123',   // Need this
    db: 'Inventory_Tracker',   // Need this (this is probably the issue)
    timeout: Duration(seconds: 20),
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

      print("Fetched items: $itemList"); // 🔍 Debugging: Check if any value is null

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
          "SELECT * FROM items WHERE item LIKE ?", ['%$query%']
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
}
