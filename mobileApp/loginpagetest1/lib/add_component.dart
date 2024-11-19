import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'authentication_db.dart';
import 'package:email_validator/email_validator.dart';
// all packages and other pages referenced for this page ^







class AddComponentPage extends StatefulWidget {
  const AddComponentPage({super.key});
  @override
  State<AddComponentPage> createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<AddComponentPage> {

  // database stuff
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AuthenticationDB dbStuff = AuthenticationDB();
  bool _isReturnable = false;

  void _addItem() async {
    String item = _itemController.text.trim();
    String quantity = _quantityController.text.trim();


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


  void _deleteDatabase() async {
    await AuthenticationDB().deleteDatabaseFile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database deleted!')),
    );
  }
  // database stuff end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [

                  const SizedBox(height: 20),
                  Text('Add a component Here',
                    style: GoogleFonts.orbitron(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('   Enter component information',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _itemController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Item',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Quantity',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isReturnable,
                        onChanged: (value) {
                          setState(() {
                            _isReturnable = value ?? false;
                          });
                        },
                      ),
                      const Text('Returnable'),
                    ],
                  ),



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
                    onPressed: _addItem,
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


                  const SizedBox(height: 50),





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
