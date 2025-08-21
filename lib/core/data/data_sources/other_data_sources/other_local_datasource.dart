import '../../../domain/entities/terms_of_service_entity.dart';

abstract class OtherLocalDataSource {
  Future<TermsOfServiceEntity> getLastFetchedTermsOfService();
}

class OtherLocalDataSourceImpl extends OtherLocalDataSource {
  OtherLocalDataSourceImpl();

  @override
  Future<TermsOfServiceEntity> getLastFetchedTermsOfService() async {
    return TermsOfServiceEntity(content: '');
  }
}
