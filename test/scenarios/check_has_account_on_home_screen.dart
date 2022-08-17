import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

checkHasAccountsHomeScreen(List<AccountBM> accounts) {
  expect(accounts.length, greaterThanOrEqualTo(1));
  //Check account is rendered
  expect(find.byKey(Key("HOME_SCREEN_ACCOUNT_${accounts[0].name}")), findsOneWidget);
  //Check has any name on title text
  expect(find.text(accounts[0].name), findsOneWidget);
}
