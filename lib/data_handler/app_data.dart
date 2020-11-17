import 'package:flutter/cupertino.dart';
import 'package:uber_clone/models/address.dart';

class AppData extends ChangeNotifier {
  Address pickupLocation;

  void updatePickupAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }
}
