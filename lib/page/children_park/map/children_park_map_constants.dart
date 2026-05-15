import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class ChildrenParkMapConstants {
  static const LatLng parkCenter = LatLng(25.0974, 121.5151);

  static final LatLngBounds parkBounds = LatLngBounds(
    southwest: const LatLng(25.09635, 121.51410),
    northeast: const LatLng(25.09845, 121.51620),
  );

  static final LatLngBounds overlayBounds = LatLngBounds(
    southwest: const LatLng(25.0962398, 121.5135708),
    northeast: const LatLng(25.0983576, 121.5166168),
  );

  static const double minZoom = 16;
  static const double initialZoom = 18;
  static const double facilityFocusZoom = 20;
  static const double clusterZoomInStep = 2;
  static const double clusterMaxZoom = 17.6;

  static const String overlayAsset = 'assets/children_park/map/map-overlay.png';

  static const List<String> heightFilterOptions = [
    '幼童友善（未滿 90cm）',
    '小學門檻（90cm-110cm）',
    '刺激挑戰（110cm 以上）',
  ];

  static const List<String> thrillFilterOptions = ['溫和型', '中度刺激', '高刺激'];
  static const List<String> environmentFilterOptions = ['露天', '頂棚區'];
  static const List<String> priceFilterOptions = [
    '🎠 基礎遊具（20～30 元）',
    '⭐ 委外精選設施（50～80 元）',
  ];
  static const List<String> specialFilterOptions = [
    '🤰 孕婦可搭乘',
    '♿ 無障礙標示',
    '❄️ 冷氣開放',
  ];
}
