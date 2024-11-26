import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'authentication_db.dart';
import 'package:email_validator/email_validator.dart';
// all packages and other pages referenced for this page ^


// This page is where  i'm able to add a new component to the Items table of the database
// This page is not meant to be accessed by regular users
// It is for the purpose of creating a sample dataset for testing
// this page will be excluded from the final app



// This creates the AddComponentPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class AddComponentPage extends StatefulWidget {
  const AddComponentPage({super.key});
  @override
  State<AddComponentPage> createState() => _AddComponentPageState();
}

// The line below creates a class for the AddComponentPage
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _AddComponentPageState extends State<AddComponentPage> {

  // These are controllers that allow the item and quantity to be stored from the text box
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  // This references the database and allows functions from the database file to be used
  final AuthenticationDB dbStuff = AuthenticationDB();
  // Initializes the returnable variable
  bool _isReturnable = false;

  // This function adds an Item to the Items table of the database
  // Adds the item and quantity based on what is entered in the text boxes
  void _addItem() async {
    String item = _itemController.text.trim();
    String quantity = _quantityController.text.trim();

    // Attempts to add the item to the database with the returnable variable set by the check box
    // if the attempt is successful or fails a snack bar will make that known
    print('Trying to add item: $item, quantity: $quantity');
    int result = await dbStuff.addItem(item, quantity, returnable: _isReturnable);
    if (result != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Component added successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Addition failed.')),
      );
    }
  }

    // This function deletes the entire database with all of the tables
    // meant to be used when making changes to the database
    // if deleted, the database will reinitialize at the start of the app
  void _deleteDatabase() async {
    await AuthenticationDB().deleteDatabaseFile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database deleted!')),
    );
  }
  // database stuff end

  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [ // creates a column of child widgets

                  const SizedBox(height: 20),  // blank box meant to add space
                  Text('Add a component Here',  // text
                    style: GoogleFonts.orbitron(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10), // blank box meant to add space
                  Text('   Enter component information', // text
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),),
                  const SizedBox(height: 20), // blank box meant to add space

                  // This is the text box where you can enter the item to add
                  // padding makes it so that the box fits better and looks nice
                  // box decoration is also used to make the box look nicer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _itemController, // so that entered text can be used
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Item',  // shows what should be entered in the box
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // blank box meant to add space

                  // This is the text box where you can enter the quantity
                  // padding makes it so that the box fits better and looks nice
                  // box decoration is also used to make the box look nicer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _quantityController, // so that entered text can be used
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Quantity', // shows what should be entered in the box
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // blank box meant to add space

                  // This is a widget that is a row
                  // It contains the text box for whether an item is returnable
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isReturnable,  // tracks if box is checked or not
                        onChanged: (value) {
                          setState(() { // sets the state of the variable
                            _isReturnable = value ?? false;
                          });
                        },
                      ),
                      const Text('Returnable'),
                    ],
                  ),


                  // Text button for adding the component
                  // Container, padding, and box decoration makes button look nicer

                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Add Component',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _addItem, // Calls the addItem function when pressed
                  ),

                  Center(child: TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Back To Home Page',
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
                          MaterialPageRoute(builder: (context) => HomePage())
                      );
                    },
                  )),


                  const SizedBox(height: 50), // blank box meant to add space




                  // This button deletes the database, not meant to be accessed by users
                  // allows me to clear all database information
                  // or recreate the database on a new launch if i change the database
                  TextButton(
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






                ]))

        ));

  }
  }
