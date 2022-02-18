import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socio/models/UserModel.dart';
import 'package:socio/resources/Repository.dart';
import 'package:socio/ui/NavScreens/HomePage.dart';
import 'package:socio/ui/Login.dart';
import 'package:socio/Widgets/Design.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var scaffoldKey=GlobalKey<ScaffoldState>();
  bool showProgress=false;
  File imageFile;
  var emailController = new TextEditingController();
  var passController = new TextEditingController();
  var rePassController=new TextEditingController();
  var accountController=new TextEditingController();
  var accountNode=new FocusNode();
  var accountError=false;
  String accountErrorText='';
  var rePassNode=new FocusNode();
  var emailNode = new FocusNode();
  var passNode = new FocusNode();
  bool obscureText = true;
  bool repassObscureText=true;
  bool rePassError=false;
  String rePassErrorText='';
  bool emailError = false;
  String emailErrorText = '';
  bool errorPass = false;
  String errorPassText = "";
  Repository repository=new Repository();

  @override
  void initState() {
    emailController.clear();
    accountController.clear();
    passController.clear();
    rePassController.clear();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    accountController.dispose();
    rePassController.dispose();
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
          title: Text("Create Account", style: TextStyle(color: Colors.grey),),
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
                  colors: [Colors.black38, Colors.blueGrey]
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
                        "Please enter your Email, AccountName, Password and an optional Profile Picture.",
                        style: TextStyle(color: Colors.white,fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.0,),
                      GestureDetector(
                        onTap: () => showImagePickerDialog(),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            CircleAvatar(
                                radius: 70.0,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: SizedBox(
                                      height: 200.0,
                                      width: 200.0,
                                      child: imageFile == null
                                          ? Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 100.0,
                                      )
                                          : Image.file(imageFile,fit: BoxFit.fill,)),
                                )),
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 14.0,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
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
                              prefixIcon: Icon(
                                Icons.mail, color: Colors.white,),
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
                          cursorColor: Colors.white,
                          onFieldSubmitted: (val) {
                            var emailNotValid = validateEmail(val);
                            if (emailController.text.length == 0) {
                              setState(() {
                                emailError = true;
                                emailErrorText = 'enter an email address';
                                emailNode.requestFocus();
                              });
                            } else {
                              if (emailNotValid) {
                                emailNode.requestFocus();
                                emailController.clear();
                                setState(() {
                                  emailError = true;
                                  emailErrorText =
                                  'please enter an valid email address';
                                });
                              } else {
                                emailNode.unfocus();
                                accountNode.requestFocus();
                                setState(() {
                                  emailError = false;
                                  emailErrorText = '';
                                });
                              }
                            }
                          }
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          focusNode: accountNode,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white12,
                              errorText: accountError ? accountErrorText : null,
                              errorStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                ),
                              ),
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.person, color: Colors.white,),
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
                          controller: accountController,
                          cursorColor: Colors.white,
                          onFieldSubmitted: (val) {
                            if (accountController.text.length == 0) {
                              setState(() {
                                accountError = true;
                                accountErrorText = 'enter your name';
                                accountNode.requestFocus();
                              });
                            } else {
                              setState(() {
                                accountError = false;
                                accountErrorText = '';
                                passNode.requestFocus();
                              });
                            }
                          }
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        obscureText: obscureText,
                        focusNode: passNode,
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
                                icon: obscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () => passToggle()
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.white,),
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
                        onFieldSubmitted: (val) {
                          if (passController.text.length == 0) {
                            setState(() {
                              errorPass = true;
                              errorPassText = 'please enter password';
                            });
                          } else if(passController.text.length < 8){
                            setState(() {
                              errorPass = true;
                              errorPassText = 'Password must be of 8 characters ';
                            });
                          }else {
                            passNode.unfocus();
                            rePassNode.requestFocus();
                            setState(() {
                              errorPass = false;
                              errorPassText = '';
                            });
                          }
                        },
                        controller: passController,
                        cursorColor: Colors.white,
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        obscureText: repassObscureText,
                        focusNode: rePassNode,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white12,
                            errorText: rePassError ? rePassErrorText : null,
                            errorStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.all(6.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              ),
                            ),
                            hintText: 'Re-enter password',
                            hintStyle: TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                                color: Colors.white,
                                icon: repassObscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () => repassToggle()
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.white,),
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
                        onFieldSubmitted: (val) {
                          if (rePassController.text.length == 0) {
                            setState(() {
                              rePassError=true;
                              rePassErrorText = 'please re-enter password';
                            });
                          } else if(rePassController.text!=passController.text){
                            setState(() {
                              rePassError=true;
                              rePassErrorText='passwords do not match';
                              rePassNode.requestFocus();
                            });
                          }else{
                            setState(() {
                              rePassError=false;
                              rePassErrorText='';
                            });
                          }
                        },
                        controller: rePassController,
                      ),
                      SizedBox(height: 10.0,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: FlatButton(
                          onPressed: ()=>showProgress ? null : validateInput(
                              emailController.text,
                              accountController.text,
                              passController.text,
                              rePassController.text),
                          splashColor: Colors.white60,
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: showProgress
                              ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation<Color>(Colors.green),))
                              : Text("Register",style: TextStyle(color: Colors.white),),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(width: 1.0, color: Colors.white)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      FlatButton(
                          onPressed: ()=>navigateToLogin(),
                          child: Text("Already a user ? Login",style: TextStyle(color: Colors.white),)
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  pickImageFromCamera()async{
    Navigator.pop(context);
    final f=await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile=f;
    });
  }

  pickImageFromGallery()async{
    Navigator.pop(context);
    final f=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile=f;
    });
  }

  showImagePickerDialog(){
    return showModalBottomSheet(
        context: context,
        builder: (context)
        => Container(
          height: imageFile!=null ? 200.0 : 150.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Select source'),
                ),
              ),
              ListTile(
                title: Text('Take photo'),
                leading: Icon(Icons.camera_alt),
                onTap: ()=>pickImageFromCamera(),
              ),
              ListTile(
                title: Text('Select from library'),
                leading: Icon(Icons.photo_library),
                onTap: ()=>pickImageFromGallery(),
              ),
              imageFile !=null
                  ? ListTile(
                title: Text('Remove photo'),
                leading: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    CircleAvatar(
                      radius: 5.0,
                      child: Icon(CupertinoIcons.clear,size: 10.0,color: Colors.white,),
                      backgroundColor: Colors.grey,)
                  ],
                ),
                onTap: ()=>removePhoto(),
              ): Row(),
            ],
          ),
        )
    );
  }

  removePhoto(){
    Navigator.pop(context);
    setState(() {
      imageFile=null;
    });
  }

  navigateToLogin(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
  }

  bool validateEmail(String email){
    Pattern pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1-3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\0-9]+\.)+[a-zA-z]{2,}))$';
    RegExp regex=new RegExp(pattern);
    if(!regex.hasMatch(email)) {
      return true;
    }
    return false;
  }

  passToggle(){
    setState(() {
      obscureText=!obscureText;
    });
  }

  repassToggle(){
    setState(() {
      repassObscureText=!repassObscureText;
    });
  }

  validateInput(String email,String name,String pass,String repass) async{
    if(email.isEmpty || pass.isEmpty || repass.isEmpty || name.isEmpty){
      scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please enter all the fields above'),
          )
      );
    }else{
      setState(() {
        emailError=false;
        accountError=false;
        errorPass=false;
        rePassError=false;
      });
      var regex=validateEmail(email);
      var emailExists=await repository.emailExists(email);
      var nameExists=await repository.usernameExists(name);
      if(regex) {
        setState(() {
          emailError=true;
          emailErrorText='Please enter a valid email address';
        });
        emailNode.requestFocus();
      }else if(emailExists) {
        setState(() {
          emailError=true;
          emailErrorText='Email already exists';
        });
        emailNode.requestFocus();
      }else if(nameExists){
        setState(() {
          accountError=true;
          accountErrorText='User with $name already exists.';
        });
        accountNode.requestFocus();
      }else if(pass.length < 8){
        setState(() {
          errorPass=true;
          errorPassText='Please enter a 8-digit password';
        });
        passNode.requestFocus();
      }else if(pass !=repass){
        setState(() {
          rePassError=true;
          rePassErrorText='Passwords do not match';
        });
        rePassNode.requestFocus();
      }else{
        print("Registration Success");
        setState(() {
          showProgress=true;
        });
        createUser(email, pass);
      }
    }
  }

  Future createUser(email,password) async{
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
        .then((onValue){
      var userId=onValue.user;
      String id=userId.uid;
      print("Image : $imageFile");
      if(imageFile ==null){
        uploadData(email, imageFile, accountController.text,id);
      }else{
        uploadImage(imageFile,id);
      }
    }).catchError((onError){
      //print("Error : $onError");
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("$onError")));
      setState(() {
        showProgress=false;
      });
    });
  }

  Future uploadData(String email,profileImage,String name,userId) async{
   User user;
   user=User(
     name: name,
     bio: '',
     imgUrl: profileImage,
     lowerCaseName: name.toLowerCase(),
     email: email,
     userId: userId,
     phone: '',
     privacy: 'Public'
   );

    await Firestore.instance.collection("Users")
        .document(userId)
        .setData(user.toMap(user))
        .then((onValue){
      emailController.clear();
      accountController.clear();
      rePassController.clear();
      passController.clear();
      setState(() {
        showProgress=false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      print("success");
    }).catchError((onError){
      setState(() {
        showProgress=false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("$onError")));
    });
  }

  Future uploadImage(image,userId) async {
    String url;
    final StorageReference reference =
    FirebaseStorage.instance.ref().child("images/$userId");
    var timeKey=new DateTime.now();
    final StorageUploadTask task = reference.child(timeKey.toString()+".jpg").putFile(image);
    var imageUrl=await(await task.onComplete).ref.getDownloadURL();
    url=imageUrl.toString();
    uploadData(emailController.text, url,accountController.text,userId);
  }
}
