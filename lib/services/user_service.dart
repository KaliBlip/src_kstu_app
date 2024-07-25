import 'dart:convert';
import 'package:src_kstu_app/models/api_response.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginUrl),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> register(String email, String password, String name,
    String gender, String indexNumber) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      'email': email,
      'password': password,
      'password_confirmation': password,
      'name': name,
      'gender': gender,
      'index_no': indexNumber,
      'status': 1,
      'user_img': "config.png",
      'program_id': 3,
      'dept_id': 2,
      'yr_of_admission': "2022",
      'yr_of_completion': "2024",
    });
    switch (response.statusCode) {
      case 201:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getUserDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentwrong;
        break;
    }
  } catch (e) {
    // apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<bool> hasOpenedApp() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("hasOpended") ?? false;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("token") ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('id') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

Future<ApiResponse> forgotPassword(String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(forgotPasswordUrl),
        headers: {'Accept': 'application/json'}, body: {'email': email});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }
  return apiResponse;
}

Future<http.StreamedResponse> updateUserProfile(String pickedImagePath) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var request = http.MultipartRequest('POST', Uri.parse(updateDpUrl));
    request.files
        .add(await http.MultipartFile.fromPath('user_img', pickedImagePath));
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-type': 'multipart/form-data',
    });
    var response = await request.send();
    return response;
  } catch (e) {
    apiResponse.error = e.toString();
    throw apiResponse;
  }
}

Future<ApiResponse> updatePassword(
    String oldPassword, String password, String confirmPassword) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(updatePasswordUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'old_pass': oldPassword,
      'password': password,
      'password_confirmation': confirmPassword
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }
  return apiResponse;
}