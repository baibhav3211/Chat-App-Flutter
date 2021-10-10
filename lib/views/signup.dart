import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatrooms.dart';
import 'package:chat_app_tutorial/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  bool isLoading = false;

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  signUp(){
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((val) {
        // print("${val.uid}");

        Map<String,String> userDataMap = {
          "userName" : usernameEditingController.text,
          "userEmail" : emailEditingController.text
        };


        databaseMethods.addUserInfo(userDataMap);

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 30,
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
                          style: simpleTextStyle(),
                          controller: usernameEditingController,
                          validator: (val){
                            return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                          },
                          decoration: textFieldInputDecoration("username"),
                        ),
                        TextFormField(
                          style: simpleTextStyle(),
                          controller: emailEditingController,
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Enter correct email";
                          },
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          controller: passwordEditingController,
                          validator:  (val){
                            return val.length < 6 ? "Enter Password 6+ characters" : null;
                          },
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
                      signUp();
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
                      child: Text("Sign up", style: biggerTextStyle()),
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
                    child: Text("Sign up with Google", style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17
                    ),),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account? ", style: biggerTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Signin now", style: TextStyle(
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
        )
    );
  }
}