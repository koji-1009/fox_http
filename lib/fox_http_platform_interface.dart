import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fox_http_method_channel.dart';

abstract class FoxHttpPlatform extends PlatformInterface {
  /// Constructs a FoxHttpPlatform.
  FoxHttpPlatform() : super(token: _token);

  static final Object _token = Object();

  static FoxHttpPlatform _instance = MethodChannelFoxHttp();

  /// The default instance of [FoxHttpPlatform] to use.
  ///
  /// Defaults to [MethodChannelFoxHttp].
  static FoxHttpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FoxHttpPlatform] when
  /// they register themselves.
  static set instance(FoxHttpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
