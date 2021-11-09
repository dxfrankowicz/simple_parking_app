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

  final _$getLocationAndInitAsyncAction =
      AsyncAction('_MapStoreBase.getLocationAndInit');

  @override
  Future<dynamic> getLocationAndInit() {
    return _$getLocationAndInitAsyncAction
        .run(() => super.getLocationAndInit());
  }

  final _$_goToTheLocationAsyncAction =
      AsyncAction('_MapStoreBase._goToTheLocation');

  @override
  Future<void> _goToTheLocation(CameraPosition cameraPosition) {
    return _$_goToTheLocationAsyncAction
        .run(() => super._goToTheLocation(cameraPosition));
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
  String toString() {
    return '''
controller: ${controller},
isWaitingForLocalization: ${isWaitingForLocalization},
cameraPosition: ${cameraPosition},
mapType: ${mapType}
    ''';
  }
}
