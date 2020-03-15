import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManagement{

  final databaseReference = Firestore.instance;
  final dBCodeNameRef = "n577th9XQjF5eaa1HCp3";

  void createUser(id) async {
    print('Add user');
  await databaseReference.collection("users")
    .add({
      'userID': '6',
      'name':'Mateus Gurgel',
      'searchKey':'M',
      'dob':'',
      'token':'',
      'friends': [''],
    });
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

    await databaseReference.collection("groups").document(groupName)
    .setData({
      'groupName':groupName,
      'groupDistance':groupDistance,
      'membersInfo':[{"name":name,"distance":0,"reference":dBCodeNameRef}]
    });

    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> groupArray = datasnapshot.data['groups'].toList();
      groupArray.add(groupName);
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"groups": FieldValue.arrayUnion(groupArray)});
      }
    });
  }

  void getNameFromCode (codeNameRef) async
  {
    DocumentReference doc = databaseReference.collection('users').document(codeNameRef);
    var name;

    await doc.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      name = datasnapshot.data['name'].toString();
      }
    });

    return name;
  }

  queryUsers(String username) {
    return databaseReference.collection('users')
    .where('searchKey', isEqualTo: username.substring(0,1).toUpperCase())
    .getDocuments();
  }

  addFriend(addedFriend) { // Add to Adam Array because he is lonely
    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> friendArray = datasnapshot.data['friends'].toList();
      friendArray.add(addedFriend);
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"friends": FieldValue.arrayUnion(friendArray)});
      }
    });
  }

  getGroupStreamSnapShot(documentRef)
  {
    return databaseReference.collection("groups").document(documentRef).snapshots();
  }

  removeFriend(friendName) {
    DocumentReference array =  databaseReference.collection('users').document(dBCodeNameRef);

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> friendArray = datasnapshot.data['friends'].toList();
      print("removing " + friendName);
      friendArray.remove(friendName);
      print("ARRAY ->"+friendArray.toString());
      databaseReference.collection('users').document(dBCodeNameRef).updateData({"friends": friendArray});
      }
    });
  }

  getFriendsArray() {
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

  
}