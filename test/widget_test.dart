// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dynamic_365_integration/bloc/list.dart';
import 'package:dynamic_365_integration/helpers/functions.dart';
import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dynamic_365_integration/main.dart';

import 'scenarios/check_has_account_on_home_screen.dart';

void main() async {
  group('Unit Tests', () {
    test("Test Partition Function", () async {
      List<AccountBM> accounts = listAccountBloc.store ?? [];
      List<List<AccountBM>> partitionsAccount = ApplicationFunctions.partitions(accounts, 2);
      expect(partitionsAccount.length, equals((accounts.length / 2).ceil()));
      expect(accounts.length, greaterThanOrEqualTo(1));
      expect(partitionsAccount[0][0].name, equals(accounts.first.name));
      for (int i = 0; i < accounts.length; i++) {
        //check all partition variables
        expect(partitionsAccount[(i / 2).floor()][i % 2].name, equals(accounts[i].name));
      }
    });

    test("Test Account parse", () async {
      Map<String, dynamic> data = {"name": "Test Name", "entityimage_url": "image"};
      AccountBM accountBM = AccountBM.fromJSON(data);
      expect(accountBM.name, equals(data["name"]));
    });
  });
  group('Widget Tests', () {
    testWidgets("ACCOUNT_LIST_AND_DETAILS", (WidgetTester tester) async {
      List<AccountBM> accounts = listAccountBloc.store ?? [];
      await tester.pumpWidget(const MyApp());
      await checkHasAccountsHomeScreen(accounts);
      // //Open details
      expect(find.byKey(Key("HOME_SCREEN_ACCOUNT_${accounts.first.name}")), findsWidgets);
      await tester.tap(find.byKey(Key("HOME_SCREEN_ACCOUNT_${accounts.first.name}")));
      //pump for click animation
      await tester.pump(const Duration(milliseconds: 100));
      //pump for navigation animation
      await tester.pump(const Duration(milliseconds: 100));
      //Check details title is it true title
      expect(find.byKey(const Key("ACCOUNT_DETAILS_SCREEN_TITLE")), findsWidgets);
      dynamic detailsTitle = find.byKey(const Key("ACCOUNT_DETAILS_SCREEN_TITLE")).evaluate();
      detailsTitle = detailsTitle.single.widget as Text;
      expect(detailsTitle.data, accounts.first.name);
    });

    testWidgets("GRID_VIEW_AND_LIST_VIEW", (WidgetTester tester) async {
      List<AccountBM> accounts = listAccountBloc.store ?? [];
      await tester.pumpWidget(const MyApp());
      await checkHasAccountsHomeScreen(accounts);
      await tester.tap(find.byKey(const Key("HEADER_ICONS_LIST_VIEW")));
      //pump for click animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key("LIST_VIEW_CONTAINER")), findsWidgets);
      await tester.tap(find.byKey(const Key("HEADER_ICONS_GRID_VIEW")));
      //pump for click animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key("GRID_VIEW_CONTAINER")), findsWidgets);
    });
  });
}
