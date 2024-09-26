// import everything from models folder
// import 'package:equb_v3_frontend/models/payment_tracking/list_users.dart';

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
}

final List<ChartData> chartDataList = [
  ChartData('8', 0, 0.3, 0.13, 0.26),
  ChartData('9', 0, 0.5, 0.15, 0.3),
  ChartData('10', 0, 0.4, 0.09, 0.32),
  ChartData('11', 0, 0.3, 0.13, 0.26),
];
