// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingLocationModel _$ParkingLocationModelFromJson(
        Map<String, dynamic> json) =>
    ParkingLocationModel(
      json['name'] as String?,
      json['description'] as String?,
      json['ranking'] as int?,
      ParkingLocationModel.getGeoPoint(json['lat_lon'] as GeoPoint?),
    );

Map<String, dynamic> _$ParkingLocationModelToJson(
        ParkingLocationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'ranking': instance.ranking,
      'lat_lon': ParkingLocationModel.getGeoPoint(instance.geolocation),
    };
