import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/data_handler/app_data.dart';
import 'package:uber_clone/helpers/helper_methods.dart';
import 'package:uber_clone/screens/search_screen.dart';
import 'package:uber_clone/widgets/divider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Static initializations
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMApController;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  //var geolocator = Geolocator();
  double bottomPaddingOfMap = 0.0;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlangPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlangPosition, zoom: 13);
    newGoogleMApController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await HelperMethods.searchCoordinateAddress(position, context);
    print("Address is: " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SafeArea(
          child: Container(
            width: 255.0,
            child: Drawer(
              child: ListView(
                children: [
                  Container(
                    height: 150.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white54,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/user_icon.png",
                            height: 75.0,
                            width: 75.0,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profile Name",
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: "Brand-Bold"),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text("example@mail.com"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      "History",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "View Profile",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      "About",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController.complete(controller);
                newGoogleMApController = controller;
                setState(() {
                  bottomPaddingOfMap = 300.0;
                });
                locatePosition();
              },
            ),
            // Hamburger icon for drawer
            Positioned(
              top: 22.0,
              left: 22.0,
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 1.0,
                            spreadRadius: 0.1,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu,
                      size: 26.0,
                    ),
                    radius: 23.0,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text("Hi there", style: TextStyle(fontSize: 12.0)),
                      Text("Where to? ",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "Brand-Bold")),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.0, 0.7))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Search drop off location",
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickupLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickupLocation
                                        .placeName
                                    : "Add Home",
                                style: TextStyle(fontFamily: "Brand-Bold"),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Your living address",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomDivider(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add Work",
                                style: TextStyle(fontFamily: "Brand-Bold"),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Your ofice address",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
