enum ConnectionStatus {
  idle,
  connecting,
  connected,
  reconnecting,
  disconnected;

  bool get isActive =>
      this == ConnectionStatus.connected ||
      this == ConnectionStatus.reconnecting;
}
