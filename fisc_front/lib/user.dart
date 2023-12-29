class User {
  String name;
  String phoneNo;
  bool kycVerified;

  User({
    required this.name,
    required this.phoneNo,
    required this.kycVerified,
  });
}

User? loggedInUser;
