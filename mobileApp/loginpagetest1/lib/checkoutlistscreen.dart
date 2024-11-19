import 'package:flutter/material.dart';
import 'authentication_db.dart';
import 'home_page.dart';
import 'checkout_page.dart';
// all packages and other pages referenced for this page ^




class CheckoutListScreen extends StatefulWidget {
  final String searchQuery;
  CheckoutListScreen({required this.searchQuery});

  @override
  _CheckoutListScreenState createState() => _CheckoutListScreenState();
}

class _CheckoutListScreenState extends State<CheckoutListScreen> {
  List<Map<String, dynamic>> _checkoutList = [];

  @override
  void initState() {
    super.initState();
    _performSearch(widget.searchQuery);
  }

  Future<void> _performSearch(String query) async {
    List<Map<String, dynamic>> results;

    if (query == "*") {
      results = await AuthenticationDB().getCheckoutList();
    } else {
      results = await AuthenticationDB().searchDropdownItems(query);
    }

    setState(() {
      _checkoutList = results;
    });
  }

  Future<void> _loadItems() async {
    final dbStuff = AuthenticationDB();
    final data = await AuthenticationDB().getCheckoutList();
    setState(() {
      _checkoutList = data;
    });
    _checkoutList = data;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _checkoutList.isEmpty
          ? Column(
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      )
          : ListView.builder(
        itemCount: _checkoutList.length,
        itemBuilder: (context, index) {
          final checkoutList = _checkoutList[index];
          return ListTile(
            title: Text(checkoutList['userEmail']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item: ${checkoutList['checkoutItem'] ?? 'No Item'}'), // Display user email
                Text('Quantity: ${checkoutList['checkoutQuantity'] ?? '0'}'), // Display checkout quantity
              ],
            ),
          );



        },


      ),
      floatingActionButton: TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Text('Back to Search Page',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ),
      ),
    );

  }

}
