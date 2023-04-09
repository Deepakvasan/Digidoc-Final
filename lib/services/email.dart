import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailService {
  Future sendEmail(
      {required String name,
      required String clinicName,
      required String email,
      required String password}) async {
    const service_id = 'service_3t6gd5f';
    const template_id = 'template_hesyvbs';
    const user_id = 'EFUdUMd6fMGMX_JXY';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': service_id,
        'template_id': template_id,
        'user_id': user_id,
        'template_params': {
          'to_name': name,
          'clinic_name': clinicName,
          'email_to': email,
          'doctor_email': email,
          'doctor_password': password,
        }
      }),
    );
    print(response.body);
    return response;
  }
}
