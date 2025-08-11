import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decode(String token) {
    // JWT format: header.payload.signature
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException("Invalid token format");
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      throw const FormatException("Invalid payload");
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw const FormatException("Invalid base64url string");
    }

    return utf8.decode(base64Url.decode(output));
  }
}
