import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManagement{

  final databaseReference = Firestore.instance;
  var dBCodeNameRef;

  void createUser(id, String name) async {
    // save the dBCodeNameRef here somewhere?

    DocumentReference docRef = await databaseReference.collection("users")
      .add({
        'userID': id.toString(),
        'name': name,
        'searchKey': name.substring(0,1).toUpperCase(),
        'dob':'',
        'friends': {},
        'groups': [],
        'invites': [],
      });

      setDBCodeNameRef(docRef.documentID);
  }

  void setDBCodeNameRef(String ref)
  {
    dBCodeNameRef = ref;
  }

  void editUser(String name){
    DocumentReference doc = databaseReference.collection('users').document(dBCodeNameRef);

    doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"name": name});
      }
    });
  }

  getUserRef()
  {
    return dBCodeNameRef;
  }

  getGroupRef(groupName)
  {
    return databaseReference.collection('groups').document(groupName);
  }

  void getGroupName()
  {
    DocumentReference doc = databaseReference.collection('users').document(dBCodeNameRef);
    var name;
  }

  void createGroup(String groupName, groupDistance) async
  {
    DocumentReference doc = databaseReference.collection('users').document(dBCodeNameRef);
    var name;

    await doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      name = datasnapshot.data['name'].toString();
      }
    });

