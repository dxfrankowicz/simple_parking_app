import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_parking_app/models/parking_location.dart';
import 'package:simple_parking_app/utils/location_utils.dart';
import 'package:simple_parking_app/utils/log/log.dart';
import 'package:flutter/material.dart';

part 'map_store.g.dart';

@singleton
class MapStore extends _MapStoreBase with _$MapStore {
  MapStore() : super();
}

abstract class _MapStoreBase with Store {
  final Logger logger = new Logger("MapStore");

  _MapStoreBase();

  static final CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @observable
  Completer<GoogleMapController> controller = Completer();

  @observable
  bool isWaitingForLocalization = false;

  @observable
  CameraPosition cameraPosition = _defaultPosition;

  @observable
  MapType mapType = MapType.normal;

  @observable
  ObservableSet<Marker> markers = ObservableSet<Marker>();

  @action
  Future getLocationAndInit() async {
    isWaitingForLocalization = true;
    var location = await getCurrentLocation();
    if (location != null)
      cameraPosition = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!),
        zoom: 14.4746,
      );
    else
      cameraPosition = _defaultPosition;
    _goToTheLocation(cameraPosition);
  }

  @action
  Future<LocationData?> getCurrentLocation() async {
    LocationData? locationData = await LocationUtils.determinePosition();
    log.info(
        "Got location lat: ${locationData!.latitude!} lon: ${locationData.longitude!}}");
    return locationData;
  }

  @action
  Future<void> _goToTheLocation(CameraPosition cameraPosition) async {
    final GoogleMapController _controller = await controller.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @action
  switchMapType() {
    mapType = mapType == MapType.normal ? MapType.hybrid : MapType.normal;
  }

  @action
  addMarker(ParkingLocationModel parkingLocationModel) async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/parking_marker.png');
    var marker = Marker(
        position: LatLng(parkingLocationModel.geolocation!.latitude,
            parkingLocationModel.geolocation!.longitude),
        icon: icon,
        infoWindow: InfoWindow(title: parkingLocationModel.name),
        markerId: MarkerId((markers.length + 1).toString()));
    markers.add(marker);
  }

  @action
  updateMarkers(List<DocumentSnapshot> documentList) {
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      try {
        addMarker(ParkingLocationModel.fromJson(document.data() as Map<String, dynamic>));
      } catch (e) {
        log.error("Could not add marker: ${document.data()}");
      }
    });
  }
}
