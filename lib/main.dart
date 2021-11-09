import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_parking_app/utils/location_utils.dart';

import 'generated/l10n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Simple Parking App',
      home: MapWidget(),
    );
  }
}

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  bool isWaitingForLocalization = false;

  CameraPosition? initialCameraPosition;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    getLocationAndInit();
    super.initState();
  }

  Future<void> getLocationAndInit() async {
    isWaitingForLocalization = true;
    var location = await LocationUtils.determinePosition();
    if (location != null)
      initialCameraPosition = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!),
        zoom: 14.4746,
      );
    else
      initialCameraPosition = _kGooglePlex;
    _goToTheLocation(initialCameraPosition!);
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Simple parking app",
              ),
            ),
          ),
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: _goToTheLake,
                label: AutoSizeText(S.current.addParkingLocation, maxLines: 1),
                icon: Icon(Icons.add_location_alt_outlined),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(Icons.my_location_rounded, color: Colors.black),
                onPressed: () => getLocationAndInit(),
              ),
            ),
          ],
        ));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToTheLocation(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
