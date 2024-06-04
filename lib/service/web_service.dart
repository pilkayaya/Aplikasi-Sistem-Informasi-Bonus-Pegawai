import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uas_pm/model/bonus_model.dart';
import 'package:uas_pm/response/bonus_response.dart';

class WebService {
  final Dio _dio = Dio();

  Future<List<BonusModel>> fetchData() async {
    try {
      Response response =
          await _dio.get('http://192.168.100.4/uas_mobile/data.php');
      print(response.data);
      if (response.statusCode == 200) {
        return BonusResponse.fromJson(response.data).data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  Future<List<BonusModel>> search(String keyword) async {
    _dio.options
      ..baseUrl = 'http://192.168.100.4/uas_mobile'
      ..connectTimeout = Duration(seconds: 10000000) //5s
      ..receiveTimeout = Duration(seconds: 10000000)
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      print(keyword);

      final response = await _dio.get(
        '/search.php?keyword=$keyword',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data search successfully: ${response.data}');
        return BonusResponse.fromJson(response.data).data;
      } else {
        throw Exception('Failed to search data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to search data: $error');
    }
  }

  Future<void> createData(BonusModel bonusModel) async {
    _dio.options
      ..baseUrl = 'http://192.168.100.4/uas_mobile'
      ..connectTimeout = Duration(seconds: 10000000) //5s
      ..receiveTimeout = Duration(seconds: 10000000)
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      print({
        'nama_pegawai': bonusModel.namaPegawai,
        'jumlah_absen': bonusModel.jumlahAbsen,
        'jumlah_terlambat': bonusModel.jumlahTerlambat,
        'jumlah_lembur': bonusModel.jumlahLembur,
        'jumlah_gaji': bonusModel.jumlahGaji,
        'bonus_total': bonusModel.bonusTotal < 0 ? 0 : bonusModel.bonusTotal,
      });

      final response = await _dio.post(
        '/create.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'nama_pegawai': bonusModel.namaPegawai,
          'jumlah_absen': bonusModel.jumlahAbsen,
          'jumlah_terlambat': bonusModel.jumlahTerlambat,
          'jumlah_lembur': bonusModel.jumlahLembur,
          'jumlah_gaji': bonusModel.jumlahGaji,
          'bonus_total': bonusModel.bonusTotal < 0 ? 0 : bonusModel.bonusTotal,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to create data: $error');
    }
  }

  Future<void> updateData(int idPegawai, BonusModel bonusModel) async {
    _dio.options
      ..baseUrl = 'http://192.168.100.4/uas_mobile'
      ..connectTimeout = Duration(seconds: 10000000) //5s
      ..receiveTimeout = Duration(seconds: 10000000)
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      print({
        'id_pegawai': idPegawai,
        'nama_pegawai': bonusModel.namaPegawai,
        'jumlah_absen': bonusModel.jumlahAbsen,
        'jumlah_terlambat': bonusModel.jumlahTerlambat,
        'jumlah_lembur': bonusModel.jumlahLembur,
        'jumlah_gaji': bonusModel.jumlahGaji,
        'bonus_total': bonusModel.bonusTotal < 0 ? 0 : bonusModel.bonusTotal,
      });

      final response = await _dio.post(
        '/update.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'id_pegawai': idPegawai,
          'nama_pegawai': bonusModel.namaPegawai,
          'jumlah_absen': bonusModel.jumlahAbsen,
          'jumlah_terlambat': bonusModel.jumlahTerlambat,
          'jumlah_lembur': bonusModel.jumlahLembur,
          'jumlah_gaji': bonusModel.jumlahGaji,
          'bonus_total': bonusModel.bonusTotal < 0 ? 0 : bonusModel.bonusTotal,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data updated successfully: ${response.data}');
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update data: $error');
    }
  }

  Future<void> deleteData(int idPegawai) async {
    _dio.options
      ..baseUrl = 'http://192.168.100.4/uas_mobile'
      ..connectTimeout = Duration(seconds: 10000000) //5s
      ..receiveTimeout = Duration(seconds: 10000000)
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      print(idPegawai);

      final response = await _dio.post(
        '/delete.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'id_pegawai': idPegawai,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data deleted successfully: ${response.data}');
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete data: $error');
    }
  }
}
