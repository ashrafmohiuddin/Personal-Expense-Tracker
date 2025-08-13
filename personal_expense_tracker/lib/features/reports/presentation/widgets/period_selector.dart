import 'package:flutter/material.dart';
import '../../../../design/tokens.dart';
import '../screens/reports_screen.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final ReportPeriod selectedPeriod;
  final ValueChanged<ReportPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spacing8),
        child: SegmentedButton<ReportPeriod>(
          segments: const [
            ButtonSegment(
              value: ReportPeriod.thisWeek,
              label: Text('This Week'),
            ),
            ButtonSegment(
              value: ReportPeriod.thisMonth,
              label: Text('This Month'),
            ),
            ButtonSegment(
              value: ReportPeriod.custom,
              label: Text('Custom'),
            ),
          ],
          selected: {selectedPeriod},
          onSelectionChanged: (Set<ReportPeriod> selection) {
            onPeriodChanged(selection.first);
          },
        ),
      ),
    );
  }
}
