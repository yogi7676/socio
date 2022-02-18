import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/ui/NavScreens/HomePage.dart';
import 'package:socio/ui/Register.dart';
import 'package:socio/Widgets/Design.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var emailController=new TextEditingController();
  var passController=new TextEditingController();
  var emailNode=new FocusNode();
  var passNode=new FocusNode();
  bool obscureText=true;
  bool emailError=false;
  String emailErrorText='';
  bool errorPass=false;
  String errorPassText="";
  bool showProgress=false;

  var scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  void initState() {
    emailController.clear();
    passController.clear();
    super.initState();
  }

  toggle(){
    setState(() {
      obscureText=!obscureText;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Login",style: TextStyle(color: Colors.grey),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0)
          ),
          gradient: new LinearGradient(
              colors: [Colors.black38,Colors.blueGrey]
          )
        ),
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomDesign(),)
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    Text(
                      "Welcome to",
                      style: TextStyle(color: Colors.white,fontSize: 20.0),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                        'NAVARASA',
                        style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 30.0,),
                    Text(
                        "Platform of emotions",
                        style: TextStyle(color: Colors.white,fontSize: 16.0)
                    ),
                    SizedBox(height: 30.0,),
                    Text("Please enter your email and password to login.",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      focusNode: emailNode,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          errorText: emailError ? emailErrorText : null,
                          errorStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          ),
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: 'Email address',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.mail,color: Colors.white,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          )
                      ),
                      controller: emailController,
                      onFieldSubmitted: (val){
                        var emailNotValid=validateEmail(val);
                        if(emailController.text.length == 0){
                          setState(() {
                            emailError=true;
                            emailErrorText='enter an email address';
                            emailNode.requestFocus();
                          });
                        }else{
                          if(emailNotValid){
                            emailNode.requestFocus();
                            emailController.clear();
                            setState(() {
                              emailError=true;
                              emailErrorText='please enter an valid email address';
                            });
                          }else{
                            emailNode.unfocus();
                            passNode.requestFocus();
                            setState(() {
                              emailError=false;
                              emailErrorText='';
                            });
                          }
                        }
                      }
                    ),
                    SizedBox(height: 10.0,),
                    TextFormField(
                      obscureText: obscureText,
                      focusNode: passNode,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          errorText: errorPass ? errorPassText : null,
                          errorStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.all(6.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                              color: Colors.white,
                              icon: obscureText ? Icon(Icons.visibility_off) :Icon(Icons.visibility),
                              onPressed: ()=>toggle()
                          ),
                          prefixIcon: Icon(Icons.lock,color: Colors.white,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0
                            ),
                          )
                      ),
                      onFieldSubmitted: (val){
                        if(passController.text.length==0){
                          setState(() {
                            errorPass=true;
                            errorPassText='please enter password';
                          });
                        }else{
                          setState(() {
                            errorPass=false;
                            errorPassText='';
                          });
                        }
                      },
                      controller: passController,
                    ),
                    SizedBox(height: 10.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: FlatButton(
                          onPressed: ()=>showProgress ? null : validateUsernameAndPassword(emailController.text, passController.text),
                          splashColor: Colors.white60,
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: showProgress
                              ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation<Color>(Colors.green),))
                              : Text("Login",style: TextStyle(color: Colors.white),),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(width: 1.0, color: Colors.white)
                          ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: ()=>navigateUserToRegistration(),
                          child: Text("Create Account",style: TextStyle(color: Colors.white),),),
                        Text("|",style: TextStyle(color: Colors.white)),
                        FlatButton(
                          onPressed: (){},
                          child: Text("Forgot Password ?",style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      "or",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: FlatButton(
                          splashColor: Colors.white60,
                          onPressed: ()=>openContainerForPhoneAuthentication(),
                          child: Text("Phone",style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.0,color: Colors.white),
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  bool validateEmail(String email){
    Pattern pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1-3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\0-9]+\.)+[a-zA-z]{2,}))$';
    RegExp regex=new RegExp(pattern);
    if(!regex.hasMatch(email)) {
      return true;
    }
    return false;
  }

  openContainerForPhoneAuthentication(){
    showModalBottomSheet(context: context, builder: (context)=>new Container());
  }

  navigateUserToRegistration(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Register()));
  }

  showSnackbar(String content){
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content: Text("${content}"),
        )
    );
  }

  validateUsernameAndPassword(String email,String password){
    if(email.isEmpty && password.isEmpty){
      Timer(Duration(microseconds: 1),()=>showSnackbar('Please enter email and password'));
      emailNode.requestFocus();
    }else if(email.isEmpty){
      setState(() {
        emailError=true;
        emailErrorText='enter an email address';
      });
      emailNode.requestFocus();
    }else if(password.isEmpty){
      setState(() {
        errorPass=true;
        errorPassText='please enter password';
      });
      passNode.requestFocus();
    }else{
      setState(() {
        emailError=false;
        errorPass=false;
      });
      var regex=validateEmail(email);
      if(regex){
        setState(() {
          emailError=true;
          emailErrorText='Please enter a valid email address';
        });
        emailNode.requestFocus();
      }else{
        setState(() {
          showProgress=true;
        });
        LoginUserWithEmailAndPassword(email,password);
      }
    }
  }

  void LoginUserWithEmailAndPassword(email,password) async{
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
        .then((onValue){
        print("success");
        emailController.clear();
        passController.clear();
        setState(() {
          showProgress=false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }).catchError((onError){
      emailController.clear();
      passController.clear();
      showSnackbar(
          'There is no user corresponding to these credentials or The user may have been deleted.',
          );
      setState(() {
        showProgress=false;
      });
    });
  }
}
