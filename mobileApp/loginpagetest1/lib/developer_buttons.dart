import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpagetest1/add_component.dart';
import 'package:loginpagetest1/checkoutlistscreen.dart';
import 'package:loginpagetest1/developer_buttons.dart';
import 'package:loginpagetest1/itemlistscreen.dart';
import 'login_page.dart';
import 'faq_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'home_page.dart';
import 'authentication_db.dart';
// all packages and other pages referenced for this page ^


// this page is meant to only be accessed by the developer
// it is where you can add components and view active checkouts
// you can also delete the database here


// This creates the DeveloperPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key}); // super.key identifies the key of the specific widget

  @override
  State<DeveloperPage> createState() => _DeveloperState();
}


// The line below creates a class for the AddComponentPage
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _DeveloperState extends State<DeveloperPage> {

  void _performCheckoutListSearch() { // this function creates a query from all active checkouts
    String query = "*"; // the list sends you to checkoutlistscreen with query
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutListScreen(searchQuery: query),
        ),
      );
    }
  }

  void _deleteDatabase() async { // this deletes the database
    await AuthenticationDB().deleteDatabaseFile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database deleted!')),
    );
  }

  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [
                  const SizedBox(height: 20),
                  GlowText(
                    'Welcome To the Developer Page',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton( // button for adding a component
                    child: Container( // sends to add component page
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Add Component Page',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: () {
                      Navigator
                          .push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddComponentPage())
                      );
                    },
                  ),

                  TextButton( // button for viewing active checkouts
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('View User Checkout List',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _performCheckoutListSearch,  // calls perform checkout list
                  ),
                  Center(
                      child: TextButton( // sends the user back to the home page
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('Return To Home Page',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const HomePage()));
                        },
                      )),

                  TextButton( // calls the delete database function
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Delete Database',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _deleteDatabase,
                  ),

                ]))));
  }
}
