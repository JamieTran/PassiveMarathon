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
    await databaseReference.collection("groups").document(groupName)
    .setData({
      'groupName':groupName,
      'distance':groupDistance,
      'members':[dBCodeNameRef],
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