// import 'package:fijkplayer/fijkplayer.dart';

class VideoPlayerService {
  VideoPlayerService() {
    init();
  }

  Future<void> init() async {}
  // final FijkPlayer player = FijkPlayer();

  void setUrl({required String source}) {
    stopPlay();
    // player.setDataSource(source, autoPlay: true);
  }

  void stopPlay() {
    // player.stop();
  }
}
