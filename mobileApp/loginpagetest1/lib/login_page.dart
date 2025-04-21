import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'authentication_db.dart';
import 'faq_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'external_database.dart';
import 'package:bcrypt/bcrypt.dart';

// all packages and other pages referenced for this page ^



// this declares the userEmail as a global variable
// This means that it is able to be used elsewhere in the program
// This is important because the email needs to be tracked to know which user is logged in
// This makes it so we can record which users checkout which items
String? userEmail;


// This creates the AddComponentPage as a stateful widget
// this means that it is able to be changed based on interaction or other events
class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // super.key identifies the key of the specific widget
  @override
  State<LoginPage> createState() => _LoginPageState();
}


// The line below creates a class for the AddComponentPage
// The underscore makes it private to the dart file (though this is unnecessary)
// manages the State of the page and can rebuild the UI when needed
class _LoginPageState extends State<LoginPage> {


  // controllers for tracking email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ExternalDatabase dbStuff = ExternalDatabase(); // makes it easy to use database functions

  void _login() async {
    // sets the controllers to the text entered
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    userEmail = _emailController.text.trim();

    // determines if the user exists and logs them in if they do
    bool isLoggedIn = await dbStuff.loginUser(email, password);
    if (isLoggedIn) {
      // Navigate to Home Page or another screen
      Navigator // sends them to the home page if logged in
          .push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
      );
    } else {  // displays invalid email or password if user does not exist
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
      );
    }
  }


  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
      body: DecoratedBox(
          decoration: BoxDecoration( // backround image of zach
            image: DecorationImage(
                image: AssetImage("assets/IMG_5020.heic"), fit: BoxFit.cover),
          ),
        child: Center(
      child: Column(children: [

        const SizedBox(height: 35),
        GlowText('Welcome To LabRat',  // glow text
        style: GoogleFonts.orbitron(
          fontSize: 30,
          color: Colors.white,
        ),
        ),
        const SizedBox(height: 10),
            GlowText('Your Lab (re)Search Engine', // glow text
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                ),),

        const SizedBox(height: 20),

        Padding( // text box for the users email
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
         child: Container(
           decoration: BoxDecoration(
             color: Colors.grey[100],
           ),
         child: TextField(
           controller: _emailController, // uses email controller
           decoration: InputDecoration(
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(2.0),
             ),

            hintText: 'Email',
          ),
        ),
        ),
        ),

        const SizedBox(height: 20),

        Padding( // text box for the users password
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: TextField(
              controller: _passwordController, // uses password controller
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                hintText: 'Password',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),



        TextButton( // text button to log in the user with credentials entered
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(

              child: Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,

                  )),
            ),),
          onPressed: _login,  // calls the login function
        ),

        Center(child: TextButton( // button to register new user if they do not have a login
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Not Registered? Sign Up Here',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),),
          onPressed: () {
            Navigator // when pressed this sends the user to the register page
                .push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage())
            );
          },
        )),

        const SizedBox(height: 50),

        GlowContainer(  // labrat image
            height: 200,
            width: 200,
         //   color: Colors.green,
            child: Image.asset( 'assets/green-logo.png', fit: BoxFit.cover)
        ),

        const SizedBox(height: 110),


        /* TextButton(
          child: Container(  // button to send the user to the FAQ page
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
        ), */






      ]))

      ));






    }
  }


