import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socio/Models/UserModel.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User user;
  //Post post;
  //Like like;
  //Message _message;
  //Comment comment;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    _firestore
        .collection("display_names")
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName});

    user = User(
        userId: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        imgUrl: currentUser.photoUrl,
        );

    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);
    var ref;

    return _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> usernameExists(String name)async{
    //bool exists=false;
    var snap=await _firestore.collection("Users").where('Name',isEqualTo: name).getDocuments();

    List<DocumentSnapshot> list=snap.documents;

    if(list.length==0){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> emailExists(String email)async{
    var snap=await _firestore.collection("Users").where('Email',isEqualTo: email).getDocuments();

    List<DocumentSnapshot> list=snap.documents;

    if(list.length==0){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("Users")
        .where("Email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    //print("EMAIL ID : ${currentUser.email}");
    return currentUser;
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<User> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
    await _firestore.collection("Users").document(user.uid).get();
    return User.fromMap(_documentSnapshot.data);
  }

  Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
    await _firestore.collection("Users").getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot =
      await list[i].reference.collection("Posts").getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print("UPDATED LIST LENGTH : ${updatedList.length}");
    return updatedList;
  }

  Future<List<String>> fetchAllUserNames(FirebaseUser user) async {
    List<String> userNameList = List<String>();
    QuerySnapshot querySnapshot =
    await _firestore.collection("Users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        userNameList.add(querySnapshot.documents[i].data['Name']);
      }
    }
    print("USERNAMES LIST : ${userNameList.length}");
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    String uid;
    List<DocumentSnapshot> uidList = List<DocumentSnapshot>();

    QuerySnapshot querySnapshot =
    await _firestore.collection("Users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      uidList.add(querySnapshot.documents[i]);
    }

    print("UID LIST : ${uidList.length}");

    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i].data['Name'] == name) {
        uid = uidList[i].documentID;
      }
    }
    print("UID DOC ID: ${uid}");
    return uid;
  }

  Future<User> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
    await _firestore.collection("Users").document(uid).get();
    return User.fromMap(documentSnapshot.data);
  }

  Future<void> onFollowPressed(String receiverId,String currentUid) async{
    var follow = {'uid': receiverId, 'status': 'sent'};

    await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Following")
        .document(receiverId)
        .setData(follow);

    var followers = {'uid': currentUid, 'status': 'received'};

    return _firestore
        .collection("Users")
        .document(receiverId)
        .collection("Followers")
        .document(currentUid)
        .setData(followers);
  }

  Future<void> onUnfollowPressed(String currentUid,String receiverId) async{
    var follow = {'uid': receiverId, 'status': 'new'};

    await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Following")
        .document(receiverId)
        .setData(follow);

    var followers = {'uid': currentUid, 'status': 'new'};

    return _firestore
        .collection("Users")
        .document(receiverId)
        .collection("Followers")
        .document(currentUid)
        .setData(followers);
  }

  Future<void> onAcceptPressed(String currentUid,String receiverId) async{
    await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Followers")
        .document(receiverId)
        .updateData({'status': 'friends'});

    return _firestore
        .collection("Users")
        .document(receiverId)
        .collection("Following")
        .document(currentUid)
        .updateData({'status': 'friends'});
  }

  Future<void> onRejectPressed(String currentUid,String receiverId) async{
    await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Following")
        .document(receiverId)
        .delete();

    return _firestore
        .collection("Users")
        .document(receiverId)
        .collection("Followers")
        .document(currentUid)
        .delete();
  }

  /*Future<void> onFollowBackPressed(String currentUid,String receiverId) async{
    var mapA = {'uid': currentUid, 'status': 'sent'};

    var mapB = {'uid': receiverId, 'status': 'received'};

    await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Following")
        .document(receiverId)
        .setData(mapA);

    return _firestore
        .collection("Users")
        .document(receiverId)
        .collection("Followers")
        .document(currentUid)
        .setData(mapB);
  }*/

  Future<void> makeBestie(String currentUid,String receiverUid) async{
    var snap=await _firestore.collection("Users")
        .document(currentUid).collection("Besties")
        .document(receiverUid).setData({'UserId' : receiverUid});
    return snap;
  }

  Future<void> removeBestie(String currentUid,String receiverUid) async{
    var snap = await _firestore.collection("Users")
        .document(currentUid).collection("Besties")
        .document(receiverUid).delete();
    return snap;
  }

  Future<bool> isBestie(String currentUid,String receiverUid) async{
    bool isBestie=false;
    DocumentSnapshot snapshot = await _firestore.collection("Users")
        .document(currentUid)
        .collection("Besties")
        .document(receiverUid)
        .get();

    if(snapshot.exists){
      isBestie=true;
    }

    print("Bestie : $isBestie");
    return isBestie;
  }

  Future<DocumentSnapshot> isFollowing(String currentUid,String receiverId) async{
    DocumentSnapshot isFollowing=await _firestore
        .collection("Users").document(currentUid).collection("Following").document(receiverId).get();
    return isFollowing;
  }

  Future<DocumentSnapshot> isFollower(String currentUid,String receiverId) async{
    DocumentSnapshot isFollower=await _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Followers")
        .document(receiverId)
        .get();

    return isFollower;
  }

  Future<List<DocumentSnapshot>> fetchPosts(String uid) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Users")
        .document(uid)
        .collection('Posts')
        .getDocuments();

    return querySnapshot.documents;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoUrl'] = photoUrl;
    return _firestore.collection("users").document(uid).updateData(map);
  }

  Future<void> updateDetails(
      String uid, String name, String bio, String email, String phone) async {
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Bio'] = bio;
    map['Email'] = email;
    map['Phone'] = phone;
    return _firestore.collection("Users").document(uid).updateData(map);
  }

  Future<List<String>> fetchUserNames(FirebaseUser user) async {
    DocumentReference documentReference =
    _firestore.collection("messages").document(user.uid);
    List<String> userNameList = List<String>();
    List<String> chatUsersList = List<String>();
    QuerySnapshot querySnapshot =
    await _firestore.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        print("USERNAMES : ${querySnapshot.documents[i].documentID}");
        userNameList.add(querySnapshot.documents[i].documentID);
        //querySnapshot.documents[i].reference.collection("collectionPath");
        //userNameList.add(querySnapshot.documents[i].data['displayName']);
      }
    }

    for (var i = 0; i < userNameList.length; i++) {
      if (documentReference.collection(userNameList[i]) != null) {
        if (documentReference.collection(userNameList[i]).getDocuments() !=
            null) {
          print("CHAT USERS : ${userNameList[i]}");
          chatUsersList.add(userNameList[i]);
        }
      }
    }

    print("CHAT USERS LIST : ${chatUsersList.length}");

    return chatUsersList;

    // print("USERNAMES LIST : ${userNameList.length}");
    // return userNameList;
  }

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
    await _firestore.collection("Users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
        //userList.add(querySnapshot.documents[i].data[User.fromMap(mapData)]);
      }
    }
    print("USERSLIST : ${userList.length}");
    return userList;
  }

  Future<String> getPrivacy(String userId) async{
    DocumentSnapshot snapshot=await _firestore.collection("Users").document(userId).get();
    return snapshot.data['Privacy'];
  }

  Future<List<String>> getMutuals(String currentUid,String receiverUid) async{
    QuerySnapshot currentUser=await _firestore.collection("Users").document(currentUid).collection("Following").getDocuments();
    QuerySnapshot receiverUser=await _firestore.collection("Users").document(receiverUid).collection("Following").getDocuments();
    List<String> list1=[];
    List<String> list2=[];

    for(var i = 0; i < currentUser.documents.length; i++){
      list1.add(currentUser.documents[i].documentID);
    }

    for(var i = 0; i < receiverUser.documents.length; i++){
      list2.add(receiverUser.documents[i].documentID);
    }

    list1.removeWhere((item)=>!list2.contains(item));
    print("Mutual List: ${list1.toList()}");
    return list1;
  }

  /*void uploadImageMsgToDb(String url, String receiverUid, String senderuid) {
    _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: senderuid,
        photoUrl: url,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _firestore
        .collection("messages")
        .document(_message.senderUid)
        .collection(receiverUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });

    _firestore
        .collection("messages")
        .document(receiverUid)
        .collection(_message.senderUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });
  }*/

  /*Future<void> addMessageToDb(Message message, String receiverUid) async {
    print("Message : ${message.message}");
    var map = message.toMap();

    print("Map : $map");
    await _firestore
        .collection("messages")
        .document(message.senderUid)
        .collection(receiverUid)
        .add(map);

    return _firestore
        .collection("messages")
        .document(receiverUid)
        .collection(message.senderUid)
        .add(map);
  }*/

  Future<List<DocumentSnapshot>> getFollowingLength(String userId) async{
    QuerySnapshot snapshot=await _firestore.collection("Users")
        .document(userId).collection("Following")
        .where('status',isEqualTo: 'friends')
        .getDocuments();

    print(" Following members : ${snapshot.documents.length}");
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getFollowersLength(String userId) async{
    QuerySnapshot snapshot=await _firestore.collection("Users")
        .document(userId).collection("Followers")
        .where('status',isEqualTo: 'friends')
        .getDocuments();

    print(" Followers members : ${snapshot.documents.length}");
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) async {
    List<String> followingUIDs = List<String>();
    List<DocumentSnapshot> list =List<DocumentSnapshot>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("Users")
        .document(user.uid)
        .collection("following")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }

    print("FOLLOWING UIDS : ${followingUIDs.length}");

    for (var i = 0; i < followingUIDs.length; i++) {
      print("SDDSSD : ${followingUIDs[i]}");

      //retrievePostByUID(followingUIDs[i]);
      // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await _firestore
          .collection("Users")
          .document(followingUIDs[i])
          .collection("posts")
          .getDocuments();
      // postSnapshot.documents;
      for (var i = 0; i < postSnapshot.documents.length; i++) {
        print("dad : ${postSnapshot.documents[i].documentID}");
        list.add(postSnapshot.documents[i]);
        print("ads : ${list.length}");
      }
    }

    return list;
  }

  Future<List<String>> fetchFollowingUids(FirebaseUser user) async{
    List<String> followingUIDs = List<String>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(user.uid)
        .collection("following")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DDDD : ${followingUIDs[i]}");
    }
    return followingUIDs;
  }

  Future<void> sendFollowRequest(String receiverId,String currentUid) async{
    var follow = {'uid': receiverId, 'status': 'sent'};

    _firestore
        .collection("Users")
        .document(currentUid)
        .collection("Following")
        .document(receiverId)
        .setData(follow)
        .then((onValue) {
      //print("Success inside");
      var followers = {'uid': currentUid, 'status': 'received'};
      _firestore
          .collection("Users")
          .document(receiverId)
          .collection("Followers")
          .document(currentUid)
          .setData(followers)
          .then((onValue) {
        print('follow success');
      });
    });
  }
}