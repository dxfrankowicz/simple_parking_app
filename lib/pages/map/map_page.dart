import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_parking_app/components/base_scaffold.dart';
import 'package:simple_parking_app/generated/l10n.dart';
import 'package:simple_parking_app/pages/map/map_store.dart';
import 'package:simple_parking_app/utils/di/di.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapStore mapStore = getIt<MapStore>();

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
        body: GoogleMap(
          mapType: mapStore.mapType,
          initialCameraPosition: mapStore.cameraPosition,
          onMapCreated: (GoogleMapController controller) {
            mapStore.controller.complete(controller);
          },
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: () {},
                label: AutoSizeText(S.current.addParkingLocation, maxLines: 1),
                icon: Icon(Icons.add_location_alt_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight * 2),
              child: Align(
                alignment: Alignment.topRight,
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
            ),
          ],
        ),
      );
    });
  }
}
