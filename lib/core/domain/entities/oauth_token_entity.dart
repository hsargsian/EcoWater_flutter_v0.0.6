class OauthTokenEntity {
  OauthTokenEntity(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId});
  final String accessToken;
  final String refreshToken;
  final String userId;
}
