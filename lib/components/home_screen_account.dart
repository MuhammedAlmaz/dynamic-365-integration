import 'package:dynamic_365_integration/constants/icons.dart';
import 'package:dynamic_365_integration/helpers/application.dart';
import 'package:dynamic_365_integration/helpers/device_info.dart';
import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:dynamic_365_integration/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenAccount extends StatelessWidget {
  final AccountBM account;
  final bool isGridView;

  const HomeScreenAccount({required this.account, this.isGridView = false, Key? key}) : super(key: key);

  Widget get _image {
    return CachedNetworkImage(
      width: DeviceInfo.width(23),
      height: DeviceInfo.width(23),
      imageUrl: account.image,
      fit: BoxFit.contain,
      errorWidget: (_, __, ___) => SvgPicture.asset(AppIcons.noImage, color: Colors.black),
      progressIndicatorBuilder: (_, __, ___) => Center(child: SpinKitCircle(color: Colors.blueAccent.shade700)),
    );
  }

  Widget get _payload {
    if (isGridView) {
      return SingleChildScrollView(
        child: Container(
          height: DeviceInfo.height(15),
          child: Text(account.payload),
        ),
      );
    }
    return Expanded(child: SingleChildScrollView(child: Text(account.payload)));
  }

  List<Widget> get _details {
    return [
      Text(account.name),
      SizedBox(height: DeviceInfo.height(1)),
      _payload,
    ];
  }

  Widget get _listObject => Row(
        children: [
          _image,
          SizedBox(width: DeviceInfo.width(2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _details,
            ),
          ),
        ],
      );
  Widget get _cardObject => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image,
          SizedBox(height: DeviceInfo.height(1)),
          ..._details,
        ],
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key("HOME_SCREEN_ACCOUNT_${account.name}"),
      onTap: () async => await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccountDetailsScreen(account: account))),
      child: Container(
        key: Key(isGridView ? "GRID_VIEW_CONTAINER" : "LIST_VIEW_CONTAINER"),
        width: DeviceInfo.width(42.5),
        margin: EdgeInsets.symmetric(vertical: DeviceInfo.height(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        height: isGridView ? null : DeviceInfo.width(27),
        padding: EdgeInsets.all(DeviceInfo.width(2)),
        child: isGridView ? _cardObject : _listObject,
      ),
    );
  }
}
