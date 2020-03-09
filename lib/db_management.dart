import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManagement{

  final databaseReference = Firestore.instance;

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

  void createGroup(groupName) async {
  await groupName.collection("groups")
      .document(groupName);
  }

  queryUsers(String username) {
    return databaseReference.collection('users')
    .where('searchKey', isEqualTo: username.substring(0,1).toUpperCase())
    .getDocuments();
  }

  addFriend(addedFriend) { // Add to Adam Array because he is lonely
    DocumentReference array =  databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5');

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> friendArray = datasnapshot.data['friends'].toList();
      friendArray.add(addedFriend);
      databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5').updateData({"friends": FieldValue.arrayUnion(friendArray)});
      }
    });
  }

  removeFriend(friendName) {
    DocumentReference array =  databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5');

    array.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      List<dynamic> friendArray = datasnapshot.data['friends'].toList();
      print("removing " + friendName);
      friendArray.remove(friendName);
      print("ARRAY ->"+friendArray.toString());
      databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5').updateData({"friends": friendArray});
      }
    });
  }

  getFriendsArray() {
    return databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5');
  }

  getFriends() async {
    DocumentReference array = databaseReference.collection('users').document('NPne34FyhahEnMXHaYh5');
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