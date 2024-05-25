// import 'dart:convert';
// import 'package:equb_v3_frontend/models/equb/equb.dart';
// import 'package:http/http.dart' as http;

// class EqubApiService {
//   final String baseUrl;

//   EqubApiService({required this.baseUrl});

//   Future<List<Equb>> getEqub() async {
//     final response = await http.get(Uri.parse('$baseUrl/equb/'));
//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<Equb> equbs =
//           body.map((dynamic item) => Equb.fromJson(item)).toList();
//       return equbs;
//     } else {
//       throw Exception('Failed to load Equbs');
//     }
//   }

//   // GET request
//   Future<List<Equb>> getEqubs() async {
//     final response = await http.get(Uri.parse('$baseUrl/equbs/'));
//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<Equb> equbs =
//           body.map((dynamic item) => Equb.fromJson(item)).toList();
//       return equbs;
//     } else {
//       throw Exception('Failed to load Equbs');
//     }
//   }

//   // POST request
//   Future<Equb> createEqub(Equb equb) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/equbs/'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(equb.toJson()),
//     );
//     if (response.statusCode == 201) {
//       return Equb.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to create Equb');
//     }
//   }

//   // PUT request
//   Future<Equb> updateEqub(int id, Equb equb) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/equbs/$id/'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(equb.toJson()),
//     );
//     if (response.statusCode == 200) {
//       return Equb.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to update Equb');
//     }
//   }
// }
