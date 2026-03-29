enum JoinMethod {
  qr,
  nfc,
  deeplink;

  String get label {
    switch (this) {
      case JoinMethod.qr:
        return 'QR';
      case JoinMethod.nfc:
        return 'NFC';
      case JoinMethod.deeplink:
        return 'Link';
    }
  }
}
