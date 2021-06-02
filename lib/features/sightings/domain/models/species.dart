import 'package:marine_watch/core/utils/enum.dart';
import 'package:marine_watch/core/utils/image_utils.dart';

class Species extends Enum {
  const Species._internal(String value) : super.internal(value);

  factory Species(String raw) => values.firstWhere(
        (val) => val.value == raw,
        orElse: () => none,
      );

  static const orca = Species._internal('orca');
  static const minke = Species._internal('minke');
  static const grayWhale = Species._internal('gray whale');
  static const humpback = Species._internal('humpback');
  static const atlanticWhiteSidedDolphin =
      Species._internal('atlantic white-sided dolphin');
  static const pacificWhiteSidedDolphin =
      Species._internal('pacific white-sided dolphin');
  static const dallsPorpoise = Species._internal('dalls porpoise');
  static const harborPorpoise = Species._internal('harbor porpoise');
  static const harborSeal = Species._internal('harbor seal');
  static const northernElephantSeal =
      Species._internal('northern elephant seal');
  static const southernElephantSeal =
      Species._internal('southern elephant seal');
  static const californiaSeaLion = Species._internal('california sea Lion');
  static const stellerSeaLion = Species._internal('steller sea lion');
  static const seaOtter = Species._internal('sea otter');
  static const other = Species._internal('other');
  static const unknown = Species._internal('unknown');
  static const none = Species._internal('');

  // coverage:ignore-start
  String get image {
    if (value == orca.value) {
      return ImageUtils.orca;
    } else if (value == minke.value) {
      return ImageUtils.minke;
    } else if (value == grayWhale.value) {
      return ImageUtils.grayWhale;
    } else if (value == humpback.value) {
      return ImageUtils.humpback;
    } else if (value == atlanticWhiteSidedDolphin.value) {
      return ImageUtils.atlanticWhiteSided;
    } else if (value == pacificWhiteSidedDolphin.value) {
      return ImageUtils.pacificWhitesidedDolphins;
    } else if (value == dallsPorpoise.value) {
      return ImageUtils.dallsPorpoise;
    } else if (value == harborPorpoise.value) {
      return ImageUtils.harborPorpoise;
    } else if (value == harborSeal.value) {
      return ImageUtils.harborSeal;
    } else if (value == northernElephantSeal.value) {
      return ImageUtils.northernElephantSeal;
    } else if (value == southernElephantSeal.value) {
      return ImageUtils.southernElephantSeal;
    } else if (value == californiaSeaLion.value) {
      return ImageUtils.californiaSeaLion;
    } else if (value == stellerSeaLion.value) {
      return ImageUtils.stellerSeaLion;
    } else if (value == seaOtter.value) {
      return ImageUtils.seaOtter;
    } else {
      return '';
    }
  }
  // coverage:ignore-end

  static const List<Species> values = [
    orca,
    minke,
    grayWhale,
    humpback,
    atlanticWhiteSidedDolphin,
    pacificWhiteSidedDolphin,
    dallsPorpoise,
    harborPorpoise,
    harborSeal,
    northernElephantSeal,
    southernElephantSeal,
    californiaSeaLion,
    stellerSeaLion,
    seaOtter,
    other,
    unknown,
  ];
}
