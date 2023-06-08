import 'package:http/http.dart' as http;
import 'dart:convert';

class MlService {
  Future predict(
      String age,
      String sex,
      String bp,
      String cholestrol,
      String wbcc,
      String rbcc,
      String glucose,
      String insulin,
      String bmi) async {
    final url = Uri.parse('http://194f-35-230-57-199.ngrok-free.app');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "age": age,
        "sex": sex,
        "bp": bp,
        "cholesterol": cholestrol,
        "wbcc": wbcc,
        "rbcc": rbcc,
        "glucose": glucose,
        "insulin": insulin,
        "bmi": bmi,
      }),
    );
    print(response.body);
    var responses = jsonDecode(response.body);
    print("RESPONSES");
    print(responses);
    print(responses.runtimeType);
    return responses;
  }
}
