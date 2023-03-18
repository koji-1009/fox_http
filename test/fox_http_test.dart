import 'package:flutter_test/flutter_test.dart';
import 'package:fox_http/fox_http.dart';
import 'package:fox_http/fox_http_platform_interface.dart';
import 'package:fox_http/fox_http_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFoxHttpPlatform
    with MockPlatformInterfaceMixin
    implements FoxHttpPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FoxHttpPlatform initialPlatform = FoxHttpPlatform.instance;

  test('$MethodChannelFoxHttp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFoxHttp>());
  });

  test('getPlatformVersion', () async {
    FoxHttp foxHttpPlugin = FoxHttp();
    MockFoxHttpPlatform fakePlatform = MockFoxHttpPlatform();
    FoxHttpPlatform.instance = fakePlatform;

    expect(await foxHttpPlugin.getPlatformVersion(), '42');
  });
}
