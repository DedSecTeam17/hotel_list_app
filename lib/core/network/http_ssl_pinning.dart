import 'dart:io';
import 'package:http/io_client.dart';

class HttpSslPinning {
  static IOClient createPinnedClient() {
    final securityContext = SecurityContext(withTrustedRoots: true);

    HttpClient client = HttpClient(context: securityContext)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Real SSL Pinning here later
        return true;
      };
    return IOClient(client);
  }
}
