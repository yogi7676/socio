import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socio/Models/UserModel.dart';
import 'package:socio/resources/Firebase_Provider.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) => _firebaseProvider.addDataToDb(user);

  //Future<FirebaseUser> signIn() => _firebaseProvider.signIn();

  Future<bool> authenticateUser(FirebaseUser user) => _firebaseProvider.authenticateUser(user);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) => _firebaseProvider.uploadImageToStorage(imageFile);

  //Future<void> addPostToDb(User currentUser, String imgUrl, String caption, String location) => _firebaseProvider.addPostToDb(currentUser, imgUrl, caption, location);

  Future<User> retrieveUserDetails(FirebaseUser user) => _firebaseProvider.retrieveUserDetails(user);

  Future<bool> emailExists(String email)=>_firebaseProvider.emailExists(email);

  Future<bool> usernameExists(String name)=>_firebaseProvider.usernameExists(name);

  Future<String> getPrivacy(String userId)=>_firebaseProvider.getPrivacy(userId);

  Future<DocumentSnapshot> isFollowing(String currentUid,String receiverId) => _firebaseProvider.isFollowing(currentUid, receiverId);

  Future<DocumentSnapshot> isFollower(String currentUid,String receiverId) => _firebaseProvider.isFollower(currentUid, receiverId);

  Future<List<String>> getMutuals(String currentUid,String receiverUid)=>_firebaseProvider.getMutuals(currentUid, receiverUid);

  //Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) => _firebaseProvider.retrieveUserPosts(userId);

  //Future<List<DocumentSnapshot>> fetchPostComments(DocumentReference reference) => _firebaseProvider.fetchPostCommentDetails(reference);

  //Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) => _firebaseProvider.fetchPostLikeDetails(reference);

  //Future<bool> checkIfUserLikedOrNot(String userId, DocumentReference reference) => _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

  Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) => _firebaseProvider.retrievePosts(user);

  Future<List<String>> fetchAllUserNames(FirebaseUser user) => _firebaseProvider.fetchAllUserNames(user);

  Future<List<DocumentSnapshot>> fetchFollowingLength(String userId)=>_firebaseProvider.getFollowingLength(userId);

  Future<List<DocumentSnapshot>> fetchFollowersLength(String userId)=>_firebaseProvider.getFollowersLength(userId);

  Future<String> fetchUidBySearchedName(String name) => _firebaseProvider.fetchUidBySearchedName(name);

  Future<User> fetchUserDetailsById(String uid) => _firebaseProvider.fetchUserDetailsById(uid);

  Future<void> followUser(String currentUid,String receiverId)=>_firebaseProvider.onFollowPressed(receiverId, currentUid);

  Future<void> unfollowUser(String currentUid,String receiverId)=>_firebaseProvider.onUnfollowPressed(currentUid, receiverId);

  Future<void> acceptFollowRequest(String currentUid,String receiverId)=>_firebaseProvider.onAcceptPressed(currentUid, receiverId);

  Future<void> rejectFollowRequest(String currentUid,String receiverId)=>_firebaseProvider.onRejectPressed(currentUid, receiverId);

  Future<List<DocumentSnapshot>> fetchPosts(String uid) => _firebaseProvider.fetchPosts(uid);

  Future<bool> isBestie(String currentUid,String receiverUid) => _firebaseProvider.isBestie(currentUid, receiverUid);

  Future<void> makeBestie(String currentUid,String receiverUid)=> _firebaseProvider.makeBestie(currentUid, receiverUid);

  Future<void> removeBestie(String currentUid,String receiverUid)=> _firebaseProvider.removeBestie(currentUid, receiverUid);

  Future<void> updatePhoto(String photoUrl, String uid) => _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String bio, String email, String phone) => _firebaseProvider.updateDetails(uid, name, bio, email, phone);

  Future<List<String>> fetchUserNames(FirebaseUser user) => _firebaseProvider.fetchUserNames(user);

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseProvider.fetchAllUsers(user);

  //void uploadImageMsgToDb(String url, String receiverUid, String senderuid) => _firebaseProvider.uploadImageMsgToDb(url, receiverUid, senderuid);

  //Future<void> addMessageToDb(Message message, String receiverUid) => _firebaseProvider.addMessageToDb(message, receiverUid);

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) => _firebaseProvider.fetchFeed(user);

  Future<List<String>> fetchFollowingUids(FirebaseUser user) => _firebaseProvider.fetchFollowingUids(user);

//Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}