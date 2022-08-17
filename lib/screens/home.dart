import 'package:dynamic_365_integration/bloc/list.dart';
import 'package:dynamic_365_integration/components/home_screen_account.dart';
import 'package:dynamic_365_integration/constants/filter_type.dart';
import 'package:dynamic_365_integration/helpers/device_info.dart';
import 'package:dynamic_365_integration/helpers/functions.dart';
import 'package:dynamic_365_integration/models/account/request.dart';
import 'package:dynamic_365_integration/models/account/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey menuButtonGlobalKey = GlobalKey();
  bool isGridView = false;
  @override
  void initState() {
    listAccountBloc.call();
    searchController.addListener(_onSearchTermChange);
    super.initState();
  }

  @override
  dispose() {
    searchController.removeListener(_onSearchTermChange);
    super.dispose();
  }

  void _onSearchTermChange() {
    AccountRequestBM requestObject = (listAccountBloc.requestObject ?? AccountRequestBM()).clone;
    String searchTerm = searchController.value.text.trim();
    if (requestObject.searchTerm == searchTerm) return;
    requestObject.searchTerm = searchTerm;
    listAccountBloc.call(requestObject: requestObject, sinkNullObject: true);
  }

  void _onFilterChange(int? type) {
    AccountRequestBM requestObject = (listAccountBloc.requestObject ?? AccountRequestBM()).clone;
    requestObject.filterType = type == null ? null : FilterType.values[type];
    listAccountBloc.call(requestObject: requestObject, sinkNullObject: true);
  }

  Widget _headerIcon({required IconData icon, required isGridView}) {
    return GestureDetector(
      key: Key("HEADER_ICONS_${isGridView ? "GRID_VIEW" : "LIST_VIEW"}"),
      onTap: () => setState(() => this.isGridView = isGridView),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: DeviceInfo.width(2)),
        color: Colors.transparent,
        child: Icon(
          icon,
          color: (isGridView == this.isGridView) ? Colors.blueAccent : Colors.black,
        ),
      ),
    );
  }

  Widget get _searchTextField {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget get _filterIcon {
    return GestureDetector(
      onTap: () => (menuButtonGlobalKey.currentState as dynamic).showButtonMenu(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: DeviceInfo.width(3)),
        color: Colors.transparent,
        child: Row(
          children: const [
            Icon(Icons.filter_alt),
            Text("Filter"),
          ],
        ),
      ),
    );
  }

  Widget get _header {
    return Row(
      children: [
        Expanded(child: _searchTextField),
        PopupMenuButton<int?>(
          key: menuButtonGlobalKey,
          onSelected: _onFilterChange,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int?>>[
            PopupMenuItem<int>(value: FilterType.stateCode.index, child: Text('State Code')),
            PopupMenuItem<int>(value: FilterType.stateOrProvince.index, child: Text('State Or Province')),
            PopupMenuItem<int?>(value: null, child: Text('Clear Filter')),
          ],
          child: _filterIcon,
        ),
        _headerIcon(icon: Icons.view_list_sharp, isGridView: false),
        _headerIcon(icon: Icons.grid_view_sharp, isGridView: true),
      ],
    );
  }

  Widget get _listOfAccounts {
    if (this.isGridView) {
      List<List<AccountBM>> accounts = ApplicationFunctions.partitions<AccountBM>(listAccountBloc.store ?? [], 2);
      return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (_, index) {
          if (accounts[index].length == 1) {
            return Row(
              children: [
                HomeScreenAccount(account: accounts[index][0], isGridView: true),
                SizedBox(width: DeviceInfo.height(2)),
                Expanded(child: Container()),
              ],
            );
          }
          return Row(
            children: [
              HomeScreenAccount(account: accounts[index][0], isGridView: true),
              SizedBox(width: DeviceInfo.height(2)),
              HomeScreenAccount(account: accounts[index][1], isGridView: true),
            ],
          );
        },
      );
    }
    return ListView.builder(
      itemCount: listAccountBloc.store?.length ?? 0,
      itemBuilder: (_, index) => HomeScreenAccount(account: listAccountBloc.store![index]),
    );
  }

  Widget get _loadingSpinner => Center(child: SpinKitCircle(color: Colors.blueAccent.shade700));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header,
            Expanded(
              child: StreamBuilder(
                stream: listAccountBloc.stream,
                builder: (_, __) {
                  if (listAccountBloc.isBlocHandling || listAccountBloc.store == null) {
                    return _loadingSpinner;
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DeviceInfo.width(5),
                      vertical: DeviceInfo.height(3),
                    ),
                    child: _listOfAccounts,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
