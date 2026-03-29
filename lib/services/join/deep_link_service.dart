import '../../models/session.dart';
import 'join_service.dart';

class DeepLinkService {
  static String buildLink(Session session) {
    return JoinService.buildDeepLink(session);
  }

  static Session? parseLink(String url) {
    try {
      final uri = Uri.parse(url);
      return JoinService.parseDeepLink(uri);
    } catch (_) {
      return null;
    }
  }
}
