import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserInfo(String username) async{
    return await Firestore.instance.collection("users")
        .where("userName", isEqualTo: username )
        .getDocuments();
  }
  getUserByEmail(String email) async{
    return await Firestore.instance.collection("users")
        .where("userEmail", isEqualTo: email )
        .getDocuments();
  }
  addUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e) {
          print(e.toString());
    });
  }

  addChatRoom(String chatroomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatroomId).setData(chatRoomMap).catchError((e){
          print(e.toString());
    });


  }

  Future<void> addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}

