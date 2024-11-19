import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
// all packages and other pages referenced for this page ^


class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQState();
}

class _FAQState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 20),
          GlowText(
            'FAQ Page',
            style: GoogleFonts.orbitron(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('How can I obtain a staff or admin account?',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                      ),),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('To obtain an admin account, you must contact the app customer service and have them promote you to the appropriate status for your lab. To obtain a staff account .you must be promoted by an admin for the appropriate lab.',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('How can I register a student account?       ',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                      ),),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('Click the register button and enter your email address and create a password to register an account',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),),
                  ),

                  const SizedBox(height: 20),

                  Text('Can I check out multiple Items at a time?',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),),

                  const SizedBox(height: 20),


                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('Yes!! You can as long as your associated lab allows you to.',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),),
                  ),


                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('Do I need to return an Item when It is checked out?',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                      ),),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Text('Most items require you to turn It back in, though some smaller items such as screws and resistors do not',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),),
                  ),

                  const SizedBox(height: 20),


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
        ]))));
  }
}
