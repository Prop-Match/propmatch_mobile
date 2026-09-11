import 'dart:io';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';

abstract class EkycRepository {
  Future<VerificationEntity> getMyVerification();
  Future<VerificationEntity> submitVerification({
    required String nationalId,
    required File nationalIdFront,
    required File nationalIdBack,
    required File selfie,
  });
}
