import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'faq_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(children: [

                  const SizedBox(height: 20),

                  Text('Welcome To the Home Page',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20),



                  Center(child: TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Return To Login Page',
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
                          MaterialPageRoute(builder: (context) => LoginPage())
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
                      child: Center(
                        child: Text('FAQ page',
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
                          MaterialPageRoute(builder: (context) => FAQPage())
                      );
                    },
                  )),
                  const SizedBox(height: 20),

    Row(children: [
      const SizedBox(width: 20),

      DropdownMenu(
          label: const Text('Equipment Type'),
          width: 100,
          dropdownMenuEntries: <DropdownMenuEntry<Color>> [
            DropdownMenuEntry(value: Colors.red, label: 'Computer'),
            DropdownMenuEntry(value: Colors.blue, label: 'Resistor'),
            DropdownMenuEntry(value: Colors.red, label: 'Screw'),
          ]),
    const SizedBox(width: 20),

    DropdownMenu(
        label: const Text('brand'),
        width: 100,
        dropdownMenuEntries: <DropdownMenuEntry<Color>> [
        DropdownMenuEntry(value: Colors.red, label: 'TI'),
        DropdownMenuEntry(value: Colors.blue, label: 'DELL'),
        DropdownMenuEntry(value: Colors.red, label: 'AMD'),
      ]),

      const SizedBox(width: 20),

      DropdownMenu(
        label: const Text('Avalability'),
        width: 100,
        dropdownMenuEntries: <DropdownMenuEntry<Color>> [
        DropdownMenuEntry(value: Colors.red, label: 'YES'),
        DropdownMenuEntry(value: Colors.blue, label: 'NO'),
          ]),

  ],)
                ])),


        ));






  }
}










