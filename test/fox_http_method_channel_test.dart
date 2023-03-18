import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_http/fox_http_method_channel.dart';

void main() {
  MethodChannelFoxHttp platform = MethodChannelFoxHttp();
  const MethodChannel channel = MethodChannel('fox_http');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
