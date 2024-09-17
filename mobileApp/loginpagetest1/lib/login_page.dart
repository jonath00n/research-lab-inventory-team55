import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
      child: Column(children: [

        const SizedBox(height: 20),
        Text('Welcome To LabRat',
        style: GoogleFonts.orbitron(
          fontSize: 30,
        ),
        ),
        const SizedBox(height: 10),
            Text('Your Lab (re)Search Engine',
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
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Email',
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
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
            ),
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
            child: Text('Sign In',
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

        Container(
            height: 200,
            width: 200,
            child: Image.asset( 'assets/green-logo.png', fit: BoxFit.cover)
        )




      ]))

      ));






    }
  }


