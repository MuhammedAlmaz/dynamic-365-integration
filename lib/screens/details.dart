import 'package:dynamic_365_integration/constants/icons.dart';
import 'package:dynamic_365_integration/helpers/device_info.dart';
import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountDetailsScreen extends StatelessWidget {
  final AccountBM account;

  const AccountDetailsScreen({required this.account, Key? key}) : super(key: key);

  Widget get _image {
    return CachedNetworkImage(
      width: DeviceInfo.width(100),
      height: DeviceInfo.height(35),
      imageUrl: account.image,
      fit: BoxFit.contain,
      errorWidget: (_, __, ___) => SvgPicture.asset(AppIcons.noImage, color: Colors.black),
      progressIndicatorBuilder: (_, __, ___) => Center(child: SpinKitCircle(color: Colors.blueAccent.shade700)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(account.name)),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: DeviceInfo.height(2)),
        color: Colors.white,
        padding: EdgeInsets.all(DeviceInfo.width(2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image,
            SizedBox(height: DeviceInfo.height(1)),
            Text(account.name, key: const Key("ACCOUNT_DETAILS_SCREEN_TITLE")),
            SizedBox(height: DeviceInfo.height(1)),
            Expanded(child: SingleChildScrollView(child: Text(account.payload))),
          ],
        ),
      ),
    );
  }
}
