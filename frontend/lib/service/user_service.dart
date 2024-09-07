import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> register(
   String email,
    String firstName,
    String lastName,
    String userType,
    String password,
    String phoneNumber,
    String vehicleNumber,
    bool availability) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> registerData = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "user_type": userType,
      "password": password,
    };

    if (userType == "driver") {
      registerData['driver_profile'] = {
        "phone_number": phoneNumber,
        "vehicle_number": vehicleNumber,
        "availability": availability
      };
    }
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/auth/register/"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(registerData));

    if (response.statusCode == 201) {
      apiResponse.data = User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      String errorMessage = _parseErrorMessages(responseBody);
      apiResponse.error = errorMessage;
    } else if (response.statusCode == 401) {
      apiResponse.error = jsonDecode(response.body)['detail'].toString();
    } else {
      apiResponse.error = "Something went wrong";
    }
  } catch (e) {
    apiResponse.error = "Server error";
  }
  return apiResponse;
}

Future<ApiResponse> verifyOtp(String otp) async {
  ApiResponse apiResponse = ApiResponse();
  final response = await http.post(
    Uri.parse("http://10.0.2.2:8000/api/auth/verify/"),
    headers: {"Accept": 'application/json', "Content-Type": 'application/json'},
    body: jsonEncode({"otp": otp}),
  );

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      apiResponse.data = jsonDecode(response.body)['message'];
    } else {
      apiResponse.error = "Empty response body";
    }
  } else if (response.statusCode == 400) {
    apiResponse.error = jsonDecode(response.body)['message'].toString();
  } else {
    apiResponse.error = "Server error: ${response.statusCode}";
  }

  return apiResponse;
}

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  final resposne = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/auth/token/"),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password});

  if (resposne.statusCode == 200) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = jsonDecode(resposne.body);
    await preferences.setString("access_token", data['access']);
    await preferences.setString("refresh_token", data['refresh']);
    Map<String, dynamic> decodedData = JwtDecoder.decode(data['access']);
    apiResponse.data = decodedData;
  } else if (resposne.statusCode == 401) {
    apiResponse.error = jsonDecode(resposne.body)['detail'].toString();
  } else {
    apiResponse.error = "Something went wrong";
  }
  return apiResponse;
}

Future<void> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove("access_token");
  preferences.remove("refresh_token");
}

Future<String?> refresh() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final refreshToken = preferences.getString("refresh_token");
  final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/auth/refresh/"),
      body: {"refresh": refreshToken},
      headers: {'Accept': "application/json"});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await preferences.setString('access_token', data['access']);
    return null; // Success
  } else {
    return 'Failed to refresh token';
  }
}

String _parseErrorMessages(Map<String, dynamic> errors) {
  StringBuffer errorMessage = StringBuffer();
  errors.forEach((field, messages) {
    if (messages is List) {
      for (var message in messages) {
        errorMessage.writeln('$field: $message');
      }
    }
  });
  return errorMessage.toString();
}

Future<ApiResponse> getUserDetails() async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final accessToken = preferences.getString("access_token");
  try {
    final response = await http
        .get(Uri.parse("http://10.0.2.2:8000/api/auth/user/"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = "Unthorized User";
        break;
      default:
        apiResponse.error = "Something went wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = "SERVER ERROR";
  }
  return apiResponse;
}

Future<bool> hasOpenedApp() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('hasOpenedApp') ?? false;
}

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("token") ?? "";
}
