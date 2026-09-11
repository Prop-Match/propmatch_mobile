import 'dart:io';
import 'package:propmatch_mobile/features/ekyc/data/datasources/ekyc_remote_datasource.dart';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';
import 'package:propmatch_mobile/features/ekyc/domain/repositories/ekyc_repository.dart';

class EkycRepositoryImpl implements EkycRepository {
  final EkycRemoteDataSource remoteDataSource;

  EkycRepositoryImpl(this.remoteDataSource);

  @override
  Future<VerificationEntity> getMyVerification() {
    return remoteDataSource.getMyVerification();
  }

  @override
  Future<VerificationEntity> submitVerification({
    required String nationalId,
    required File nationalIdFront,
    required File nationalIdBack,
    required File selfie,
  }) {
    return remoteDataSource.submitVerification(
      nationalId: nationalId,
      nationalIdFront: nationalIdFront,
      nationalIdBack: nationalIdBack,
      selfie: selfie,
    );
  }
}
