import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/zone_model.dart';
import '../bloc/zone_bloc.dart';

/// A card displaying zone information
class ZoneCard extends StatelessWidget {
  /// Zone model
  final ZoneModel zone;
  final VoidCallback onEdit;

  /// Constructor
  const ZoneCard({Key? key, required this.zone, required this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentCount = int.tryParse(zone.currentCount) ?? 0;
    final isOverThreshold = currentCount >= zone.threshold;
    final isOverCapacity = currentCount >= zone.maximumCount;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: theme.textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        zone.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusIndicator(isOverThreshold, isOverCapacity),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildOccupancyInfo(currentCount, theme),
            const SizedBox(height: 16.0),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isOverThreshold, bool isOverCapacity) {
    return Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isOverCapacity
                ? Colors.red
                : isOverThreshold
                ? Colors.orange
                : Colors.green,
      ),
    );
  }

  Widget _buildOccupancyInfo(int currentCount, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Occupancy', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: zone.maximumCount > 0 ? currentCount / zone.maximumCount : 0.0,
          backgroundColor: theme.colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation(
            currentCount >= zone.maximumCount
                ? Colors.red
                : currentCount >= zone.threshold
                ? Colors.orange
                : Colors.green,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentCount / ${zone.maximumCount}',
              style: theme.textTheme.bodySmall,
            ),
            if (currentCount >= zone.threshold)
              Text(
                currentCount >= zone.maximumCount
                    ? 'Over Capacity!'
                    : 'Threshold Reached!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      currentCount >= zone.maximumCount
                          ? Colors.red
                          : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onEdit, child: const Text('Edit')),
        const SizedBox(width: 8.0),
        TextButton(
          onPressed: () {
            context.read<ZoneBloc>().add(DeleteUserZone());
          },
          child: const Text('Delete'),
        ),
        const SizedBox(width: 8.0),
        FilledButton(
          onPressed:
              zone.isActive
                  ? () {
                    context.read<ZoneBloc>().add(EndVideoSession());
                  }
                  : () {
                    context.read<ZoneBloc>().add(StartVideoSession());
                  },
          child: Text(zone.isActive ? 'End Session' : 'Start Session'),
        ),
      ],
    );
  }
}
