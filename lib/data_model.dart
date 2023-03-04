class DataStoredModel {
  int? id;
  String? name;
  String? designation;
  String? company;
  int? experience;

  DataStoredModel({this.id, required this.name, required this.designation, required this.company, required this.experience});

  /// convert map
  Map<String, dynamic> toMap(){
    var map= <String, dynamic>{};

    map['id'] = id;
    map['name']= name;
    map['designation']= designation;
    map['company']= company;
    map['experience']= experience;
    return map;
  }
  factory DataStoredModel.fromMapToObject(Map<String, dynamic> map) => DataStoredModel(
    id: map['id'],
    name: map['name'],
    designation: map['designation'],
    company: map['company'],
    experience: map['experience'],
  );
}
