import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marine_watch/utils/image_utils.dart';

// coverage:ignore-file
class BitmapManager {
  BitmapDescriptor? svgMapPin;
  BitmapDescriptor? pngMapPin;

  //TODO: Look into moving this to a diferent thread
  void init(BuildContext context) {
    Future.wait([
      _bitmapDescriptorFromPngAsset(context, ImageUtils.pngMapPin)
          .then((value) => pngMapPin = value),
      _bitmapDescriptorFromSvgAsset(context, ImageUtils.svgMapPin)
          .then((value) => svgMapPin = value),
    ]);
  }

  //TODO: Markers are too slow to load sometimes, related to
  // https://github.com/flutter/flutter/issues/41731
  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    final svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    final svgDrawableRoot = await svg.fromSvgString(svgString, assetName);

    final queryData = MediaQuery.of(context);
    final devicePixelRatio = queryData.devicePixelRatio;
    final width = 35 * devicePixelRatio;
    final height = 50 * devicePixelRatio;

    // ignore: omit_local_variable_types
    final ui.Picture picture =
        svgDrawableRoot.toPicture(size: Size(width, height));

    // ignore: omit_local_variable_types
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromPngAsset(
      BuildContext context, String assetName) async {
    final imageConfiguration =
        createLocalImageConfiguration(context, size: const Size.square(48));
    return BitmapDescriptor.fromAssetImage(imageConfiguration, assetName);
  }
}
