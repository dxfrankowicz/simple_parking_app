import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_parking_app/components/base_scaffold.dart';
import 'package:simple_parking_app/generated/l10n.dart';
import 'package:simple_parking_app/pages/map/map_store.dart';
import 'package:simple_parking_app/utils/di/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_parking_app/utils/log/log.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapStore mapStore = getIt<MapStore>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    mapStore.getLocationAndInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return PARKINGScaffold.get(
        context,
        body: Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('locations').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  mapStore.updateMarkers(snapshot.data!.docs);
                else
                  log.info("No data");
                return Observer(
                  builder: (_) {
                    return GoogleMap(
                      mapType: mapStore.mapType,
                      initialCameraPosition: mapStore.cameraPosition,
                      markers: mapStore.markers,
                      onMapCreated: (GoogleMapController controller) {
                        mapStore.controller.complete(controller);
                      },
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  label: AutoSizeText(S.current.addParkingLocation, maxLines: 1),
                  icon: Icon(Icons.add_location_alt_outlined),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Icon(Icons.my_location_rounded, color: Colors.black),
                    onPressed: () => mapStore.getLocationAndInit.call(),
                  ),
                  SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Icon(Icons.layers, color: Colors.black),
                    onPressed: () => mapStore.switchMapType(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
