import 'package:google_maps_webservice/distance.dart';
void main() {
  Element element = Element(distance: Value(value: 1, text: ""), duration: Value(value: 1, text: ""), status: "OK", durationInTraffic: Value(value: 1, text: ""), fare: Fare(value: 1, currency: "", text: ""));
  print(element.distance);
}
