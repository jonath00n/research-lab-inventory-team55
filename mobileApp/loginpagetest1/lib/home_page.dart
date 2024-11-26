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






// This creates the HomePage as a stateful widget
// this means that it is able to be changed based on interaction or other events
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
// function to open the camera
  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  }

// performs a search of the items with the name that is entered in the search box
  // text is retrieved using the search controller
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

  // performs a search of all of the items
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

  // searches the checkout list
  // not currently used in this page
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

  // this is not used as of right now since i decided not to use dropdown menus
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

                GlowText('Search for an item',
                  style: GoogleFonts.orbitron(
                  fontSize: 30,
                  ),
                ),

                const SizedBox(height: 40),

                  GestureDetector // makes it so that you can click on the image to go to the developer page
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







                // the dropdown menus are not currently used, though they may be added back later

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

                  Padding( // text box to search items
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _searchController, // uses the search controller to create query
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


                  TextButton( // button to search based on text entered in search box
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
                    onPressed: _performSearch, // calls the perform search function
                  ),

                  GlowText('Or...',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),

                  TextButton( // button to view all of the items
                    child: Container( // populates the query with all item entries
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
                    onPressed: _performAllSearch,  // calls perform all search
                  ),

                  const SizedBox(height: 20),

                  GlowText('Or Scan An Item',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),

            //      IconButton(onPressed: _openCamera(), color: Colors.green[400], iconSize: 100, icon: Icon(Icons.camera_alt, color: Colors.green[300])),

                  ElevatedButton.icon( // this is the icon that calls the open camera function
                    onPressed: () {
                      _openCamera(); // calls the open camera function
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green[300],
                      size: 100,
                    ),
                    label: Text(''), // formatting for the camera icon
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(100, 100),
                    ),
                  ),


                  Center(child: TextButton( // button that sends the user to the faq page
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

                  Center(child: TextButton( // button that signs out the user
                    child: Container( // aka sends them to login page
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










