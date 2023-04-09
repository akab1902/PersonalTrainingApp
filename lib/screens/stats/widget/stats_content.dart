import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_training_app/data/models/bar_chart_data_model.dart';
import 'package:personal_training_app/data/models/training_record_model.dart';
import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/const/path_constants.dart';
import '../bloc/stats_bloc.dart';
import 'history_item.dart';

class StatsContent extends StatefulWidget {
  const StatsContent({Key? key}) : super(key: key);

  @override
  State<StatsContent> createState() => _StatsContentState();
}

class _StatsContentState extends State<StatsContent> {
  List<BarChartDataItem> lastWeekHistory = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.backgroundWhite,
        child: Stack(
          children: [
            _createMainData(context),
            BlocBuilder<StatsBloc, StatsState>(
                buildWhen: (_, currState) =>
                    currState is LoadingState ||
                    currState is ErrorState ||
                    currState is InitialLoaded,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return _createLoading();
                  } else if (state is ErrorState) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                })
          ],
        ),
      ),
    );
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _createHeader(context),
            const SizedBox(height: 30),
            _createStats(context),
          ],
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    final bloc = BlocProvider.of<StatsBloc>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Trainings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textBlack),
            ),
            BlocBuilder<StatsBloc, StatsState>(
              buildWhen: (_, currState) => currState is ReloadImageState,
              builder: (context, state) {
                final photoUrl =
                    state is ReloadImageState ? state.photoURL : null;
                return GestureDetector(
                  child: photoUrl == null || photoUrl == ""
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage(PathConstants.profilePlaceholder),
                          radius: 30,
                        )
                      : CircleAvatar(
                          radius: 30,
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: PathConstants.profilePlaceholder,
                              image: photoUrl,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 120,
                            ),
                          ),
                        ),
                  onTap: () async {
                    bloc.add(OnProfileTappedEvent());
                    bloc.add(ReloadImageEvent());
                  },
                );
              },
            ),
          ],
        ));
  }

  Widget _createStats(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
        buildWhen: (_, currState) => currState is ReloadHistoryState,
        builder: (context, state) {
          final List<TrainingRecord> history =
              state is ReloadHistoryState ? state.history ?? [] : [];
          lastWeekHistory =
              state is ReloadHistoryState ? state.lastWeekHistory ?? [] : [];
          return history.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _createTitle('Exercise time'),
                      const SizedBox(height: 20),
                      _createBarChart(context, lastWeekHistory),
                      const SizedBox(height: 20),
                      _createTitle('History'),
                      const SizedBox(height: 20),
                      _createHistoryList(context, history),
                      const SizedBox(height: 30),
                    ],
                  ))
              : Container();
        });
  }

  Widget _createBarChart(
      BuildContext context, List<BarChartDataItem> lastWeekHistory) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Week average: ${getAverage().toStringAsFixed(1)} mins',
              style: const TextStyle(
                color: ColorConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: BarChart(
              mainBarData(lastWeekHistory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHistoryList(
      BuildContext context, List<TrainingRecord> history) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          return HistoryItem(
            count: history[index].count,
            exerciseName: history[index].exerciseName,
            durationInSeconds: history[index].durationInSeconds,
            date: DateFormat('yyyy-MM-dd').format(history[index].date),
          );
        });
  }

  Widget _createTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 24,
          color: ColorConstants.textBlack),
    );
  }

  BarChartData mainBarData(List<BarChartDataItem> lastWeekHistory) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: ColorConstants.secondaryColor,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          fitInsideHorizontally: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay = lastWeekHistory[group.x].label;
            String date = lastWeekHistory[group.x].label2;
            return BarTooltipItem(
              '$date\n$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${(rod.toY.toInt()).toString()} mins",
                  style: const TextStyle(
                    color: ColorConstants.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: lastWeekHistory
          .map((e) => BarChartGroupData(x: e.id, barRods: [
                BarChartRodData(
                  toY: e.val,
                  width: 15,
                  color: ColorConstants.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                )
              ]))
          .toList(),
      gridData: FlGridData(
        show: false,
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: ColorConstants.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text = Text(
      lastWeekHistory[value.toInt()].bottomLabel,
      style: style,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  double getAverage() {
    double sum = 0;
    for (BarChartDataItem e in lastWeekHistory) {
      sum += e.val;
    }
    return sum / 7;
  }
}
