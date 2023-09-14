import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class DeviceUtils {


  /// Return a fraction of screen width
  static double fractionWidth(BuildContext context, {double fraction = 1.0}) {
    assert(fraction > 0.0);

    return MediaQuery.of(context).size.width / fraction;
  }

  /// Return a fraction of screen height
  static double fractionHeight(BuildContext context, {double fraction = 1.0}) {
    assert(fraction > 0.0);

    return MediaQuery.of(context).size.height / fraction;
  }

  /// Increment screen width by a factor
  static double factorWidth(BuildContext context, {double factor = 1.0}) {
    return MediaQuery.of(context).size.width * factor;
  }

  /// Increment screen height by a factor
  static double factorHeight(BuildContext context, {double factor = 1.0}) {
    return MediaQuery.of(context).size.height * factor;
  }
}
