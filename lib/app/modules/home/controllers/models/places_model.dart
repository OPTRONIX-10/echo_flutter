class PlacesModel {
  String id;
  String name;
  String? contactNumber;
  String address;
  double latitude;
  double longitude;

  PlacesModel({
    required this.id,
    required this.name,
    this.contactNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contact_number'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
