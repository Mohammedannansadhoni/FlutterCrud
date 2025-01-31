class Customer {
  String pan;
  String fullName;
  String email;
  String mobileNumber;
  List<Address> addresses;

  Customer({
    required this.pan,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.addresses,
  });
}

class Address {
  String line1;
  String? line2;
  String postcode;
  String state;
  String city;

  Address({
    required this.line1,
    this.line2,
    required this.postcode,
    required this.state,
    required this.city,
  });
}
