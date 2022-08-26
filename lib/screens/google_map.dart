import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_bus/screens/logic/location_functions.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  double? lat, lng;
  var direction;
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(10.979033742960649, 76.20805271623797), zoom: 17.0);

  Set<Marker> _markers = {};

  @override
  void initState() {
    CheckInternet(context);
    getData();
    Timer.periodic(const Duration(seconds: 20), (timer) {
      debugPrint(timer.tick.toString());
      getData();
      BusLocationupdate();
    });
    setCustomMapPin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: initialCameraPosition,
            markers: _markers,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          // buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  // Button for track bus
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 255, 174, 0),
                          Color.fromARGB(255, 255, 238, 0)
                        ]),
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34.0),
                            ),
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Track Bus',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              BusLocation();
                            });
                          }),
                    ),
                  ),
                ),
                // user location button
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: RawMaterialButton(
                      elevation: 3,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: const CircleBorder(),
                      constraints: const BoxConstraints.tightFor(
                        width: 53.0,
                        height: 53.0,
                      ),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        setState(() {
                          CurrentLocation();
                          CheckLocationIsOff();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//=== Fetching Data From Server ===
  Future<ServerData> getData() async {
    Uri url = Uri.https('548ebd.deta.dev', '/location/last');
    http.Response response = await http.get(url);
    ServerData serverData = ServerData.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        lat = serverData.latBus;
        lng = serverData.lngBus;
        direction = serverData.direction;
      });
      return ServerData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('==Failed to load Data from Deta Server ==');
    }
  }

// function for track bus location
  void BusLocation() {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 17.0,
        ),
      ),
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("busLocation"),
          position: LatLng(lat!, lng!),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(title: "College Bus"),
        ),
      );
    });
  }

  // update bus location with out camera  move
  void BusLocationupdate() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("busLocation"),
          position: LatLng(lat!, lng!),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(title: "College Bus"),
        ),
      );
    });
  }

  // == function for track Current location ==
  Future<void> CurrentLocation() async {
    Position position = await determinePosition();

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ),
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
          alpha: 0,
        ),
      );
    });
  }
}
