import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:socio/ui/NavScreens/Chats.dart';
import 'package:socio/ui/NavScreens/Feeds.dart';
import 'package:socio/ui/NavScreens/Notifications.dart';
import 'package:socio/ui/NavScreens/Profile.dart';
import 'package:socio/ui/NavScreens/Search.dart';

/*
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('HomePage : ${returningScreen.toList()}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Socio'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CollapsingNavigationDrawer()
        ],
      ),
    );
  }
}*/

/*class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  List<Widget> screens = [
    Feeds(),
    Pages(),
    Container(),
    Search(),
    Notifications(),
    Account()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        bottom: TabBar(
          controller: tabController,
          tabs: <Widget>[
            tabs(Icons.home),
            tabs(Icons.group),
            tabs(Icons.live_tv),
            tabs(Icons.search),
            tabs(Icons.notifications),
            tabs(Icons.account_circle),
          ],
        ),
      ),
      body: TabBarView(controller: tabController, children: screens),
    );
  }

  tabs(icon) {
    return Tab(
      icon: Icon(icon),
    );
  }
}*/

/*class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
List<Widget> screens=[
  Feeds(),
  Search(),
  AllVideos(),
  Notifications(),
  Account()
];

class _HomePageState extends State<HomePage> {
  int index=0;
  PageController pageController;
  int pageIndex=0;

  @override
  void initState() {
    pageController=PageController(initialPage: pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
          body: screens[index],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            currentIndex: index,
            onTap: (val){
              setState(() {
                index=val;
              });
            },
            items: [
              bottomNav(FontAwesomeIcons.home, ''),
              bottomNav(FontAwesomeIcons.search, ''),
              bottomNav(Icons.live_tv, ''),
              bottomNav(FontAwesomeIcons.bell, ''),
              bottomNav(Icons.account_circle, ''),
            ],
          ),
        ),
        Message()
      ],
    );
  }

  bottomNav(icon,title){
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }
}*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  
  TabController _tabController;

  @override
  void initState() {
    _tabController=new TabController(length: 5, vsync: this);
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Widget> screens=[
    Feeds(),
    Chats(),
    Search(),
    Notifications(),
    Account()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socio'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home),),
            Tab(icon: Icon(Icons.chat_bubble_outline),),
            Tab(icon: Icon(Icons.search),),
            Tab(icon: Icon(Icons.notifications),),
            Tab(icon: Icon(Icons.account_circle),),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: screens
      ),
    );
  }
}


