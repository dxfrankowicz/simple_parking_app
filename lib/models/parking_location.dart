import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parking_location.g.dart';

@JsonSerializable()
class ParkingLocationModel {
  String? name;
  String? description;
  int? ranking;
  @JsonKey(name: "lat_lon", fromJson: getGeoPoint, toJson: getGeoPoint)
  GeoPoint? geolocation;

  ParkingLocationModel(this.name, this.description, this.ranking, this.geolocation);
  ParkingLocationModel.empty();

  static GeoPoint? getGeoPoint(GeoPoint? value) => value;

  factory ParkingLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ParkingLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationModelToJson(this);
}
