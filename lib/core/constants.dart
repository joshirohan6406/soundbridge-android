class SBConstants {
  static const int audioPort = 5555;
  static const int controlPort = 5556;
  static const int httpPort = 5557;

  static const int sampleRate = 48000;
  static const int frameSizeMs = 20;
  static const int stereoChannels = 2;
  static const int monoChannels = 1;
  static const int bitrateStereo = 64000;
  static const int bitrateMono = 48000;

  static const int bufferMovie = 200;
  static const int bufferMusic = 120;
  static const int bufferGaming = 60;

  static const String appId = 'soundbridge';
  static const String protocolVersion = '1';
  static const String deepLinkScheme = 'soundbridge';

  static const int pingIntervalSeconds = 2;
  static const int pongTimeoutSeconds = 6;

  static const String msgJoinConfirm = 'JOIN_CONFIRM';
  static const String msgJoinAck = 'JOIN_ACK';
  static const String msgJoinReject = 'JOIN_REJECT';
  static const String msgDeviceJoined = 'DEVICE_JOINED';
  static const String msgDeviceLeft = 'DEVICE_LEFT';
  static const String msgModeChange = 'MODE_CHANGE';
  static const String msgResync = 'RESYNC';
  static const String msgSetVolume = 'SET_VOLUME';
  static const String msgSetDelay = 'SET_DELAY';
  static const String msgLatencyReport = 'LATENCY_REPORT';
  static const String msgSessionEnd = 'SESSION_END';
  static const String msgNfcStatus = 'NFC_STATUS';
  static const String msgPing = 'PING';
  static const String msgPong = 'PONG';
}
