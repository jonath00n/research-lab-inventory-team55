import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'authentication_db.dart';
import 'faq_page.dart';
import 'package:flutter_glow/flutter_glow.dart';
// all packages and other pages referenced for this page ^




String? userEmail;



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationDB dbStuff = AuthenticationDB();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    userEmail = _emailController.text.trim();

    bool isLoggedIn = await dbStuff.loginUser(email, password);
    if (isLoggedIn) {
      // Navigate to Home Page or another screen
      Navigator
          .push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
      body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/IMG_5020.heic"), fit: BoxFit.cover),
          ),
        child: Center(
      child: Column(children: [

        const SizedBox(height: 35),
        GlowText('Welcome To LabRat',
        style: GoogleFonts.orbitron(
          fontSize: 30,
          color: Colors.white,
        ),
        ),
        const SizedBox(height: 10),
            GlowText('Your Lab (re)Search Engine',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                ),),
        const SizedBox(height: 20),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
         child: Container(
           decoration: BoxDecoration(
             color: Colors.grey[100],
           ),
         child: TextField(
           controller: _emailController,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: TextField(
              controller: _passwordController,
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



        TextButton(
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
          onPressed: _login,
        ),

        Center(child: TextButton(
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
            Navigator
                .push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage())
            );
          },
        )),

        const SizedBox(height: 50),

        GlowContainer(
            height: 200,
            width: 200,
         //   color: Colors.green,
            child: Image.asset( 'assets/green-logo.png', fit: BoxFit.cover)
        ),

        const SizedBox(height: 110),


        TextButton(
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
        ),






      ]))

      ));






    }
  }


