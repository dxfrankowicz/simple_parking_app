// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MapStore on _MapStoreBase, Store {
  final _$controllerAtom = Atom(name: '_MapStoreBase.controller');

  @override
  Completer<GoogleMapController> get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(Completer<GoogleMapController> value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  final _$isWaitingForLocalizationAtom =
      Atom(name: '_MapStoreBase.isWaitingForLocalization');

  @override
  bool get isWaitingForLocalization {
    _$isWaitingForLocalizationAtom.reportRead();
    return super.isWaitingForLocalization;
  }

  @override
  set isWaitingForLocalization(bool value) {
    _$isWaitingForLocalizationAtom
        .reportWrite(value, super.isWaitingForLocalization, () {
      super.isWaitingForLocalization = value;
    });
  }

  final _$cameraPositionAtom = Atom(name: '_MapStoreBase.cameraPosition');

  @override
  CameraPosition get cameraPosition {
    _$cameraPositionAtom.reportRead();
    return super.cameraPosition;
  }

  @override
  set cameraPosition(CameraPosition value) {
    _$cameraPositionAtom.reportWrite(value, super.cameraPosition, () {
      super.cameraPosition = value;
    });
  }

  final _$mapTypeAtom = Atom(name: '_MapStoreBase.mapType');

  @override
  MapType get mapType {
    _$mapTypeAtom.reportRead();
    return super.mapType;
  }

  @override
  set mapType(MapType value) {
    _$mapTypeAtom.reportWrite(value, super.mapType, () {
      super.mapType = value;
    });
  }

  final _$markersAtom = Atom(name: '_MapStoreBase.markers');

  @override
  ObservableSet<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableSet<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  final _$addLocationMarkerAtom = Atom(name: '_MapStoreBase.addLocationMarker');

  @override
  Marker get addLocationMarker {
    _$addLocationMarkerAtom.reportRead();
    return super.addLocationMarker;
  }

  @override
  set addLocationMarker(Marker value) {
    _$addLocationMarkerAtom.reportWrite(value, super.addLocationMarker, () {
      super.addLocationMarker = value;
    });
  }

  final _$addLocationModelAtom = Atom(name: '_MapStoreBase.addLocationModel');

  @override
  ParkingLocationModel get addLocationModel {
    _$addLocationModelAtom.reportRead();
    return super.addLocationModel;
  }

  @override
  set addLocationModel(ParkingLocationModel value) {
    _$addLocationModelAtom.reportWrite(value, super.addLocationModel, () {
      super.addLocationModel = value;
    });
  }

  final _$addLocationViewAtom = Atom(name: '_MapStoreBase.addLocationView');

  @override
  bool get addLocationView {
    _$addLocationViewAtom.reportRead();
    return super.addLocationView;
  }

  @override
  set addLocationView(bool value) {
    _$addLocationViewAtom.reportWrite(value, super.addLocationView, () {
      super.addLocationView = value;
    });
  }

  final _$addLocationNameEmptyAtom =
      Atom(name: '_MapStoreBase.addLocationNameEmpty');

  @override
  bool get addLocationNameEmpty {
    _$addLocationNameEmptyAtom.reportRead();
    return super.addLocationNameEmpty;
  }

  @override
  set addLocationNameEmpty(bool value) {
    _$addLocationNameEmptyAtom.reportWrite(value, super.addLocationNameEmpty,
        () {
      super.addLocationNameEmpty = value;
    });
  }

  final _$getLocationAndInitAsyncAction =
      AsyncAction('_MapStoreBase.getLocationAndInit');

  @override
  Future<dynamic> getLocationAndInit() {
    return _$getLocationAndInitAsyncAction
        .run(() => super.getLocationAndInit());
  }

  final _$getCurrentLocationAsyncAction =
      AsyncAction('_MapStoreBase.getCurrentLocation');

  @override
  Future<LocationData?> getCurrentLocation() {
    return _$getCurrentLocationAsyncAction
        .run(() => super.getCurrentLocation());
  }

  final _$_goToTheLocationAsyncAction =
      AsyncAction('_MapStoreBase._goToTheLocation');

  @override
  Future<void> _goToTheLocation(CameraPosition cameraPosition) {
    return _$_goToTheLocationAsyncAction
        .run(() => super._goToTheLocation(cameraPosition));
  }

  final _$addMarkerAsyncAction = AsyncAction('_MapStoreBase.addMarker');

  @override
  Future addMarker(ParkingLocationModel parkingLocationModel) {
    return _$addMarkerAsyncAction
        .run(() => super.addMarker(parkingLocationModel));
  }

  final _$addNewLocationAsyncAction =
      AsyncAction('_MapStoreBase.addNewLocation');

  @override
  Future addNewLocation() {
    return _$addNewLocationAsyncAction.run(() => super.addNewLocation());
  }

  final _$_MapStoreBaseActionController =
      ActionController(name: '_MapStoreBase');

  @override
  dynamic switchMapType() {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.switchMapType');
    try {
      return super.switchMapType();
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic switchToAddLocationView() {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.switchToAddLocationView');
    try {
      return super.switchToAddLocationView();
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNameForNewLocation(String? x) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.setNameForNewLocation');
    try {
      return super.setNameForNewLocation(x);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDescriptionForNewLocation(String? x) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.setDescriptionForNewLocation');
    try {
      return super.setDescriptionForNewLocation(x);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRankForNewLocation(int? x) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.setRankForNewLocation');
    try {
      return super.setRankForNewLocation(x);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateMarkers(List<DocumentSnapshot<Object?>> documentList) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.updateMarkers');
    try {
      return super.updateMarkers(documentList);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateAddLocationMarker(CameraPosition position) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.updateAddLocationMarker');
    try {
      return super.updateAddLocationMarker(position);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateNewLocationName() {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
        name: '_MapStoreBase.validateNewLocationName');
    try {
      return super.validateNewLocationName();
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
controller: ${controller},
isWaitingForLocalization: ${isWaitingForLocalization},
cameraPosition: ${cameraPosition},
mapType: ${mapType},
markers: ${markers},
addLocationMarker: ${addLocationMarker},
addLocationModel: ${addLocationModel},
addLocationView: ${addLocationView},
addLocationNameEmpty: ${addLocationNameEmpty}
    ''';
  }
}
