import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fox_http_platform_interface.dart';

/// An implementation of [FoxHttpPlatform] that uses method channels.
class MethodChannelFoxHttp extends FoxHttpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fox_http');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
