
class Message{
  String id;
  String currUid;
  String snippet;
  String time;
  String avatar;
  String chatID;
  
  Message({required this.id, required this.currUid, required this.snippet, required this.time, required this.avatar, 
  required this.chatID
  });
  
  // static List<Message> messages = [
  //   Message(
  //     name: "Roger Ando",
  //     snippet: "Im Coming!",
  //     time: "6:00pm",
  //     avatar: "https://www.pngwing.com/en/free-png-xsukd",
  //   ),
  //   Message(
  //     name: "JP Rotor",
  //     snippet: "Naka pass naka?",
  //     time: "5:30pm",
  //     avatar: "https://www.pngwing.com/en/free-png-xsukd",
  //   ),
  //   Message(
  //     name: "Nicolen Aricayos",
  //     snippet: "Ahaka nadugay kog mata",
  //     time: "9:00am",
  //     avatar: "https://www.pngwing.com/en/free-png-xsukd",
  //   ),
  // ];
}