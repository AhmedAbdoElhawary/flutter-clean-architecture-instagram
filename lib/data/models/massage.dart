
class Massage {
  String datePublished;
  String massage;
  String receiverId;
  String massageUid;
  String senderId;

  Massage({
    required this.datePublished,
    required this.massage,
    required this.receiverId,
    required this.senderId,
    required this.massageUid,
  });

  static Massage fromJson(Map<String, dynamic> snap) {
    return Massage(
      datePublished: snap["datePublished"],
      massage: snap["massage"],
      receiverId: snap["receiverId"],
      senderId: snap["senderId"],
      massageUid: snap["massageUid"],

    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "massage": massage,
        "receiverId": receiverId,
        'senderId': senderId,
      };
}
