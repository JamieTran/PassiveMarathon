import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseManagement{

  final databaseReference = Firestore.instance;

  void createUser(id) async {
  await databaseReference.collection("users")
      .document("test")
      .setData({
        'userID': '1',
        'first_name':'Yeet',
        'last_name':'Boi',
        'dob':'',
        'token':'',
      });
  }

  void createGroup(groupName) async {
  await groupName.collection("groups")
      .document(groupName);
  }
  
}