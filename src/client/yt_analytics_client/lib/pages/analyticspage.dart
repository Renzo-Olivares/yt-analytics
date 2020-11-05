import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/models/trendingchartdata.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage();

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const FilterSelection(),
        const SizedBox(height: 40),
        // Consumer<EntityManager>(
        //   builder: (context, model, child) {
        //     return _TrendingBarChart(
        //       barChartData: model.trendingCategories ??
        //           Future<List<TrendingChartData>>(() => null),
        //       title: 'Categories',
        //     );
        //   },
        // ),
        // Consumer<EntityManager>(
        //   builder: (context, model, child) {
        //     return _TrendingBarChart(
        //       barChartData: model.trendingChannels ??
        //           Future<List<TrendingChartData>>(() => null),
        //       title: 'Channels',
        //     );
        //   },
        // ),
        Consumer<EntityManager>(
          builder: (context, model, child) {
            return FutureBuilder(
              future: model.topTrendingN ?? Future<List<Entity>>(() => null),
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
                      return ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 800, maxHeight: 800),
                        child: ListView.builder(
                          itemCount: trendingData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                '$index : ${trendingData[index].videoID} - ${trendingData[index].title}',
                              ),
                            );
                          },
                        ),
                      );
                    }
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _TrendingBarChart extends StatefulWidget {
  const _TrendingBarChart({@required this.barChartData, @required this.title})
      : assert(barChartData != null),
        assert(title != null);

  final Future<List<TrendingChartData>> barChartData;
  final String title;

  @override
  _TrendingBarChartState createState() => _TrendingBarChartState();
}

class _TrendingBarChartState extends State<_TrendingBarChart> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final double width = 7;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 800),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Top Trending ${widget.title}',
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 38),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

                                  // barData = const [
                                  //   TrendingChartData(xVal: 'Comedy', yVal: 200),
                                  //   TrendingChartData(xVal: 'Movies', yVal: 300),
                                  //   TrendingChartData(xVal: 'Music', yVal: 400),
                                  //   TrendingChartData(xVal: 'Shows', yVal: 900),
                                  //   TrendingChartData(
                                  //       xVal: 'Entertainment', yVal: 1000),
                                  //   TrendingChartData(xVal: 'Gaming', yVal: 100),
                                  // ];

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
                                      maxY: max as double,
                                      barTouchData: BarTouchData(),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: SideTitles(
                                          showTitles: true,
                                          getTextStyles: (value) =>
                                              const TextStyle(
                                            color: Color(0xff7589a2),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          margin: 20,
                                          getTitles: (value) {
                                            return mapToCat[value];
                                          },
                                        ),
                                        leftTitles: SideTitles(
                                          showTitles: true,
                                          getTextStyles: (value) =>
                                              const TextStyle(
                                            color: Color(0xff7589a2),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          margin: 32,
                                          reservedSize: 14,
                                          getTitles: (value) {
                                            if (value == 0) {
                                              return '1K';
                                            } else if (value == max / 2) {
                                              return '5K';
                                            } else if (value == max) {
                                              return '10K';
                                            } else {
                                              return '';
                                            }
                                          },
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
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
              const SizedBox(height: 12),
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
          colors: [leftBarColor],
          width: width,
        ),
      ],
    );
  }
}
