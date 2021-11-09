import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_parking_app/utils/location_utils.dart';

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

  @action
  Future getLocationAndInit() async {
    isWaitingForLocalization = true;
    var location = await LocationUtils.determinePosition();
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
  Future<void> _goToTheLocation(CameraPosition cameraPosition) async {
    final GoogleMapController _controller = await controller.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
