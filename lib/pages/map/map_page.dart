import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_parking_app/components/base_scaffold.dart';
import 'package:simple_parking_app/generated/l10n.dart';
import 'package:simple_parking_app/pages/map/map_store.dart';
import 'package:simple_parking_app/utils/di/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_parking_app/utils/firestore/firestore_service.dart';
import 'package:simple_parking_app/utils/log/log.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  MapStore mapStore = getIt<MapStore>();
  double bottomModalHeight = 0;

  late AnimationController _controller;
  late Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    mapStore.getLocationAndInit();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0, end: 1250.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    Future.delayed(Duration.zero)
        .then((value) => bottomModalHeight = MediaQuery.of(context).size.height / 8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PARKINGScaffold.get(
      context,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreService.getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                mapStore.updateMarkers(snapshot.data!.docs);
              else
                log.info("No data");
              return Observer(
                builder: (_) {
                  return GoogleMap(
                    padding: EdgeInsets.only(bottom: bottomModalHeight),
                    mapType: mapStore.mapType,
                    initialCameraPosition: mapStore.cameraPosition,
                    markers: mapStore.addLocationView
                        ? {mapStore.addLocationMarker}
                        : mapStore.markers,
                    onMapCreated: (GoogleMapController controller) {
                      mapStore.controller.complete(controller);
                    },
                    onCameraMove: (CameraPosition position) {
                      mapStore.updateAddLocationMarker(position);
                    },
                  );
                },
              );
            },
          ),
          Align(alignment: Alignment.bottomCenter, child: getBottomModal()),
          AnimatedPositioned(
            bottom: bottomModalHeight - 6,
            left: MediaQuery.of(context).size.width / 4,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: FloatingActionButton(
                elevation: 4,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: mapStore.addLocationView ? Colors.redAccent : null,
                child: Icon(
                    mapStore.addLocationView
                        ? Icons.clear
                        : Icons.add_location_alt_outlined,
                    color: Colors.white),
                onPressed: () {
                  mapStore.switchToAddLocationView();
                  setState(() {
                    if (mapStore.addLocationView)
                      bottomModalHeight = MediaQuery.of(context).size.height / 2.5;
                    else
                      bottomModalHeight = MediaQuery.of(context).size.height / 8;
                  });
                },
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
  }

  Widget getBottomModal() {
    return Observer(builder: (_) {
      return AnimatedContainer(
        height: bottomModalHeight,
        duration: Duration(milliseconds: 500),
        child: Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: !mapStore.addLocationView
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          maxLines: 1,
                          onChanged: mapStore.setNameForNewLocation,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              prefixIcon: Icon(Icons.search_rounded),
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: S.current.search,
                              fillColor: Colors.white70),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: AutoSizeText(
                              S.current.addParkingLocation,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          TextField(
                            maxLines: 1,
                            onChanged: mapStore.setNameForNewLocation,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                labelText: S.current.name,
                                fillColor: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: mapStore.setDescriptionForNewLocation,
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                labelText: S.current.description,
                                fillColor: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              5,
                              (index) => GestureDetector(
                                child: Icon(
                                    (mapStore.addLocationModel.ranking ?? 0) >= index + 1
                                        ? Icons.star
                                        : Icons.star_border_rounded,
                                    color: (mapStore.addLocationModel.ranking ?? 0) >=
                                            index + 1
                                        ? Colors.amber
                                        : Colors.black,
                                    size: 40),
                                onTap: () {
                                  mapStore.setRankForNewLocation(index + 1);
                                },
                              ),
                            )
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                mapStore.addNewLocation();
                              },
                              icon: Icon(Icons.add),
                              label: Text(S.current.saveLocation),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
