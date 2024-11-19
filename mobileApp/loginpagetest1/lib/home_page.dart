import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpagetest1/add_component.dart';
import 'package:loginpagetest1/checkoutlistscreen.dart';
import 'package:loginpagetest1/developer_buttons.dart';
import 'package:loginpagetest1/itemlistscreen.dart';
import 'login_page.dart';
import 'faq_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:image_picker/image_picker.dart';
// all packages and other pages referenced for this page ^







class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDropdownController = TextEditingController();
  TextEditingController _searchDropdownController2 = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  }


  void _performSearch() {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      // Navigate to SearchResultPage and pass the search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemsListScreen(searchQuery: query),
        ),
      );
    }
  }
  void _performAllSearch() {
    String query = "*";
    if (query.isNotEmpty) {
      // Navigate to SearchResultPage and pass the search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemsListScreen(searchQuery: query),
        ),
      );
    }
  }

  void _performCheckoutListSearch() {
    String query = "*";
    if (query.isNotEmpty) {
      // Navigate to SearchResultPage and pass the search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutListScreen(searchQuery: query),
        ),
      );
    }
  }

  void _performDropdownSearch() {
    String query = _searchDropdownController.text;
    String query2 = _searchDropdownController2.text;

    if (query.isNotEmpty && query2.isNotEmpty) {
      String combinedQuery = "$query $query2";
      // Navigate to SearchResultPage and pass the search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemsListScreen(searchQuery: combinedQuery),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [

                const SizedBox(height: 20),

                GlowText('Search for an item',
                  style: GoogleFonts.orbitron(
                  fontSize: 30,
                  ),
                ),

                const SizedBox(height: 40),

                  GestureDetector
                    (
                    onTap: () {
                      // Navigate to CheckoutPage with the selected item
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeveloperPage(),
                        ),
                      );
                    },
                    child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset( 'assets/new-labrat-glass.png', fit: BoxFit.cover),
                    ),
                  ),









                  /* DropdownMenu(
                  controller: _searchDropdownController,
                  label: const Text('Equipment Type'),
                  width: 300,
                  dropdownMenuEntries: const <DropdownMenuEntry<Color>> [
                  DropdownMenuEntry(value: Colors.red, label: 'Computer'),
                  DropdownMenuEntry(value: Colors.blue, label: 'Resistor'),
                  DropdownMenuEntry(value: Colors.red, label: 'Screw'),
                ]),

                 const SizedBox(height: 20),

                  /* const DropdownMenu(
                  label: Text('brand'),
                  width: 300,
                  dropdownMenuEntries: <DropdownMenuEntry<Color>> [
                  DropdownMenuEntry(value: Colors.red, label: 'TI'),
                  DropdownMenuEntry(value: Colors.blue, label: 'DELL'),
                  DropdownMenuEntry(value: Colors.red, label: 'AMD'),
                ]), */

                // const SizedBox(height: 20),

                  DropdownMenu(
                  controller: _searchDropdownController2,
                  label: const Text('Availability'),
                  width: 300,
                  dropdownMenuEntries: const <DropdownMenuEntry<Color>> [
                  DropdownMenuEntry(value: Colors.red, label: 'YES'),
                  DropdownMenuEntry(value: Colors.blue, label: 'NO'),
                ]),
                  const SizedBox(height: 20),

                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Search By Dropdowns',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _performDropdownSearch,
                  ), */

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          hintText: 'Search for Items by Name',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),


                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Search By Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _performSearch,
                  ),

                  GlowText('Or...',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),

                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('View All Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _performAllSearch,
                  ),

                  const SizedBox(height: 20),

                  GlowText('Or Scan An Item',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),

            //      IconButton(onPressed: _openCamera(), color: Colors.green[400], iconSize: 100, icon: Icon(Icons.camera_alt, color: Colors.green[300])),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Wrap async function in a synchronous callback
                      _openCamera();
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green[300], // Match the icon color
                      size: 100,                // Match the icon size
                    ),
                    label: Text(''),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent, // Remove shadow
                      padding: EdgeInsets.zero, // Remove padding for a compact look
                      minimumSize: Size(100, 100), // Match the button size to icon size
                    ),// Match the button size to icon size
                  ),


                  Center(child: TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('FAQ page',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                    ),
                    onPressed: () {
                      Navigator
                          .push(
                          context,
                          MaterialPageRoute(builder: (context) => const FAQPage())
                      );
                    },
                  )),

                  Center(child: TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Sign Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                    ),
                    onPressed: () {
                      Navigator
                          .push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    },
                  )),











 // ],)
                ])),


        ));






  }
}










