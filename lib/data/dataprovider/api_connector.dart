import 'package:http/http.dart' as http;

class APIConnector {
  static Future<Object> getMethodCall({
    required String url,
  }) async {
    late Object object;
    try {
      var resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        object = APISuccess(resp.body);
      } else if (resp.statusCode == 400) {
        object = APIFailure(resp.body, statusCode: 400);
      } else {
        object = APIFailure(resp.body);
      }
    } on http.ClientException catch (e) {
      object = APIFailure("No Internet connected!", statusCode: 100);
    } catch (e) {
      object = APIFailure("Some thing went wrong $e");
    }
    return object;
  }
}

class APISuccess {
  final Object object;
  APISuccess(this.object);
}

class APIFailure {
  final Object object;
  final int? statusCode;
  APIFailure(this.object, {this.statusCode});
}
