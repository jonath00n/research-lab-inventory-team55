import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'authentication_db.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'external_database.dart';
import 'package:bcrypt/bcrypt.dart';
// all packages and other pages referenced for this page ^



// This page is where a new user can register
// they enter their email and chose a password which will be entered in the users table of the database

// This creates the RegisterPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key}); // super.key identifies the key of the specific widget
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// The line below creates a class for the RegisterPage
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _RegisterPageState extends State<RegisterPage> {

  // database stuff
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ExternalDatabase dbStuff = ExternalDatabase();

  void _register() async {  // puts email and password entered into controllers
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String password2 = _password2Controller.text.trim();
    String name = _nameController.text.trim();


    if (await dbStuff.isUserExists(email)) { // if email already exists in table show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email already exists.')),
      );
    }
    else if (!EmailValidator.validate(email)) { // checks to see if the email is a valid email
      ScaffoldMessenger.of(context).showSnackBar( // displays an error if it is not valid
        const SnackBar(content: Text('Use a Valid Email Address.')),
      );
    }
    else if (password != password2) { // checks to see if the passwords are same
      ScaffoldMessenger.of(context).showSnackBar( // displays an error if passwords are different
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
    else {
      String encryptedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      int result = await dbStuff.registerUser(email, encryptedPassword, name); // registers user by calling function in database file
      if (result != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully!')),
        );
        Navigator.pop(context);
      } else { // displays error if the user was not able to be registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed.')),
        );
      }
    }
  }

  // function that deletes the database
  void _deleteDatabase() async {
    await AuthenticationDB().deleteDatabaseFile();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database deleted!')),
    );
  }
  // database stuff end

  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
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
                  Padding( // box for users to enter their email
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField( // uses the name controller to track
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),                           hintText: 'Name',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding( // box for users to enter their email
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField( // uses the email controller to track
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
                  Padding( // text box for users to enter their password
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _passwordController, // uses password controller to track
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

                  Padding( // text box for users to enter their password
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: _password2Controller, // uses password controller to track
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),                           hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),



                  TextButton( // button that registeres the user based on credentials provided
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
                    onPressed: _register, // calls register function
                  ),

                  Center(child: TextButton( // sends the user back to the login screen
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


                  Container( // image
                      height: 175,
                      width: 175,
                      child: Image.asset( 'assets/green-logo.png', fit: BoxFit.cover)
                  ),

                  const SizedBox(height: 100),

                  // button for deleting the database
                  // not meant to be in the final app
                  /*
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
                  ), */






                ]))

        ));


  }
}


