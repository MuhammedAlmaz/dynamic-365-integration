import 'package:dynamic_365_integration/constants/http_type.dart';
import 'package:dynamic_365_integration/constants/http_uri.dart';
import 'package:dynamic_365_integration/helpers/http_client.dart';
import 'package:dynamic_365_integration/models/account/request.dart';
import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:dynamic_365_integration/repositories/bloc.dart';
import 'package:dynamic_365_integration/repositories/http_response.dart';
import 'package:flutter/material.dart';

class ListAccountBloc extends BlocRepository<List<AccountBM>, AccountRequestBM> {
  @override
  Future process(String lastRequestUniqueId) async {
    HttpResponseRepository<List<AccountBM>> responseRepository = await AppHttpClient().call<List<AccountBM>>(
      type: HttpCallType.get,
      apiUrlString: "${HttpClientApiUrl.accounts.uri}${requestObject?.queryString ?? ""}",
      withAuth: true,
      fromJSON: (json) => json["value"].map((e) => AccountBM.fromJSON(e)).toList().cast<AccountBM>(),
    );
    if (responseRepository.hasError) {
      return fetcherSink([], lastRequestUniqueId: lastRequestUniqueId);
    }
    fetcherSink(responseRepository.response, lastRequestUniqueId: lastRequestUniqueId);
  }

  @override
  List<AccountBM>? setTestingMockState() {
    return [
      AccountBM(name: "Test First", image: "", payload: "Test First Payload"),
      AccountBM(name: "Test Second", image: "", payload: "Test Second Payload"),
      AccountBM(name: "Test Third", image: "", payload: "Test Third Payload"),
      AccountBM(name: "Test Fourth", image: "", payload: "Test Fourth Payload"),
      AccountBM(name: "Test Fifth", image: "", payload: "Test Fifth Payload"),
    ];
  }
}

ListAccountBloc listAccountBloc = ListAccountBloc();
