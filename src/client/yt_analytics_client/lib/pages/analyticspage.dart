import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/colors.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';
import 'package:yt_analytics_client/models/trendingchartdata.dart';
import 'package:yt_analytics_client/tools/utils.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage();

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _numDaysController = TextEditingController();
  final _trendingNController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const FilterSelection(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<EntityManager>(
                  builder: (context, model, child) {
                    return _TrendingBarChart(
                      xAxis: 'Categories',
                      yAxis: '# Videos',
                      barChartData: model.trendingCategories ??
                          Future<List<TrendingChartData>>(() => null),
                      title: 'Top Trending Categories',
                      refresh: () {
                        final filterModel =
                            Provider.of<FilterManager>(context, listen: false);
                        Provider.of<EntityManager>(context, listen: false)
                            .loadTrendingCategoriesAnalytics(
                          filterModel.category,
                          (!filterModel.commentsDisabled).toString(),
                          filterModel.videoName,
                          filterModel.views,
                          filterModel.likes,
                          filterModel.dislikes,
                          filterModel.channelName,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 16),
                Consumer<EntityManager>(
                  builder: (context, model, child) {
                    return _TrendingBarChart(
                      xAxis: 'Channels',
                      yAxis: '# Videos',
                      barChartData: model.trendingChannels ??
                          Future<List<TrendingChartData>>(() => null),
                      title: 'Top Trending Channels',
                      refresh: () {
                        final filterModel =
                            Provider.of<FilterManager>(context, listen: false);
                        Provider.of<EntityManager>(context, listen: false)
                            .loadTrendingChannelsAnalytics(
                          filterModel.category,
                          (!filterModel.commentsDisabled).toString(),
                          filterModel.videoName,
                          filterModel.views,
                          filterModel.likes,
                          filterModel.dislikes,
                          filterModel.channelName,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 16),
                Consumer<EntityManager>(
                  builder: (context, model, child) {
                    return _TrendingBarChart(
                      xAxis: 'Categories',
                      yAxis: 'Avg # Tags',
                      barChartData: model.avgTagsCategories ??
                          Future<List<TrendingChartData>>(() => null),
                      title: 'Top Trending Categories by Average # of Tags',
                      refresh: () {
                        final filterModel =
                            Provider.of<FilterManager>(context, listen: false);
                        Provider.of<EntityManager>(context, listen: false)
                            .loadAvgTagsCategoriesAnalytics(
                          filterModel.category,
                          (!filterModel.commentsDisabled).toString(),
                          filterModel.videoName,
                          filterModel.views,
                          filterModel.likes,
                          filterModel.dislikes,
                          filterModel.channelName,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _TrendingTable(
                    title: 'Top Trending N Videos',
                    controller: _trendingNController,
                    isTopTrending: true,
                    refresh: () {
                      final filterModel =
                          Provider.of<FilterManager>(context, listen: false);

                      Provider.of<EntityManager>(context, listen: false)
                          .setTopTrendingN(filterModel.trendingN);
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _TrendingTable(
                    title: 'Videos Trending for N Days',
                    controller: _numDaysController,
                    isTopTrending: false,
                    refresh: () {
                      final filterModel =
                          Provider.of<FilterManager>(context, listen: false);

                      Provider.of<EntityManager>(context, listen: false)
                          .setTrendingNDays(filterModel.numofdays);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingTable extends StatelessWidget {
  const _TrendingTable({
    @required this.title,
    @required this.controller,
    @required this.isTopTrending,
    @required this.refresh,
  })  : assert(title != null),
        assert(controller != null),
        assert(isTopTrending != null),
        assert(refresh != null);

  final String title;
  final TextEditingController controller;
  final bool isTopTrending;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<EntityManager>(
          builder: (context, model, child) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              elevation: 2,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                  controller: controller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    if (isTopTrending) {
                                      Provider.of<FilterManager>(context,
                                              listen: false)
                                          .trendingN = value;
                                    } else {
                                      Provider.of<FilterManager>(context,
                                              listen: false)
                                          .numofdays = value;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                    labelText: 'N',
                                  ),
                                  validator: (value) {
                                    if (!Utils.isDigit(value)) {
                                      return 'Please enter a number';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_outlined),
                          onPressed: refresh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder(
                      future: isTopTrending
                          ? model.topTrendingN ??
                              Future<List<Entity>>(() => null)
                          : model.trendingNDays ??
                              Future<List<Entity>>(() => null),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final trendingData =
                                  snapshot.data as List<Entity> ?? <Entity>[];
                              print(trendingData.length);
                              print('lol');
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: trendingData.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ExcludeSemantics(
                                      child: CircleAvatar(
                                        backgroundColor: ClientColors.red500,
                                        child: Text('${index + 1}'),
                                      ),
                                    ),
                                    title: Text(
                                      '${trendingData[index].title.replaceAll('\"', '')}',
                                    ),
                                  );
                                },
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TrendingBarChart extends StatefulWidget {
  const _TrendingBarChart({
    @required this.barChartData,
    @required this.title,
    @required this.xAxis,
    @required this.yAxis,
    @required this.refresh,
  })  : assert(barChartData != null),
        assert(title != null),
        assert(xAxis != null),
        assert(yAxis != null),
        assert(refresh != null);

  final Future<List<TrendingChartData>> barChartData;
  final String title;
  final String xAxis;
  final String yAxis;
  final VoidCallback refresh;

  @override
  _TrendingBarChartState createState() => _TrendingBarChartState();
}

class _TrendingBarChartState extends State<_TrendingBarChart> {
  final Color barColor = ClientColors.red500;
  final double barWidth = 7;

  @override
  Widget build(BuildContext context) {
    final chartPrimaryColor = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 800),
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        color: chartPrimaryColor.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.title}',
                    style: TextStyle(
                      color: chartPrimaryColor.onSurface,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_outlined),
                    onPressed: widget.refresh,
                  ),
                ],
              ),
              const SizedBox(height: 38),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Consumer<EntityManager>(
                    builder: (context, model, child) {
                      return FutureBuilder(
                          future: widget.barChartData,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const CircularProgressIndicator();
                              default:
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final barData = snapshot.data
                                          as List<TrendingChartData> ??
                                      <TrendingChartData>[];

                                  var items = <BarChartGroupData>[];
                                  var mapToCat = <int, String>{};
                                  var mapToInt = <String, int>{};

                                  for (var i = 0; i < barData.length; i++) {
                                    mapToCat[i] = barData[i].xVal;
                                  }

                                  for (var i = 0; i < barData.length; i++) {
                                    mapToInt[barData[i].xVal] = i;
                                  }

                                  for (final entry in barData) {
                                    items.add(makeGroupData(
                                        mapToInt[entry.xVal],
                                        entry.yVal as double));
                                  }

                                  //find max
                                  var max = 0;
                                  for (final entry in barData) {
                                    if (entry.yVal > max) {
                                      max = entry.yVal;
                                    }
                                  }

                                  return BarChart(
                                    BarChartData(
                                      axisTitleData: FlAxisTitleData(
                                        leftTitle: AxisTitle(
                                          showTitle: true,
                                          titleText: widget.yAxis,
                                          reservedSize: 20,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        bottomTitle: AxisTitle(
                                          showTitle: true,
                                          titleText: widget.xAxis,
                                          reservedSize: 20,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      maxY: max as double,
                                      barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          getTooltipItem: (
                                            group,
                                            groupIndex,
                                            rod,
                                            rodIndex,
                                          ) {
                                            String xVal;
                                            xVal = mapToCat[group.x.toInt()]
                                                .replaceAll('\"', '');
                                            return BarTooltipItem(
                                              xVal +
                                                  '\n' +
                                                  (rod.y - 1).toString(),
                                              const TextStyle(
                                                color: ClientColors.red500,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: SideTitles(
                                          showTitles: true,
                                          getTextStyles: (value) => TextStyle(
                                            color: chartPrimaryColor.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          margin: 20,
                                          getTitles: (value) {
                                            return mapToCat[value]
                                                .replaceAll('\"', '')
                                                .substring(0, 1)
                                                .padRight(2, '..');
                                          },
                                        ),
                                        leftTitles: SideTitles(
                                          showTitles: true,
                                          getTextStyles: (value) => TextStyle(
                                            color: chartPrimaryColor.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          margin: 32,
                                          reservedSize: 14,
                                          getTitles: (value) {
                                            if (value == 0) {
                                              return '0';
                                            } else if (value == max / 2) {
                                              return (max / 2).toString();
                                            } else if (value == max) {
                                              return max.toString();
                                            } else {
                                              return '';
                                            }
                                          },
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: const Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 0.75,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      barGroups: items,
                                    ),
                                  );
                                }
                            }
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          y: y1,
          colors: [barColor],
          width: barWidth,
        ),
      ],
    );
  }
}
