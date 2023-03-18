
import 'fox_http_platform_interface.dart';

class FoxHttp {
  Future<String?> getPlatformVersion() {
    return FoxHttpPlatform.instance.getPlatformVersion();
  }
}
