import 'package:equb_v3_frontend/repositories/example_data.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InterestRateChart extends StatelessWidget {
  const InterestRateChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.globalPadding,
      margin: AppMargin.globalMargin,
      // decoration: PrimaryBoxDecor(),
      child: SfCartesianChart(
        plotAreaBorderColor: Colors.transparent,
        primaryXAxis: const CategoryAxis(isVisible: false),
        primaryYAxis: const NumericAxis(isVisible: true),
        series: <CartesianSeries>[
          // Renders bar chart
          HiloSeries<ChartData, String>(
            color: AppColors.secondaryContainer,
            borderWidth: 20,
            dataSource: chartDataList,
            xValueMapper: (ChartData data, _) => data.x,
            lowValueMapper: (ChartData data, _) => 0,
            highValueMapper: (ChartData data, _) => data.y2,
            animationDuration: 0,
          ),
          HiloSeries<ChartData, String>(
            color: AppColors.onSecondaryContainer,
            borderWidth: 20,
            dataSource: chartDataList,
            xValueMapper: (ChartData data, _) => data.x,
            lowValueMapper: (ChartData data, _) => -1 * data.y3,
            highValueMapper: (ChartData data, _) => 0,
            animationDuration: 0,
          ),
          HiloSeries<ChartData, String>(
            color: Colors.transparent,
            borderWidth: 20,
            dataSource: chartDataList,
            xValueMapper: (ChartData data, _) => data.x,
            lowValueMapper: (ChartData data, _) => 0,
            highValueMapper: (ChartData data, _) => -1 * data.y2,
            animationDuration: 0,
          ),
        ],
      ),
    );
  }
}
