import 'package:flutter/cupertino.dart';
import 'package:flutter_app/services/data_service_impl.dart';
import 'overview/overview_controller.dart';

void main() {
  var overviewController = OverviewController(DataServiceImpl());
  runApp(overviewController.view);
}
