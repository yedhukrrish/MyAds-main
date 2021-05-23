class SignUp2Response {
  String firstName;
  String lastName;
  String ageGroup;
  String incomeGroup;
  String mobile;
  String postalCode;
  String country;
  String userid;
  String gender;
  String error;

  SignUp2Response(
      {this.firstName,
        this.lastName,
        this.ageGroup,
        this.incomeGroup,
        this.mobile,
        this.postalCode,
        this.country,
        this.userid,
        this.gender,
        this.error});

  SignUp2Response.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    ageGroup = json['age_group'];
    incomeGroup = json['income_group'];
    mobile = json['mobile'];
    postalCode = json['postal_code'];
    country = json['country'];
    userid = json['userid'];
    gender = json['gender'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['age_group'] = this.ageGroup;
    data['income_group'] = this.incomeGroup;
    data['mobile'] = this.mobile;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    data['userid'] = this.userid;
    data['gender'] = this.gender;
    data['error'] = this.error;
    return data;
  }
}
