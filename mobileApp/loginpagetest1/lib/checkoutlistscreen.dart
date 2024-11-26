import 'package:flutter/material.dart';
import 'authentication_db.dart';
import 'home_page.dart';
import 'checkout_page.dart';
// all packages and other pages referenced for this page ^

// this page is the page that displays the table of active checkouts

// This creates the CheckoutPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class CheckoutListScreen extends StatefulWidget {
  final String searchQuery;
  CheckoutListScreen({required this.searchQuery});

  @override
  _CheckoutListScreenState createState() => _CheckoutListScreenState();
}

// The line below creates a class for the CheckoutListScreen
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _CheckoutListScreenState extends State<CheckoutListScreen> {
  List<Map<String, dynamic>> _checkoutList = [];

  @override
  void initState() { // calls perform search function
    super.initState(); // makes it so that logic in state is defined first
    _performSearch(widget.searchQuery);
  }

  Future<void> _performSearch(String query) async { // searches based on query created
    List<Map<String, dynamic>> results;

    if (query == "*") {
      results = await AuthenticationDB().getCheckoutList(); // gets checkout list from query
    } else { // no longer use dropdown menus
      results = await AuthenticationDB().searchDropdownItems(query);
    }

    setState(() { // sets state as a result of the search
      _checkoutList = results;
    });
  }

  // not used in latest version
  Future<void> _loadItems() async {
    final dbStuff = AuthenticationDB();
    final data = await AuthenticationDB().getCheckoutList();
    setState(() {
      _checkoutList = data;
    });
    _checkoutList = data;

  }

  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _checkoutList.isEmpty
          ? Column(
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      )
          : ListView.builder( // builds and makes it so that the list can be viewed
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
      floatingActionButton: TextButton(  // button that sends the user back to home page
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
