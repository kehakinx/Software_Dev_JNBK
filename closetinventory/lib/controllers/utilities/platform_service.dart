import 'dart:io' show Platform;

class PlatformService {
  PlatformService._privateConstructor();

  static final PlatformService instance = PlatformService._privateConstructor();

  bool get isNonWeb => !identical(0, 0.0) && !isWeb;

  bool get isWeb => identical(0, 0.0);

  bool kisWeb() {
    return isWeb;
  }
}
