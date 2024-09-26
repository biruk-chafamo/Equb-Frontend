import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/repositories/example_data.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/bidding_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Bidding extends StatelessWidget {
  const Bidding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppMargin.globalMargin,
      child: Column(
        children: [
          BlocBuilder<EqubBloc, EqubDetailState>(
              builder: (context, equbDetailState) {
            if (equbDetailState.status == EqubDetailStatus.loading) {
              return const CircularProgressIndicator();
            } else if (equbDetailState.status == EqubDetailStatus.success) {
              final equbDetail = equbDetailState.equbDetail;
              if (equbDetail == null) {
                return const Center(child: Text('No equb found'));
              }

              final currentHighestBidder =
                  equbDetail.currentHighestBidder;
              if (equbDetail.isInPaymentStage) {
                return Text(
                  "You cannot place bids for round ${equbDetail.currentRound + 1} until this round's payments are completed",
                  style: Theme.of(context).textTheme.titleSmall,
                );
              }

              if (equbDetail.isCompleted) {
                return Text(
                  "This equb is already completed",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleSmall,
                );
              }

              if (!equbDetail.isActive) {
                return Text(
                  "This equb has not started yet",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleSmall,
                );
              }
              return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, userState) {
                final String highestBidderText;
                var highestBidderTextColor =
                    Theme.of(context).colorScheme.onSecondaryContainer;
                if (userState is AuthAuthenticated) {
                  if (equbDetail.isWonByUser) {
                    highestBidderText =
                        'You cannot place bids since you have won previously';
                  } else if (currentHighestBidder == null) {
                    highestBidderText =
                        'Be the first to place a bid for this round.';
                  } else if (currentHighestBidder.username ==
                      userState.user.username) {
                    highestBidderText = 'You are the current highest bidder.';
                    highestBidderTextColor = Colors.green.shade800;
                  } else {
                    highestBidderText = 'You are not the highest bidder.';
                    highestBidderTextColor = Colors.red.shade800;
                  }
                } else {
                  highestBidderText = '...';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: AppMargin.globalMargin,
                      child: Text(
                        highestBidderText,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: highestBidderTextColor),
                      ),
                    ),
                    NumericStepButton(
                      equbId: equbDetail.id,
                      minValue: equbDetail.currentHighestBid,
                      maxValue: 1,
                    ),
                  ],
                );
              });
            } else {
              return const CircularProgressIndicator();
            }
          })

          // const InterestRateChart(),
        ],
      ),
    );
  }
}

class InterestRateChart extends StatelessWidget {
  const InterestRateChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> seriesLabels = ['Borrowing', 'Saving'];
    final Map<String, Color> seriesColors = {
      'Borrowing': Theme.of(context).colorScheme.tertiaryContainer,
      'Saving': Theme.of(context).colorScheme.onSecondaryContainer,
    };

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: const EdgeInsets.symmetric(vertical: 15),
      // decoration: PrimaryBoxDecor(),
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,

          legendItemBuilder:
              (String name, dynamic series, dynamic point, int index) {
            final seriesLabel = seriesLabels[index];
            final seriesColor = seriesColors[seriesLabel];
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.circle,
                  size: 15,
                  color: seriesColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  seriesLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
          // Toggles the series visibility on tapping the legend item
          toggleSeriesVisibility: true,
        ),
        plotAreaBorderColor: Colors.transparent,
        primaryXAxis: const CategoryAxis(isVisible: false),
        primaryYAxis: NumericAxis(
            isVisible: false,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            numberFormat: NumberFormat.decimalPercentPattern()),
        series: <CartesianSeries>[
          HiloSeries<ChartData, String>(
            color: seriesColors['Borrowing'],
            borderWidth: 10,
            dataSource: chartDataList,
            xValueMapper: (ChartData data, _) => data.x,
            lowValueMapper: (ChartData data, _) => 0,
            highValueMapper: (ChartData data, _) => data.y2,
            animationDuration: 0,
          ),
          HiloSeries<ChartData, String>(
            color: seriesColors['Saving'],
            borderWidth: 10,
            dataSource: chartDataList,
            xValueMapper: (ChartData data, _) => data.x,
            lowValueMapper: (ChartData data, _) => -1 * data.y3,
            highValueMapper: (ChartData data, _) => 0,
            animationDuration: 0,
          ),
        ],
      ),
    );
  }
}
