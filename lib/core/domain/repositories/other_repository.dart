import 'dart:io';

import '../../api/resource/resource.dart';
import '../entities/faq_entity/faq_entity.dart';
import '../entities/system_access_entity/system_access_entity.dart';
import '../entities/terms_of_service_entity.dart';

abstract class OtherRepository {
  Future<Result<TermsOfServiceEntity>> fetchTermsOfService();
  Future<Result<List<FaqEntity>>> fetchFaqs();
  Future<Result<SystemAccessEntity>> getSystemAccessState();
  Future<void> addNewLog(String? flaskSerialId, bool hasError, File file);
}
