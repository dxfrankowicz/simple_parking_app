import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_parking_app/models/parking_location.dart';
import 'package:simple_parking_app/utils/buttons/rounded_loading_button.dart';
import 'package:simple_parking_app/utils/firestore/firestore_service.dart';
import 'package:simple_parking_app/utils/location_utils.dart';
import 'package:simple_parking_app/utils/log/log.dart';
import 'package:flutter/material.dart';

part 'map_store.g.dart';

@singleton
class MapStore extends _MapStoreBase with _$MapStore {
  MapStore() : super();
}

abstract class _MapStoreBase with Store {
  final logger = new Logger("MapStore");

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

  @observable
  Marker addLocationMarker = Marker(
      position:
          LatLng(_defaultPosition.target.latitude, _defaultPosition.target.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      markerId: MarkerId("addLocationMarker"));

  @observable
  ParkingLocationModel addLocationModel = ParkingLocationModel.empty();

  @observable
  bool addLocationView = false;

  @observable
  bool addLocationNameEmpty = false;

  @observable
  LoadingState addNewLocationStatus = LoadingState.idle;

  @action
  Future getLocationAndInit() async {
    isWaitingForLocalization = true;
    if(icon==null)
      icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'assets/parking_marker.png');
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
  switchAddLocationView() {
    addLocationView = !addLocationView;
    if (!addLocationView) {
      addLocationModel = ParkingLocationModel.empty();
      addLocationModel.geolocation = GeoPoint(
          addLocationMarker.position.latitude, addLocationMarker.position.longitude);
    }
  }

  @action
  setNameForNewLocation(String? x) {
    addLocationModel.name = x;
    validateNewLocationName();
  }

  @action
  setDescriptionForNewLocation(String? x) {
    addLocationModel.description = x;
  }

  @action
  void setRankForNewLocation(int? x) {
    var model = addLocationModel;
    model.ranking = x;
    addLocationModel = model;
  }

  ParkingLocationModel? selectedParkingLocation;
  BitmapDescriptor? icon;

  @action
  addMarker(ParkingLocationModel parkingLocationModel,
      {required CustomInfoWindowController customInfoWindowController,
      required Function(ParkingLocationModel model) showInfoView}) async {
    var marker = Marker(
        position: LatLng(parkingLocationModel.geolocation!.latitude,
            parkingLocationModel.geolocation!.longitude),
        icon: icon!,
        onTap: () => showInfoView.call(parkingLocationModel),
        markerId: MarkerId((markers.length + 1).toString()));
    markers.add(marker);
  }

  @action
  updateMarkers(
      List<DocumentSnapshot> documentList,
      CustomInfoWindowController customInfoWindowController,
      Function(ParkingLocationModel model) showInfoView) {
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      try {
        addMarker(ParkingLocationModel.fromJson(document.data() as Map<String, dynamic>),
            customInfoWindowController: customInfoWindowController,
            showInfoView: showInfoView);
      } catch (e) {
        log.error("Could not add marker: ${document.data()}");
      }
    });
  }

  @action
  updateAddLocationMarker(CameraPosition position) {
    addLocationMarker = addLocationMarker.copyWith(
        positionParam: LatLng(position.target.latitude, position.target.longitude));
    addLocationModel.geolocation =
        GeoPoint(position.target.latitude, position.target.longitude);
  }

  @action
  bool validateNewLocationName() {
    if (addLocationModel.name == null || (addLocationModel.name?.isEmpty ?? true))
      addLocationNameEmpty = true;
    else
      addLocationNameEmpty = false;
    return addLocationNameEmpty;
  }

  @action
  addNewLocation() async {
    addNewLocationStatus = LoadingState.loading;
    if (!validateNewLocationName()) {
      FirestoreService.addNewParkingLocation(ParkingLocationModel(
              addLocationModel.name,
              addLocationModel.description,
              addLocationModel.ranking,
              GeoPoint(addLocationMarker.position.latitude,
                  addLocationMarker.position.longitude)))
          .then((value) {
        addNewLocationStatus = LoadingState.success;
        Future.delayed(Duration(seconds: 1))
            .then((value) => switchAddLocationView());
      }).catchError((onError) {
        addNewLocationStatus = LoadingState.error;
      });
    } else {
      Future.delayed(Duration(seconds: 1))
          .then((value) => addNewLocationStatus = LoadingState.error);
    }
  }
}
