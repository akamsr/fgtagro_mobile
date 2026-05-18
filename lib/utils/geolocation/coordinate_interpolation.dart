import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void animateMarkerTo({
  required AnimationController controller,
  required LatLng from,
  required LatLng to,
  required void Function(LatLng) onUpdate,
}) {
  final latTween = Tween<double>(begin: from.latitude, end: to.latitude);
  final lngTween = Tween<double>(begin: from.longitude, end: to.longitude);

  controller.reset();
  controller.addListener(() {
    onUpdate(LatLng(
      latTween.evaluate(controller),
      lngTween.evaluate(controller),
    ));
  });
  controller.forward();
}
