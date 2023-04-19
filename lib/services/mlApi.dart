import 'package:http/http.dart' as http;
import 'dart:convert';

class MlService {
  Future predict() async {
    final url = Uri.parse('http://39cf-34-90-223-75.ngrok-free.app');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "age": "48",
        "sex": "1",
        "bp": "98",
        "cholesterol": "212",
        "wbcc": "7900",
        "rbcc": "3.9",
        "glucose": "129",
        "insulin": "94",
        "bmi": "35.2"
      }),
    );
    print(response.body);
    return response;
  }
}
