import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socio/resources/Repository.dart';
import 'package:socio/Widgets/CustomCircleAvatar.dart';
import 'package:socio/Widgets/Header.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  Repository repository=new Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    child: WavyHeaderImage(),
                  ),
                  CustomCircleAvatar(
                    onTap: (){},
                    color: Colors.grey,
                    biggerSize: 60.0,
                    smallIconColor: Colors.white,
                    iconInSmallCircle: Icons.add_a_photo,
                    smallSize: 18.0,
                    image: Icon(Icons.person,color: Colors.white,size: 100.0,),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text("Email"),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Name"),
                onTap: (){},
                trailing: Icon(Icons.edit),
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text("Privacy Settings"),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("Chat Settings"),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Notification Settings"),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Help"),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About Us"),
                onTap: (){},
              ),
              Column(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Logout"),
                      onTap: ()=>Logout()
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Logout(){
    showDialog(
      context: context,
      builder: (context)
        => CupertinoAlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure to exit"),
          actions: <Widget>[
            FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("No")),
            FlatButton(onPressed: (){Navigator.pop(context);
            repository.signOut();}, child: Text("Yes"))
          ],
        )
    );
  }
}
