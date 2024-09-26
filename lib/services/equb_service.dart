import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

class EqubService {
  final String baseUrl;
  final Dio dio;

  EqubService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> getEqubDetail(int id) async {
    final response = await dio.get('$baseUrl/equbs/$id');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load Equbs');
    }
  }

  Future<List<dynamic>> getEqubs(EqubType type) async {
    Response response;
    if (type == EqubType.active) {
      response = await dio.get('$baseUrl/equbs/activeequbs/');
    } else if (type == EqubType.pending) {
      response = await dio.get('$baseUrl/equbs/pendingequbs/');
    } else if (type == EqubType.past) {
      response = await dio.get('$baseUrl/equbs/pastequbs/');
    } else if (type == EqubType.invites) {
      response = await dio.get('$baseUrl/equbs/invitedequbs/');
    } else if (type == EqubType.recommended) {
      response = await dio.get('$baseUrl/equbs/recommendedequbs/');
    } else {
      response = await dio.get('$baseUrl/equbs/');
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load Equbs');
    }
  }

  Future<Map<String, dynamic>> createEqub(EqubCreationDTO equb) async {
    final response = await dio.post(
      '$baseUrl/equbs/',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: jsonEncode(equb.toJson()),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to create Equb');
    }
  }

  Future<Map<String, dynamic>> updateEqub(int id, Equb equb) async {
    final response = await dio.put(
      '$baseUrl/equbs/$id/',
      data: jsonEncode(equb.toJson()),
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to update Equb');
    }
  }

  Future<Map<String, dynamic>> placeBid(int id, double bidAmount) async {
    
    final response = await dio.post(
      '$baseUrl/bids/',
      data: {
        'equb': '$baseUrl/equbs/$id/',
        'amount': bidAmount.toStringAsFixed(3)
      },
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    if (response.statusCode == 201) {
      return getEqubDetail(id);
    }  else {
      throw Exception('Failed to place bids for equb $id');
    }
  }
}
