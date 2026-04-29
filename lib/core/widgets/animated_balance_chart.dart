import 'package:fl_chart/fl_chart.dart';
import 'package:fin_sage/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedBalanceChart extends StatelessWidget {
  const AnimatedBalanceChart({
    super.key,
    required this.spots,
    required this.labels,
    required this.locale,
  });

  final List<FlSpot> spots;
  final List<DateTime> labels;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final hasTrendData = spots.isNotEmpty && labels.isNotEmpty;
    final lineSpots = _normalizeSpots(spots);

    return CustomPaint(
      painter: _ChartBackdropPainter(
        primary: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        accent: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      ),
      child: SizedBox(
        height: 220,
        child: LineChart(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
          LineChartData(
            minY: lineSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5000,
            maxY: lineSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5000,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: null,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Theme.of(context).dividerColor.withOpacity(0.18),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: hasTrendData,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= labels.length) {
                      return const SizedBox.shrink();
                    }

                    final middle = labels.length ~/ 2;
                    final shouldShow =
                        index == 0 || index == middle || index == labels.length - 1;
                    if (!shouldShow) {
                      return const SizedBox.shrink();
                    }

                    final text = DateFormat.Md(locale).format(labels[index]);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: hasTrendData,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipRoundedRadius: 12,
                getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= labels.length) {
                      return null;
                    }
                    final date = DateFormat.yMMMd(locale).format(labels[index]);
                    final value = spot.y.toCurrency(locale);
                    return LineTooltipItem(
                      '$date\n$value',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: lineSpots,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                dotData: FlDotData(
                  show: hasTrendData,
                  getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                    radius: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartBackdropPainter extends CustomPainter {
  const _ChartBackdropPainter({required this.primary, required this.accent});

  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = primary;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.15), 36, paint);

    paint.color = accent;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 28, paint);
  }

  @override
  bool shouldRepaint(covariant _ChartBackdropPainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.accent != accent;
  }
}

List<FlSpot> _normalizeSpots(List<FlSpot> original) {
  if (original.isEmpty) {
    return const [FlSpot(0, 0), FlSpot(1, 0)];
  }
  if (original.length == 1) {
    final single = original.first;
    return [single, FlSpot(single.x + 1, single.y)];
  }
  return original;
}
