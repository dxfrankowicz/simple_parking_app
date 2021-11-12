import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_parking_app/components/base_scaffold.dart';
import 'package:simple_parking_app/generated/l10n.dart';
import 'package:simple_parking_app/models/parking_location.dart';
import 'package:simple_parking_app/pages/map/map_store.dart';
import 'package:simple_parking_app/utils/buttons/rounded_loading_button.dart';
import 'package:simple_parking_app/utils/di/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_parking_app/utils/firestore/firestore_service.dart';
import 'package:simple_parking_app/utils/log/log.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  MapStore mapStore = getIt<MapStore>();

  double bottomModalHeight = 0;
  double infoViewHeight = 80;

  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((value) => bottomModalHeight = MediaQuery.of(context).size.height / 8);
    mapStore.getLocationAndInit();
    _disposers.add(reaction((_) => mapStore.addNewLocationStatus, (status) {
      if (status == LoadingState.success) {
        _btnController.success();
      } else if (status == LoadingState.error) {
        _btnController.error();
        Future.delayed(Duration(seconds: 1)).then((value) => _btnController.reset());
      }
    }));
    _disposers.add(reaction((_)=> mapStore.addLocationView, (x){
      setState(() {
        if (mapStore.addLocationView)
          bottomModalHeight = MediaQuery.of(context).size.height / 2.25;
        else
          bottomModalHeight = MediaQuery.of(context).size.height / 8;
      });
    }));
    super.initState();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_){
        return PARKINGScaffold.get(
          context,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: FirestoreService.getStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    mapStore.updateMarkers(snapshot.data!.docs, _customInfoWindowController,
                            (parkingLocationModel) {
                          setState(() {
                            createInfoView(parkingLocationModel, context);
                          });
                        });
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
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow!();
                        },
                        onMapCreated: (GoogleMapController controller) {
                          mapStore.controller.complete(controller);
                          _customInfoWindowController.googleMapController = controller;
                        },
                        onCameraMove: (CameraPosition position) {
                          mapStore.updateAddLocationMarker(position);
                          _customInfoWindowController.onCameraMove!();
                        },
                      );
                    },
                  );
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: infoViewHeight,
                width: 200,
                offset: 50,
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
                      mapStore.switchAddLocationView();
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
      },
    );
  }

  void createInfoView(ParkingLocationModel parkingLocationModel, BuildContext context) {
    _customInfoWindowController.addInfoWindow!(
      Container(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3)
                  ],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            child: Icon(
                              (parkingLocationModel.ranking ?? 0) >= index + 1
                                  ? Icons.star
                                  : Icons.star_border_rounded,
                              color: (parkingLocationModel.ranking ?? 0) >= index + 1
                                  ? Colors.amber
                                  : Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          parkingLocationModel.name ?? S.current.noData,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          parkingLocationModel.description ?? S.current.noData,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Triangle.isosceles(
              edge: Edge.BOTTOM,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: 20.0,
                height: 10.0,
              ),
            ),
          ],
        ),
      ),
      LatLng(parkingLocationModel.geolocation!.latitude,
          parkingLocationModel.geolocation!.longitude),
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
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                errorText: mapStore.addLocationNameEmpty
                                    ? S.current.newLocationValidationEmptyName
                                    : null,
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
                                      (mapStore.addLocationModel.ranking ?? 0) >=
                                              index + 1
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
                              )),
                          Observer(
                            builder: (_) => RoundedLoadingButton(
                              child: Text(S.of(context).saveLocation,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: Colors.white)),
                              controller: _btnController,
                              height: 50,
                              color: Theme.of(context).appBarTheme.backgroundColor,
                              width: MediaQuery.of(context).size.width,
                              onPressed: () {
                                mapStore.addNewLocation();
                              },
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
