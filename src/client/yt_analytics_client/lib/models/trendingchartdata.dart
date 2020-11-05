import 'package:flutter/material.dart';

class TrendingChartData {
  const TrendingChartData({@required this.xVal, @required this.yVal})
      : assert(xVal != null),
        assert(yVal != null);

  final String xVal;
  final int yVal;

  TrendingChartData.fromJson(Map<String, dynamic> response)
      : xVal = response['xVal'] as String,
        yVal = response['yVal'] as int;
}
