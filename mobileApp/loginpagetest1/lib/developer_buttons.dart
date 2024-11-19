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

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperState();
}



class _DeveloperState extends State<DeveloperPage> {

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

  void _deleteDatabase() async {
    await AuthenticationDB().deleteDatabaseFile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database deleted!')),
    );
  }

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
                  TextButton(
                    child: Container(
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

                  TextButton(
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
                    onPressed: _performCheckoutListSearch,
                  ),
                  Center(
                      child: TextButton(
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

                ]))));
  }
}
