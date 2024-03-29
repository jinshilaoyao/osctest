import 'dart:async';
import 'package:http/http.dart' as http;

class NetUtils {
  static Future<String> get(String url, {Map<String, String> params}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });

      String paramStr = sb.toString();

      paramStr = paramStr.substring(0, paramStr.length - 1);

      url += paramStr;
    }
    http.Response res = await http.get(url, headers: getCommondHeader());
    return res.body;
  }

    static Future<String> post(String url, {Map<String, String> params}) async {
    http.Response res = await http.post(url, body: params, headers: getCommondHeader());
    return res.body;
  }

  static Map<String, String> getCommondHeader() {
    Map<String, String> header = Map();
    header['is_flutter_osc'] = "1";
    return header;
  }
}
