import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/config_maps.dart';
import 'package:uber_clone/data_handler/app_data.dart';
import 'package:uber_clone/helpers/request_helper.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String placeAdderss =
        Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickupController.text = placeAdderss;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Set Drop Off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffController,
                              decoration: InputDecoration(
                                  hintText: "Where To",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0)),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapApiKey2&sessiontoken=1234567890&components=country:bd";
      var res = await RequestHelper.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      } else {
        print("Res: ");
        print(res);
      }
    }
  }
}
