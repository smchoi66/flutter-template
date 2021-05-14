class FactsResponse {
  late int id;
  String? category;
  List<Fact>? facts;

  FactsResponse({required this.id, this.category, this.facts});

  FactsResponse.fromJson(json) {
    id = json['id'] as int;
    category = json['category'] as String;
    if (json['facts'] != null) {
      facts = <Fact>[];
      json['facts']!.forEach((v) {
        facts!.add(Fact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    if (facts != null) {
      data['facts'] = facts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fact {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  Fact({this.id, this.title, this.description, this.imageUrl});

  Fact.fromJson(json) {
    id = json['id']! as int;
    title = json['title']!.toString();
    description = json['description']!.toString();
    imageUrl = json['image_url']!.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image_url'] = imageUrl;
    return data;
  }
}
