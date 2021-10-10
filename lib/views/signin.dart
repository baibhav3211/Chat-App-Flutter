import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatrooms.dart';
import 'package:chat_app_tutorial/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {


  final Function toggleView;

  SignIn(this.toggleView);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthService authService = new AuthService();
  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserByEmail(emailEditingController.text);


          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
       body: SingleChildScrollView(
         child: Container(
           height: MediaQuery.of(context).size.height,
           alignment: Alignment.bottomCenter,
           child: Container(
             padding: EdgeInsets.symmetric(horizontal: 24),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Form(
                   key: formKey,
                   child: Column(
                     children: [
                       TextFormField(
                         validator: (val){
                           return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                           null : "Enter correct email";
                         },
                         controller: emailEditingController,
                         style: simpleTextStyle(),
                         decoration: textFieldInputDecoration("email"),
                       ),
                       TextFormField(
                         obscureText: true,
                         validator:  (val){
                           return val.length < 6 ? "Enter Password 6+ characters" : null;
                         },
                         controller: passwordEditingController,
                         style: simpleTextStyle(),
                         decoration: textFieldInputDecoration("password"),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(height: 8,),
                 Container(
                   alignment: Alignment.centerRight,
                   child: Container(
                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Text("Forgot Password?", style: simpleTextStyle(),),
                   ),
                 ),
                 SizedBox(height: 8,),
                 GestureDetector(
                   onTap: (){
                      signIn();
                   },
                   child: Container(
                     alignment: Alignment.center,
                     width: MediaQuery.of(context).size.width,
                     padding: EdgeInsets.symmetric(vertical: 20),
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         colors: [
                           const Color(0xff007EF4),
                           const Color(0xff2A75BC)
                         ],
                       ),
                       borderRadius: BorderRadius.circular(30)
                     ),
                     child: Text("Sign in", style: biggerTextStyle()),
                   ),
                 ),
                 SizedBox(height: 16,),
                 Container(
                   alignment: Alignment.center,
                   width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.symmetric(vertical: 20),
                   decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(30)
                   ),
                   child: Text("Sign in with Google", style: TextStyle(
                       color: Colors.black87,
                       fontSize: 17
                   ),),
                 ),
                 SizedBox(height: 16,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text("Don't have account? ", style: biggerTextStyle(),),
                     GestureDetector(
                       onTap: (){
                         widget.toggleView();
                       },
                       child: Container(
                         padding: EdgeInsets.symmetric(vertical: 8),
                         child: Text("Register now", style: TextStyle(
                           color: Colors.white,
                           fontSize: 17,
                           decoration: TextDecoration.underline
                         )),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 150,),

               ],
             ),
           ),
         ),
       ),
    );
  }
}
