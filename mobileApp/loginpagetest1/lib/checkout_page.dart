import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication_db.dart';
import 'itemlistscreen.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
// all packages and other pages referenced for this page ^




class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const CheckoutPage({Key? key, required this.item}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}



class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AuthenticationDB dbStuff = AuthenticationDB();
  bool _acknowledgement = false;


  void _checkoutItem() async {
    int checkoutQuantity = int.tryParse(_quantityController.text) ?? 0;
    int currentQuantity =  int.tryParse(widget.item['quantity']) ?? 0;
    int returnable = widget.item['returnable'] ?? 0;

    // Validate input quantity
    if (checkoutQuantity <= 0 || checkoutQuantity > currentQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    if (_acknowledgement == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please check the user acknowlegement')),
      );
      return;
    }

    // Calculate the new quantity
    int newQuantity = currentQuantity - checkoutQuantity;
    int itemId = widget.item['id2']; // Replace 'id2' with the actual ID key of the item
    int result = await AuthenticationDB().updateItemQuantity(itemId, newQuantity);
    if (returnable == 1) {
      _addCheckoutList(); // Call add-to-checkout-list function
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Change to your home screen widget
    );
  }

  void _checkInItem() async {
    int checkInQuantity = int.tryParse(_quantityController.text) ?? 0;
    int currentQuantity =  int.tryParse(widget.item['quantity']) ?? 0;

    // Validate input quantity
    if (checkInQuantity <= 0 ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid item and quantity')),
      );
      return;
    }

    // Calculate the new quantity
    int newQuantity = currentQuantity + checkInQuantity;
    int itemId = widget.item['id2']; //
    int result = await AuthenticationDB().updateItemQuantity(itemId, newQuantity);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Change to your home screen widget
    );
  }

  void _addCheckoutList() async {

      String item = widget.item['item'];
      String quantity = _quantityController.text.trim();

      int result = await dbStuff.addCheckoutList(item, quantity);
      if (result != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout User added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Addition failed.')),
        );
      }
  }

  void _subtractCheckoutList() async {
    int returnable = widget.item['returnable'] ?? 0;
    if (returnable == 1) {
      String item = widget.item['item'];
      String quantity = _quantityController.text.trim();


      int result = await dbStuff.subtractCheckoutList(item, quantity);
      if (result != -1) {
        _checkInItem();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check In User added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter valid Item and Quantity')),
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item is not returnable')),
      );
    }
  }


  /*@override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _emailController.dispose();
    _quantityController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

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

            Text('Item: ${widget.item['item']}', style: GoogleFonts.roboto(
              fontSize: 20,
            ),),
            SizedBox(height: 10),
            Text('Quantity Available: ${widget.item['quantity']}', style: GoogleFonts.roboto(
              fontSize: 20,
            ),),
            SizedBox(height: 10),
            Text('Available for Checkout?: ${widget.item['availability']}', style: GoogleFonts.roboto(
              fontSize: 20,
            ),),
            SizedBox(height: 10),

            /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.white),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                ),
              ),
            ), */


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


            TextButton(
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

            TextButton(
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
             //   _checkInItem();
                _subtractCheckoutList();// also checks in item
              },

            ),
            const SizedBox(height: 10),

            Center(
              child: Container(
                height: 220,
                width: 220,
                child: Image.asset('assets/pngegg.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),

            Row(
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

            Align(
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
            // b90953c3149805219d27829ccc85c79c.png



          ],
        ),
      ),
    );
  }
}
