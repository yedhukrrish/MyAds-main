class GetInterestsResponse {
  List<Interests> interests;

  GetInterestsResponse({this.interests});

  GetInterestsResponse.fromJson(Map<String, dynamic> json) {
    if (json['interests'] != null) {
      interests = new List<Interests>();
      json['interests'].forEach((v) {
        interests.add(new Interests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.interests != null) {
      data['interests'] = this.interests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Interests {
  String value;
  String image;

  Interests({this.value, this.image});

  Interests.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}
