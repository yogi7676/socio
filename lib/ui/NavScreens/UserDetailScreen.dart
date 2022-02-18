/*import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/models/UserModel.dart';
import 'package:socio/resources/Repository.dart';

class UserDetailScreen extends StatefulWidget {
  final String receiverId, name;

  const UserDetailScreen({Key key, this.receiverId, this.name})
      : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Firestore fireStore = Firestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DocumentSnapshot receiverInfo;
  String followingState;
  String followersState;
  bool show = false;
  FirebaseUser currentUser;
  var postsCount;
  var followingCount;
  var followersCount;
  var _repository = Repository();

  //String currentUser;

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    currentUser = await firebaseAuth.currentUser();
    await fireStore
        .collection('Users')
        .document(widget.receiverId)
        .get()
        .then((onValue) {
      receiverInfo = onValue;
    });
    //print(receiverInfo.documentID);

    var following = await fireStore
        .collection("Users")
        .document(currentUser.uid)
        .collection("Following")
        .document(widget.receiverId)
        .get();

    if (following.exists) {
      String status = following.data['status'];
      if (status == 'sent') {
        setState(() {
          followingState = 'sent';
        });
      } else if (status == 'friends') {
        setState(() {
          followingState = 'friends';
        });
      }
    } else {
      setState(() {
        followingState = 'new';
      });
    }

    var followers = await fireStore
        .collection("Users")
        .document(currentUser.uid)
        .collection("Followers")
        .document(widget.receiverId)
        .get();

    if (followers.exists) {
      String status = followers.data['status'];
      if (status == 'received') {
        setState(() {
          followersState = 'received';
        });
      } else if (status == 'friends') {
        setState(() {
          followersState = 'friends';
        });
      }
    } else {
      setState(() {
        followersState = 'new';
      });
    }

    print('Following State : $followingState');
    print("Followers State : $followersState");
    setState(() {
      show = true;
    });
  }

  buildButton() {
    if (followingState == 'new' && followersState == 'new') {
      return SizedBox(
        width: 150,
        height: 30,
        child: FlatButton(
          child: Text('Follow',style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: () {
            var follow = {'uid': receiverInfo.documentID, 'status': 'sent'};

            fireStore
                .collection("Users")
                .document(currentUser.uid)
                .collection("Following")
                .document(receiverInfo.documentID)
                .setData(follow)
                .then((onValue) {
              //print("Success inside");
              var followers = {'uid': currentUser.uid, 'status': 'received'};
              fireStore
                  .collection("Users")
                  .document(receiverInfo.documentID)
                  .collection("Followers")
                  .document(currentUser.uid)
                  .setData(followers)
                  .then((onValue) {
                print('follow success');
                setState(() {
                  followingState = 'sent';
                });
              });
            });
          },
        ),
      );
    } else if (followingState == 'sent') {
      return SizedBox(
        width: 150,
        height: 30,
        child: FlatButton(
            onPressed: () => rejectRequest(),
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            child: Text('Cancel')),
      );
    } else if (followersState == 'received') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () => acceptRequest(),
              child: Text('Accept',style: TextStyle(color: Colors.white),),
              color: Colors.blue,
          ),
          SizedBox(
            width: 16.0,
          ),
          FlatButton(
              onPressed: () => rejectRequest(),
              color: Colors.blue,
              child: Text('Reject',style: TextStyle(color: Colors.white),)
          )
        ],
      );
    } else if (followingState == 'friends' && followersState == 'friends') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {},
              shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              child: Text('Unfollow')),
          FlatButton(
            onPressed: (){},
            child: Text('Message'),
            shape: OutlineInputBorder(),
          )
        ],
      );
    } else if (followingState == 'new' && followersState == 'friends') {
      return SizedBox(
        height: 30,
        width: 150,
        child: FlatButton(
            onPressed: () => onFollowBackPressed(),
            color: Colors.blue,
            child: Text(
              'Follow Back',
              style: TextStyle(color: Colors.white),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: show
            ? Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 0.5),
                                    image: DecorationImage(
                                        image: User.fromMap(receiverInfo.data)
                                                    .imgUrl !=
                                                null
                                            ? NetworkImage(
                                                User.fromMap(receiverInfo.data)
                                                    .imgUrl)
                                            : AssetImage('images/noImage.png'),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(height: 10.0,),
                              Text(
                                '${User.fromMap(receiverInfo.data).name}',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),

                      User.fromMap(receiverInfo.data).bio != null
                          ? Text(
                              '${User.fromMap(receiverInfo.data).bio}',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Container(),
                      Center(
                        child: buildButton(),
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator(strokeWidth: 0.5,valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),)));
  }

  acceptRequest() {
    fireStore
        .collection("Users")
        .document(currentUser.uid)
        .collection("Followers")
        .document(receiverInfo.documentID)
        .updateData({'status': 'friends'}).then((onValue) {
      //print('updated');
      fireStore
          .collection("Users")
          .document(receiverInfo.documentID)
          .collection("Following")
          .document(currentUser.uid)
          .updateData({'status': 'friends'}).then((onValue) {
        print('updated');
        setState(() {
          followingState = 'new';
          followersState = 'friends';
        });
      });
    });
  }

  rejectRequest() {
    fireStore
        .collection("Users")
        .document(currentUser.uid)
        .collection("Following")
        .document(receiverInfo.documentID)
        .delete()
        .then((onValue) {
      fireStore
          .collection("Users")
          .document(receiverInfo.documentID)
          .collection("Followers")
          .document(currentUser.uid)
          .delete()
          .then((onValue) {
        print('Follow Request Cancelled');
        setState(() {
          followingState = 'new';
        });
      });
    });
  }

  onFollowBackPressed() {
    var mapA = {'uid': currentUser.uid, 'status': 'sent'};

    var mapB = {'uid': receiverInfo.documentID, 'status': 'received'};

    fireStore
        .collection("Users")
        .document(currentUser.uid)
        .collection("Following")
        .document(receiverInfo.documentID)
        .setData(mapA)
        .then((onValue) {
      fireStore
          .collection("Users")
          .document(receiverInfo.documentID)
          .collection("Followers")
          .document(currentUser.uid)
          .setData(mapB)
          .then((onValue) {
        print('followed back');
        setState(() {
          followingState = 'sent';
        });
      });
    });
  }
}*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:socio/models/UserModel.dart';
import 'package:socio/resources/Repository.dart';

class UserDetailScreen extends StatefulWidget {
  final String receiverId;

  const UserDetailScreen({Key key, this.receiverId}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  String privacy;
  var _repository = Repository();
  bool show = false;
  String followingState;
  String followersState;
  var receiverInfo;
  List<DocumentSnapshot> postCount;
  List<DocumentSnapshot> followingCount;
  List<DocumentSnapshot> followersCount;
  List<String> mutualList = [];
  var usersList = [];
  String currentUid;
  Size deviceSize;
  bool isBestie;

  @override
  void initState() {
    super.initState();
    init();
  }

  format(int number) {
    var formatted;
    if (number < 1000) {
      formatted = number;
    } else {
      formatted = NumberFormat.compactCurrency(decimalDigits: 1, symbol: '')
          .format(number);
    }

    return formatted;
  }

  init() async {
    currentUid = (await _repository.getCurrentUser()).uid;
    print('currentUid : $currentUid');
    //--------------------------------------------------------
    privacy = await _repository.getPrivacy(widget.receiverId);
    print("Account Privacy : $privacy");
    //--------------------------------------------------------
    receiverInfo = await _repository.fetchUserDetailsById(widget.receiverId);
    print(receiverInfo.name);
    //--------------------------------------------------------
    await _repository
        .isFollowing(currentUid, widget.receiverId)
        .then((following) {
      if (following.exists) {
        String status = following.data['status'];
        switch (status) {
          case 'sent':
            setState(() {
              followingState = 'sent';
            });
            break;
          case 'friends':
            setState(() {
              followingState = 'friends';
            });
            break;
        }
      } else {
        setState(() {
          followingState = 'new';
        });
      }
    });
    //--------------------------------------------------------
    await _repository
        .isFollower(currentUid, widget.receiverId)
        .then((followers) {
      if (followers.exists) {
        String status = followers.data['status'];
        switch (status) {
          case 'received':
            setState(() {
              followersState = 'received';
            });
            break;
          case 'friends':
            setState(() {
              followersState = 'friends';
            });
            break;
        }
      } else {
        setState(() {
          followersState = 'new';
        });
      }
    });
    //--------------------------------------------------------
    mutualList = await _repository.getMutuals(currentUid, widget.receiverId);
    usersList.clear();
    if (mutualList.length != 0) {
      for (var i = 0; i < mutualList.length; i++) {
        DocumentSnapshot snapshot = await Firestore.instance
            .collection("Users")
            .document(mutualList.elementAt(i))
            .get();
        usersList.add(snapshot.data);
      }
    }
    //--------------------------------------------------------
    postCount = await _repository.fetchPosts(widget.receiverId);
    //--------------------------------------------------------
    followingCount = await _repository.fetchFollowingLength(widget.receiverId);
    //--------------------------------------------------------
    followersCount = await _repository.fetchFollowersLength(widget.receiverId);
    //--------------------------------------------------------
    isBestie =await _repository.isBestie(currentUid, widget.receiverId);
    //--------------------------------------------------------
    print('Following State : $followingState');
    //--------------------------------------------------------
    print('Followers State : $followersState');
    //--------------------------------------------------------
    setState(() {
      show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return show
        ? customView()
        : Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                strokeWidth: 0.7),
          );
  }

  customView() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              buildImage(),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receiverInfo.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Row(
                    children: <Widget>[
                      detailsWidget("${format(postCount.length)}", "Posts", () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container();
                            });
                      }),
                      detailsWidget("${format(followingCount.length)}",
                          "Following", () {}),
                      detailsWidget("${format(followersCount.length)}",
                          "Followers", () {})
                    ],
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              child: receiverInfo.bio != '' ? Text(receiverInfo.bio) : null,
              alignment: Alignment.centerLeft,
            ),
          ),
          mutualsWidget(),
          buildButton()
        ],
      ),
    );
  }

  buildButton() {
    if (followingState == 'new' && followersState == 'new') {
      // current user is not following receiver nor receiver is following current user
      //then show follow button
      return customButton(
          deviceSize.width,
          Text(
            'Follow',
            style: TextStyle(color: Colors.white),
          ), () {
        _repository.followUser(currentUid, widget.receiverId);
        setState(() {
          followingState = 'sent';
          followersState = 'new';
        });
      }, Colors.blue, Colors.transparent);
    } else if (followingState == 'new' && followersState == 'received') {
      //current user is not following him but receiver has sent request for following
      // show accept and decline buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Accept Button
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ), () {
            _repository.acceptFollowRequest(currentUid, widget.receiverId);
            setState(() {
              followingState = 'new';
              followersState = 'friends';
            });
          }, Colors.blue, Colors.transparent),
          //Reject Button
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Reject',
                style: TextStyle(color: Colors.white),
              ), () {
            _repository.rejectFollowRequest(currentUid, widget.receiverId);
            setState(() {
              followingState = 'new';
              followersState = 'new';
            });
          }, Colors.blue, Colors.transparent),
        ],
      );
    } else if (followingState == 'new' && followersState == 'friends') {
      // current user is not following him but receiver is following current user
      //show follow Back button, message Button and options Button
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Follow Back Button
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Follow Back',
                style: TextStyle(color: Colors.white),
              ), () {
            _repository.followUser(currentUid, widget.receiverId);
            setState(() {
              followingState = 'sent';
              followersState = 'friends';
            });
          }, Colors.blue, Colors.transparent),
          //Message Button
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Message',
              ),
              () {},
              Colors.transparent,
              Colors.grey),
        ],
      );
    } else if (followingState == 'sent' && followersState == 'new') {
      //current user has sent request for following and receiver user is not following current user
      //show Cancel Button
      return customButton(
          deviceSize.width,
          Text(
            'Cancel',
          ), () {
        _repository.rejectFollowRequest(currentUid, widget.receiverId);
        setState(() {
          followingState = 'new';
          followersState = 'new';
        });
      }, Colors.transparent, Colors.grey);
    } else if (followingState == 'sent' && followersState == 'friends') {
      //if current user has sent request to receiver and receiver is already following me
      //show cancel button,message button
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Cancel',
              ), () {
                _repository.rejectFollowRequest(currentUid, widget.receiverId);
            setState(() {
              followingState = 'new';
              followersState = 'friends';
            });
          }, Colors.transparent, Colors.grey),
          customButton(
              deviceSize.width * 0.4,
              Text(
                'Message',
              ),
              () {},
              Colors.transparent,
              Colors.grey),
        ],
      );
    } else if (followingState == 'friends' && followersState == 'new') {
      //current user is following him but receiver is not following current user
      //show unfollow,message button
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          customButton(
              deviceSize.width * 0.4,
              Text('Unfollow',), () {
                _repository.unfollowUser(currentUid, widget.receiverId);
            setState(() {
              followingState = 'new';
              followersState = 'new';
            });
          }, Colors.transparent, Colors.grey),
          customButton(
              deviceSize.width * 0.4,
              Text('Message',), () {
          }, Colors.transparent, Colors.grey),
          InkWell(
            onTap: (){},
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width:1.0),
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Icon(Icons.keyboard_arrow_down),
            ),
          )
        ],
      );
    }else if (followingState == 'friends' && followersState == 'received') {
      // current user is following receiver and receiver has followed back and sent request
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Accept Button
          customButton(
              deviceSize.width * 0.25,
              Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ), () {
                _repository.acceptFollowRequest(currentUid, widget.receiverId);
            setState(() {
              followingState = 'friends';
              followersState = 'friends';
            });
          }, Colors.blue, Colors.transparent),
          //Reject Button
          customButton(
              deviceSize.width * 0.25,
              Text(
                'Reject',
                style: TextStyle(color: Colors.white),
              ), () {
                _repository.rejectFollowRequest(currentUid, widget.receiverId);
                setState(() {
                  followingState = 'friends';
                  followersState = 'new';
                });
          }, Colors.blue, Colors.transparent),
          customButton(
              deviceSize.width * 0.25,
              Text('Message',), () {
          }, Colors.transparent, Colors.grey),
          InkWell(
            onTap: (){},
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width:1.0),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Icon(Icons.keyboard_arrow_down),
            ),
          )
        ],
      );
    } else if (followingState == 'friends' && followersState == 'friends') {
      // both are following each other
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          customButton(
              deviceSize.width * 0.4,
              Text('Unfollow',), () {
                _repository.unfollowUser(currentUid, widget.receiverId);
            setState(() {
              followingState = 'new';
              followersState = 'friends';
            });
          }, Colors.transparent, Colors.grey),
          customButton(
              deviceSize.width * 0.4,
              Text('Message',), () {
          }, Colors.transparent, Colors.grey),
          InkWell(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0)
                      )
                  ),
                  builder: (context)
                  =>Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                             border: Border(bottom: BorderSide(width: 0.05))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.grey
                                    ),
                                    width: 50,
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      '${receiverInfo.name}',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0)
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: ()=>bestie(),
                          title: Text('Besties'),
                          trailing: isBestie ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
                        )
                      ],
                    ),
                  )
              );
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width:1.0),
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Icon(Icons.keyboard_arrow_down),
            ),
          )
        ],
      );
    }
  }

  buildBottomSheet(Widget widget){
    return showModalBottomSheet(
      context: context,
      builder: (builder)=>widget
    );
  }

  bestie()async{
    if(isBestie){
      setState(() {
        isBestie = false;
      });
      await _repository.removeBestie(currentUid, widget.receiverId);
    }else{
      setState(() {
        isBestie = true;
      });
      await _repository.makeBestie(currentUid, widget.receiverId);
    }
  }

  buildImage() {
    return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.grey.shade200,
        child: SizedBox(
          width: 100.0,
          child: ClipOval(
            child: receiverInfo.imgUrl != null
                ? CachedNetworkImage(
                    imageUrl: receiverInfo.imgUrl,
                    fit: BoxFit.cover,
                  )
                : Image(
                    image: AssetImage('images/noImage.png'),
                    fit: BoxFit.cover,
                  ),
          ),
        ));
  }

  mutualsWidget() {
    if (usersList.length == 0) {
      return Container();
    } else if (usersList.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: RichText(
                text: TextSpan(children: [
                  new TextSpan(
                      text: 'mutual friends : ',
                      style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${User.fromMap(usersList.elementAt(0)).name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))
                ]),
              ),
            ),
          ],
        ),
      );
    } else if (usersList.length == 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: RichText(
                text: TextSpan(children: [
                  new TextSpan(
                      text: 'mutual friends : ',
                      style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${User.fromMap(usersList.elementAt(0)).name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  new TextSpan(text: ',', style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${User.fromMap(usersList.elementAt(1)).name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))
                ]),
              ),
            ),
          ],
        ),
      );
    } else if (usersList.length > 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: RichText(
                text: TextSpan(children: [
                  new TextSpan(
                      text: 'mutual friends : ',
                      style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${User.fromMap(usersList.elementAt(0)).name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  new TextSpan(text: ',', style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${User.fromMap(usersList.elementAt(1)).name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  new TextSpan(
                      text: ' and ', style: TextStyle(color: Colors.grey)),
                  new TextSpan(
                      text: '${usersList.length} others',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))
                ]),
              ),
            ),
          ],
        ),
      );
    }
  }

  detailsWidget(String count, String label, Function onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Text(count,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(label),
            )
          ],
        ),
      ),
    );
  }

  customButton(double width, Widget content, Function onPressed,
      Color buttonColor, Color bordeSideColor) {
    return SizedBox(
      width: width,
      height: 30,
      child: FlatButton(
        child: content,
        color: buttonColor,
        shape:
            OutlineInputBorder(borderSide: BorderSide(color: bordeSideColor)),
        onPressed: onPressed,
      ),
    );
  }
}
