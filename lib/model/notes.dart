class Note {
  int id;
  String deltaTitle;
  String deltaDesc;
  String title;
  String desc;
  DateTime created;
  DateTime lastModified;
  bool isBackup;

  Note(
      {required this.id,
      required this.deltaTitle,
      required this.deltaDesc,
      required this.title,
      required this.desc,
      required this.created,
      required this.lastModified,
      required this.isBackup});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        deltaTitle: json['deltaTitle'],
        deltaDesc: json['deltaDesc'],
        title: json['title'],
        desc: json['desc'],
        created: DateTime.parse(json['created']),
        lastModified: DateTime.parse(json['lastModified']),
        isBackup: json['isBackup'] == 1 || json['isBackup'] == true
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['deltaTitle'] = deltaTitle;
    data['deltaDesc'] = deltaDesc;
    data['title'] = title;
    data['desc'] = desc;
    data['created'] = created.toIso8601String();
    data['lastModified'] = lastModified.toIso8601String();
    data['isBackup'] = isBackup ? 1 : 0;
    return data;
  }
}
