import 'dart:math';

class FakeApi {
  FakeApi._();

  static bool instantMode = false;
  static final _random = Random();

  /// Simulates realistic network delay (400 - 1000 ms)
  static Future<void> delay([int? minMs, int? maxMs]) async {
    if (instantMode) return;
    final min = minMs ?? 400;
    final max = maxMs ?? 950;
    final ms = min + _random.nextInt(max - min + 1);
    await Future.delayed(Duration(milliseconds: ms));
  }
}