/*     await databaseReference.collection("groups").document(groupName)
    .setData({
      'admin':dBCodeNameRef,
      'groupName':groupName,
      'groupDistance':groupDistance,
      'membersInfo':[{"name":name,"distance":32,"reference":dBCodeNameRef},
                     {"name":"Mateus Gurgel","distance":28,"reference":dbCodeMateusRef},
                     {"name":"Ed Barsalou","distance":20, "reference":dbEdRef},
                     {"name":"Russ Foubert","distance":16, "reference":dbRussRef},
                     {"name":"Manuel Poppe Richter","distance":13,"reference":dbCodeMannyRef},
                     {"name":"Jamie Tran","distance":10,"reference":dbJamieRef}]
      'admin':dBCodeNameRef,
      'membersInfo':[{"name":name,"distance":0,"reference":dBCodeNameRef}]
    });*/

    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> groupArray = datasnapshot.data['groups'].toList();
      groupArray.add(groupName);
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"groups": FieldValue.arrayUnion(groupArray)});
      }
    });
  }

  leaveGroup(groupName, userRef)
  {
    var userDbRef;

    if (userRef != null)
    {
      userDbRef = userRef;
    }
    else
    {
      userDbRef = dBCodeNameRef;
    }
    // Get Members Info
    DocumentReference groupRef = databaseReference.collection('groups').document(groupName);

    groupRef.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      List<dynamic> memberArray = datasnapshot.data['membersInfo'].toList();
      
        for (Map item in memberArray)
        {
          if (item['reference'] == userDbRef) // its the user
          {
            
            DocumentReference userData = databaseReference.collection('users').document(item['reference']);

            // Access user group array and from reference to that group
            await userData.get().then((datasnapshot) {
            if (datasnapshot.exists) {
              List<dynamic> groupArray = datasnapshot.data['groups'].toList();
              groupArray.remove(groupName);
              databaseReference.collection('users').document(item['reference']).updateData({"groups": groupArray});
              }
            });
              // remove from list
              memberArray.remove(item);

              // Update Data
              databaseReference.collection('groups').document(groupName).updateData({"membersInfo": memberArray});
          }
        }
      }
    });
  }

  deleteGroup(groupName)
  {
    // Get Members Info
    DocumentReference groupRef = databaseReference.collection('groups').document(groupName);

    groupRef.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      List<dynamic> memberArray = datasnapshot.data['membersInfo'].toList();
      
        for (Map item in memberArray)
        {
          DocumentReference userData = databaseReference.collection('users').document(item['reference']);

          // Access each user's group array and from reference to that group
          await userData.get().then((datasnapshot) {
          if (datasnapshot.exists) {
            List<dynamic> groupArray = datasnapshot.data['groups'].toList();
            groupArray.remove(groupName);
            databaseReference.collection('users').document(item['reference']).updateData({"groups": groupArray});
            }
          });
        }
        // Delete Group Document
        databaseReference.collection('groups').document(groupName).delete();
      }
    });
  }

  getNameFromCode(codeNameRef)
  {
    DocumentReference doc = databaseReference.collection('users').document(codeNameRef);
  
    doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      String name = datasnapshot.data['name'];
      return name;
      }
    });
  }

  queryUsers(String username) {
    return databaseReference.collection('users')
    .where('searchKey', isEqualTo: username.substring(0,1).toUpperCase())
    .getDocuments();
  }

  queryFriends(String username) {
        return databaseReference.collection('users')
    .where('searchKey', isEqualTo: username.substring(0,1).toUpperCase())
    .getDocuments();
  }

  addFriend(addedFriend, friendDocRef) { // Add to Adam Array because he is lonely
    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      Map<dynamic, dynamic> friendArray = datasnapshot.data['friends'];
      friendArray[addedFriend] = friendDocRef;
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"friends": friendArray});
      }
    });
  }

  sendGroupInvite(groupName, recipientRef) async
  {
    // Send group type invite to invites array
    DocumentReference nameRef = databaseReference.collection('users').document(dBCodeNameRef);
    String name;

    await nameRef.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      name = datasnapshot.data['name'];
      }
    });

    DocumentReference doc = databaseReference.collection('users').document(recipientRef);
    // Place the invite in the user's invite array
    doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> invitesArray = datasnapshot.data['invites'];
      invitesArray.add({"groupName":groupName,"senderName":name,"senderRef":dBCodeNameRef,"type":"Group Request"});
      databaseReference.collection('users').document(recipientRef).updateData({"invites": invitesArray});
      }
    });
  }

  sendFriendInvite(recipientRef) async
  {
    // Need user's name & ref
    DocumentReference nameRef = databaseReference.collection('users').document(dBCodeNameRef);
    String name;

    await nameRef.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      name = datasnapshot.data['name'];
      }
    });

    DocumentReference doc = databaseReference.collection('users').document(recipientRef);
    // Place the invite in the user's invite array
    doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> invitesArray = datasnapshot.data['invites'];
      invitesArray.add({"groupName":null,"senderName":name,"senderRef":dBCodeNameRef,"type":"Friend Request"});
      databaseReference.collection('users').document(recipientRef).updateData({"invites": invitesArray});
      }
    });
  }

  removeInvite(data)
  {
    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> invitesArray = datasnapshot.data['invites'];
        for(Map item in invitesArray){
          if ((item['senderRef'] == data['senderRef']) && (item['type'] == data['type'])){
            invitesArray.remove(item);
          databaseReference.collection('users').document(dBCodeNameRef).updateData({"invites": invitesArray});
      }}}
    });
  }

  getGroupStreamSnapShot(documentRef)
  {
    return databaseReference.collection("groups").document(documentRef).snapshots();
  }

  getFriendList()
  {
    return databaseReference.collection('users').document(dBCodeNameRef);
  }

  removeFriend(friendRef) {
    DocumentReference userFriendArray = databaseReference.collection('users').document(dBCodeNameRef);

    // First, remove the friend from your friend array
    userFriendArray.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      Map<dynamic, dynamic> friendArray = datasnapshot.data['friends'];
      friendArray.removeWhere((key, value) => value == friendRef);  // NEED TO TEST
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"friends": friendArray});
      }
    });

    DocumentReference otherFriendArray = databaseReference.collection('users').document(friendRef);

    // Next, remove your name from their friend array
    otherFriendArray.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      Map<dynamic, dynamic> friendArray = datasnapshot.data['friends'];
      friendArray.removeWhere((key, value) => value == dBCodeNameRef);
      databaseReference.collection('users').document(friendRef).updateData({"friends": friendArray});
      }
    });
  }

  getFriendsArray(ref) {
    return databaseReference.collection('users').document(ref);
  }
    // Did you notice these two functions return the same thing? I didn't. 
    // Don't worry I will be cleaning this up
  getInvitesArray() {
    return databaseReference.collection('users').document(dBCodeNameRef);
  }

  addUserToGroup(groupData) {

    DocumentReference doc = databaseReference.collection('users').document(dBCodeNameRef);
    String name;

    doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      name = datasnapshot.data['name'];
      }
    });

    // Add friend to group array
    DocumentReference array =  databaseReference.collection('groups').document(groupData);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> memberArray = datasnapshot.data['membersInfo'].toList();
      memberArray.add({"name":name,"distance":0,"reference":dBCodeNameRef});
      databaseReference.collection('groups').document(groupData).updateData({"membersInfo": FieldValue.arrayUnion(memberArray)});
      }
    });

    // Add group to friend's group array

    DocumentReference friendArray =  databaseReference.collection('users').document(dBCodeNameRef);

    friendArray.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> groupArray = datasnapshot.data['groups'].toList();
      groupArray.add(groupData);
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"groups": FieldValue.arrayUnion(groupArray)});
      }
    });

    // NOTE * NEED TO CONTINUE FROM HERE BECAUSE FRIENDS HAVE TO BE REDONE
    // STORE DBREF WITH FRIENDS ARRAY 
    return databaseReference.collection('users').document(dBCodeNameRef);


  }

  getGroupsArray() {
    print("Getting Groups Array");
    return databaseReference.collection('users').document(dBCodeNameRef);
  }

  getFriends() async {
    DocumentReference array = databaseReference.collection('users').document(dBCodeNameRef);
    List<String> friendArray = new List<String>();
    await array.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        friendArray = List.from(datasnapshot.data['friends']);
        friendArray.forEach((element) => 
          print(element)
      );
        print("INSIDE FUNCTION ->"+friendArray.toString());
        return friendArray;
      }
    return friendArray;
  });
  }

  checkUser(String userID)
  {
    return databaseReference.collection('users')
    .where('userID', isEqualTo: userID)
    .getDocuments();
  }
}