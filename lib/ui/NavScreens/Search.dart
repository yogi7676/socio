import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socio/models/UserModel.dart';
import 'package:socio/resources/Repository.dart';
import 'package:socio/ui/NavScreens/UserDetailScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 40.0,
            child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchDelegate()));
                },
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Icon(CupertinoIcons.search),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text('Search')
                  ],
                )),
          ),
        ],
      ),
    );*/
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchDelegate())),
        child: Icon(Icons.search,),
      ),
    );
  }
}

class SearchDelegate extends StatefulWidget {
  @override
  _SearchDelegateState createState() => _SearchDelegateState();
}

class _SearchDelegateState extends State<SearchDelegate>
    with SingleTickerProviderStateMixin {
  String search = 'People';
  var searchControl = new TextEditingController();
  var _repository = new Repository();
  String userId;
  bool showList = false;

  @override
  void initState() {
    super.initState();
    searchControl.addListener(_searchListener);
    _repository.getCurrentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  _searchListener() {
    if (searchControl.text.length != 0) {
      setState(() {
        showList = true;
      });
    } else {
      showList = false;
    }
  }

  @override
  void dispose() {
    searchControl.dispose();
    //setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          autofocus: true,
          cursorColor: Colors.white,
          controller: searchControl,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            child: selectionWidget(),
          ),
        ),
      ),
      body: bodyWidget(),
    );
  }

  selectionWidget() {
    return Expanded(
        child: ListView(
      padding: EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        FlatButton(
          shape:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          color: search == 'People' ? Colors.white : Colors.transparent,
          child: Text(
            'People',
            style: TextStyle(
                color: search == 'People' ? Colors.black : Colors.white),
          ),
          onPressed: () {
            setState(() {
              search = 'People';
            });
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        FlatButton(
          shape:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          color: search == 'Pages' ? Colors.white : Colors.transparent,
          child: Text(
            'Pages',
            style: TextStyle(
                color: search == 'Pages' ? Colors.black : Colors.white),
          ),
          onPressed: () {
            setState(() {
              search = 'Pages';
            });
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        FlatButton(
          shape:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          color: search == 'Groups' ? Colors.white : Colors.transparent,
          child: Text(
            'Groups',
            style: TextStyle(
                color: search == 'Groups' ? Colors.black : Colors.white),
          ),
          onPressed: () {
            setState(() {
              search = 'Groups';
            });
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        FlatButton(
          shape:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          color: search == 'Channel' ? Colors.white : Colors.transparent,
          child: Text(
            'Channel',
            style: TextStyle(
                color: search == 'Channel' ? Colors.black : Colors.white),
          ),
          onPressed: () {
            setState(() {
              search = 'Channel';
            });
          },
        ),
      ],
    ));
  }

  usersBuilder(){
    return FutureBuilder(
        future: Firestore.instance.collection("Users").getDocuments(),
        builder: (context, snapShot) {
          if(snapShot.connectionState==ConnectionState.waiting){
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
                    width: 25,
                    height: 25,),
                  SizedBox(width: 16.0,),
                  Flexible(child: Text('Searching ${searchControl.text}'),)
                ],
              ),
            );
          }else if(snapShot.hasData){
            QuerySnapshot ref=snapShot.data;
            List list=[];
            var searchList=[];
            searchList.clear();
            for(var i=0;i<=ref.documents.length-1;i++){
              if(ref.documents[i].documentID!=userId){
                list.add(ref.documents[i].data);
              }
            }

            if(searchControl.text.length !=0){
              for(var i=0;i<=list.length-1;i++){
                if(User.fromMap(list.elementAt(i)).lowerCaseName.toLowerCase().contains(searchControl.text.toLowerCase())){
                  searchList.add(list.elementAt(i));
                }
              }
            }else{
              searchList.clear();
            }

            return ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context,index){
                String name=User.fromMap(searchList.elementAt(index)).name;
                String image=User.fromMap(searchList.elementAt(index)).imgUrl;
                String userId=User.fromMap(searchList.elementAt(index)).userId;
                return ListTile(
                  title: Text(name),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: image == null
                            ? Image(image: AssetImage('images/noImage.png'),fit: BoxFit.cover,)
                            : CachedNetworkImage(
                          imageUrl: image,fit: BoxFit.cover,
                          progressIndicatorBuilder: (context,image,progress){
                            CircularProgressIndicator(value: progress.progress,);
                          },
                        ),
                      )
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=>UserDetailScreen(receiverId: userId,)));
                  },
                );
              },
            );
          }else if(!snapShot.hasData){
            return Center(child: Text('No Users found'));
          }
        }
    );
  }

  bodyWidget() {
    return searchControl.text.length !=0
        ? usersBuilder()
        : Container();
  }
}
