import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/config_maps.dart';
import 'package:uber_clone/data_handler/app_data.dart';
import 'package:uber_clone/helpers/request_helper.dart';
import 'package:uber_clone/models/address.dart';

class HelperMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey2";

    var response = await RequestHelper.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];
      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickupAddress = new Address();
      userPickupAddress.lat = position.latitude;
      userPickupAddress.lng = position.longitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(userPickupAddress);
    }

    return placeAddress;
  }
}
