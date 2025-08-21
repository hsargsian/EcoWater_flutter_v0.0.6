import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> onShare(String text) async {
    await Share.share(text);
  }
}
