import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication_db.dart';
import 'itemlistscreen.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'external_database.dart';
import 'package:mysql1/mysql1.dart';
import 'login_page.dart';


// all packages and other pages referenced for this page ^



// This creates the CheckoutPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class CheckoutPage extends StatefulWidget {
  // final Map<String, dynamic> item;
  final int itemId;
  const CheckoutPage({Key? key, required this.itemId}) : super(key: key);


  // const CheckoutPage({Key? key, required this.item}) : super(key: key);
// super.key identifies the key of the specific widget
  // the item is passed as a key which sets attributes of the page
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}


// The line below creates a class for the CheckoutPage
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _CheckoutPageState extends State<CheckoutPage> {
  // controllers are used to track quantity entered, email is no longer tracked this way
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  // makes it easier to use database functions
  // final AuthenticationDB dbStuff = AuthenticationDB();
  // sets the acknowledgement check box variable
  bool _acknowledgement = false;

  String _itemName = '';
  String _Supplier = '';
  int _quantityAvailable = 0;
  bool _returnable = false;
  bool _isLoading = true;

  final String email = userEmail!; // Replace with actual user session email

  // Fetch item data by ID
  Future<void> _fetchItemData() async {
    ExternalDatabase db = ExternalDatabase();
    List<Map<String, dynamic>> items = await db.getItems();

    // Adjust the correct key for ID, make sure it's capital 'Id'
    Map<String, dynamic>? item = items.firstWhere(
          (element) => element['Id'] == widget.itemId, // Ensure 'Id' matches database column
      orElse: () => {},
    );

    if (item.isNotEmpty) {
      setState(() {
        _itemName = item['Name'];
        _quantityAvailable = item['Quantity'];
        _returnable = item['returnable'] == 1;
        _Supplier = item['Supplier'];
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item not found')),
      );
      Navigator.pop(context);
    }
  }





  // checkout function
  void _checkoutItem() async {
    int checkoutQuantity = int.tryParse(_quantityController.text) ?? 0;

    // Validation
    if (checkoutQuantity <= 0 || checkoutQuantity > _quantityAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }
    if (!_acknowledgement & (_returnable == true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please check the user acknowledgement')),
      );
      return;
    }

    int newQuantity = _quantityAvailable - checkoutQuantity;

    // Update item quantity in DB
    await ExternalDatabase().updateItemQuantity(widget.itemId, newQuantity);

    String userName = 'USER';
    try {
      var users = await ExternalDatabase().getUsers();
      var user = users.firstWhere((u) => u['email'] == email, orElse: () => {});
      if (user.isNotEmpty && user.containsKey('name')) {
        userName = user['name'];
      } else {
        print("No user found with email $email or missing name column.");
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }

    await ExternalDatabase().addOrdersList(
      widget.itemId,
      _returnable,
      _itemName,
      email,
      checkoutQuantity,
      userName,
    );

    // If returnable, add to checkout list (returns table)
    if (_returnable) {
      await ExternalDatabase().addCheckoutList(
        widget.itemId,
        _itemName,
        email,
        checkoutQuantity,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item checked out successfully')),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  // function to check in an item
  void _checkInItem() async {

    if (_returnable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item Cannot be Returned')),
      );
      return;
    }

    int checkInQuantity = int.tryParse(_quantityController.text) ?? 0;

    if (checkInQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    int newQuantity = _quantityAvailable + checkInQuantity;

    // Update item quantity in DB
    await ExternalDatabase().updateItemQuantity(widget.itemId, newQuantity);

    // If returnable, subtract from checkout list (returns table)
    if (_returnable) {
      int result = await ExternalDatabase().subtractCheckoutList(
        widget.itemId,
        _itemName,
        email,
        checkInQuantity,
      );

      if (result == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot check in more than checked out.')),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item checked in successfully')),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  // subtracts from active checkout list if an item is checked back in


  @override
  void initState() {
    super.initState();
    _fetchItemData();
  }

  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,


      // padding and other functions makes UI look better
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            GlowText('        Checkout Item',
              style: GoogleFonts.orbitron(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),

            Text('Item: $_itemName', style: GoogleFonts.roboto(fontSize: 20)),
            SizedBox(height: 10),
            Text('Quantity Available: $_quantityAvailable',
                style: GoogleFonts.roboto(fontSize: 20)),
            SizedBox(height: 10),
            Text('Returnable: ${_returnable ? "Yes" : "No"}',
                style: GoogleFonts.roboto(fontSize: 20)),
            SizedBox(height: 10),

            Text('Supplier: $_Supplier', style: GoogleFonts.roboto(fontSize: 20)),
            SizedBox(height: 10),


            // box to enter the desired quantity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[250],
                  border: Border.all(color: Colors.white),
                ),
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    hintText: 'Quantity',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),


            TextButton( // button to check out the item
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Check out Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),),
              onPressed: () {
                _checkoutItem();  // Call the check-out function
               // _addCheckoutList();  // Call the add-to-checkout-list function
              },

            ),

            TextButton( // button to check in the item
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Check in Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),),
              onPressed: () {
                _checkInItem();
             //   _subtractCheckoutList();// also checks in item
              },

            ),
            const SizedBox(height: 10),

            Center( // a&m picture
              child: Container(
                height: 220,
                width: 220,
                child: Image.asset('assets/pngegg.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),

            Row(  // acknowledgment box
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _acknowledgement,
                  onChanged: (value) {
                    setState(() {
                      _acknowledgement = value ?? false;
                    });
                  },
                ),

                const Text('I agree that the following items must be \n returned'
                    'in the same condition they were \n received. '
                    'Any responsibility for damage '
                    '\n will be placed on me, the user. \n'
                    'Agreement of this clause leaves all liability \n on myself and not LabRat.'),

              ],

            ),
            const SizedBox(height: 10),

            Align( // sends the user back to the home page
              alignment: Alignment.centerRight,

              child: TextButton(



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

                  child: Text('Back to Home Page',

                      style: TextStyle(

                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            //



          ],
        ),
      ),
    );
  }
}
