import 'dart:io';
import 'package:dio/dio.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';

abstract class EkycRemoteDataSource {
  Future<VerificationEntity> getMyVerification();
  Future<VerificationEntity> submitVerification({
    required String nationalId,
    required File nationalIdFront,
    required File nationalIdBack,
    required File selfie,
  });
}

class EkycRemoteDataSourceImpl implements EkycRemoteDataSource {
  final DioClient client;

  EkycRemoteDataSourceImpl(this.client);

  @override
  Future<VerificationEntity> getMyVerification() async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.ekycStatus,
      forceRefresh: true,
    );
    return VerificationEntity.fromJson(response.data ?? {});
  }

  @override
  Future<VerificationEntity> submitVerification({
    required String nationalId,
    required File nationalIdFront,
    required File nationalIdBack,
    required File selfie,
  }) async {
    final formData = FormData.fromMap({
      'nationalId': nationalId.trim(),
      'nationalIdFront': await MultipartFile.fromFile(
        nationalIdFront.path,
        filename: nationalIdFront.path.split('/').last,
      ),
      'nationalIdBack': await MultipartFile.fromFile(
        nationalIdBack.path,
        filename: nationalIdBack.path.split('/').last,
      ),
      'selfie': await MultipartFile.fromFile(
        selfie.path,
        filename: selfie.path.split('/').last,
      ),
    });

    final response = await client.post<Map<String, dynamic>>(
      ApiEndpoints.ekycSubmit,
      data: formData,
    );
    return VerificationEntity.fromJson(response.data ?? {});
  }
}
