import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:tracking_bus/screens/offline_screen.dart';

class ServerData {
  final double? latBus;
  final double? lngBus;
  final String? direction;

  const ServerData({
    this.latBus,
    this.lngBus,
    this.direction,
  });

  factory ServerData.fromJson(Map<String, dynamic> json) {
    return ServerData(
      latBus: json['lat'],
      lngBus: json['lng'],
      direction: json['direction'],
    );
  }
}

// getting user permission for location
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error("=====< Locaton Service is disabled >======");
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location Permission is Denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location Permission Is denied permenanetly");
  }

  Position position = await Geolocator.getCurrentPosition();
  return position;
}

// === check Location is off ====
void CheckLocationIsOff() async {
  Location location = new Location();
  bool ison = await location.serviceEnabled();
  if (!ison) {
    //if defvice is off
    bool isturnedon = await location.requestService();
  }
}

//  ==== check internet connection ====
void CheckInternet(BuildContext context) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == false) {
    // print('YAY! Free cute dog pics!');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OfflineScreen()));
  }
}

//Change map icon = = Bus location Icon
late BitmapDescriptor pinLocationIcon;
void setCustomMapPin() async {
  pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/mapin.png');
}
