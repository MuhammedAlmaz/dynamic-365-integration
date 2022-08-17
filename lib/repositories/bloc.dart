import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

abstract class BlocRepository<ResultObject, RequestObject> {
  RequestObject? _requestObject;
  bool _isBlocHandling = false;
  ResultObject? _store;
  BlocRepository() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) _store = setTestingMockState();
  }
  // ignore: close_sinks
  final PublishSubject<ResultObject?> _fetcher = PublishSubject<ResultObject?>();
  final Uuid _uuidGenerator = const Uuid();
  String _lastRequestUniqueId = "";
  Function(ResultObject?)? _listener;

  PublishSubject<ResultObject?> get fetcher => _fetcher;

  Stream<ResultObject?> get stream => _fetcher.stream;

  ResultObject? get store => _store;

  // String get lastRequestUniqueId => this._lastRequestUniqueId;

  bool get isBlocHandling => _isBlocHandling;

  RequestObject? get requestObject => _requestObject;

  void setStore(ResultObject? store) => _store = store;

  void clearRequestObject() => _requestObject = null;

  void clearStore() {
    _store = null;
    fetcher.sink.add(null);
  }

  Future prevProcess() async {
    _lastRequestUniqueId = _uuidGenerator.v4();
    await process(_lastRequestUniqueId);
    _isBlocHandling = false;
  }

  Future process(String lastRequestUniqueId);

  void call({RequestObject? requestObject, bool sinkNullObject = false}) {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    _isBlocHandling = true;
    _requestObject = requestObject;
    if (sinkNullObject) {
      fetcher.sink.add(null);
    }
    prevProcess();
  }

  void fetcherSink(ResultObject? resultObject, {bool forceSink = false, required lastRequestUniqueId}) {
    if ((forceSink != null && forceSink) || lastRequestUniqueId == _lastRequestUniqueId) {
      _store = resultObject;
      fetcher.sink.add(resultObject);
      if (_listener != null) _listener!(resultObject);
    } else {
//      print("this request is old request" + ResultObject.toString());
    }
  }

  void setListener(Function(ResultObject?) listener) => _listener = listener;

  ResultObject? setTestingMockState() {
    return null;
  }

  dispose() {
    _fetcher.close();
  }
}
