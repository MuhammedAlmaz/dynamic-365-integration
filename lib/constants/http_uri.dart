enum HttpClientApiUrl {
  accounts,
}

extension HttpClientApiUrlExtension on HttpClientApiUrl {
  String get uri {
    String apiBaseUrl = "https://orgb4c4dbb4.api.crm4.dynamics.com/api/data/v9.2";
    switch (this) {
      case HttpClientApiUrl.accounts:
        return "${apiBaseUrl}/accounts";
      default:
        return '';
    }
  }
}
