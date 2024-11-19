import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'authentication_db.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_glow/flutter_glow.dart';
// all packages and other pages referenced for this page ^






class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // database stuff
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationDB dbStuff = AuthenticationDB();

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (await dbStuff.isUserExists(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email already exists.')),
      );
    }
    else if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use a Valid Email Address.')),
      );
    }
    else {
      int result = await dbStuff.registerUser(email, password);
      if (result != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed.')),
        );
      }
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
                  GlowText('Register Here',
                    style: GoogleFonts.orbitron(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('   Enter your email and create a password',
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),                           hintText: 'Email',
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
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),                           hintText: 'Password',
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
                        child: Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),),
                    onPressed: _register,
                  ),

                  Center(child: TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Back To Login',
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


                  const SizedBox(height: 20),


                  Container(
                      height: 200,
                      width: 200,
                      child: Image.asset( 'assets/green-logo.png', fit: BoxFit.cover)
                  ),

                  const SizedBox(height: 135),

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


