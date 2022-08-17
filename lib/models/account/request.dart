import 'dart:convert';

import 'package:dynamic_365_integration/constants/filter_type.dart';

class AccountRequestBM {
  FilterType? filterType;
  String searchTerm;
  AccountRequestBM({this.filterType, this.searchTerm = ""});

  String get queryString {
    if (searchTerm.length < 1) return "";
    if (filterType == null) return "?\$filter=contains(name,'$searchTerm') or contains(accountnumber,'$searchTerm')";
    if (filterType == FilterType.stateCode) return "?\$filter=contains(statecode,'$searchTerm')";
    if (filterType == FilterType.stateOrProvince) return "?\$filter=contains(address1_stateorprovince,'$searchTerm')";
    return "";
  }

  AccountRequestBM get clone {
    return AccountRequestBM(
      filterType: filterType != null ? FilterType.values[filterType!.index] : null,
      searchTerm: "$searchTerm",
    );
  }
}
