import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/config/app_theme.dart';
import '../../../../core/config/app_router.dart';
import '../../data/models/zone_model.dart';
import '../bloc/zone_bloc.dart';
import '../widgets/zone_card.dart';
import '../widgets/zone_form.dart';
import 'zone_live_view.dart';

/// Zones page for managing monitoring areas - similar to mobile cam feed
class ZonesPage extends StatefulWidget {
  const ZonesPage({Key? key}) : super(key: key);

  @override
  _ZonesPageState createState() => _ZonesPageState();
}

class _ZonesPageState extends State<ZonesPage> {
  List<ZoneModel> _zonesCache = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ZoneBloc>()..add(LoadUserZone()),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          title: const Text('Zones'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                context.read<ZoneBloc>().add(LoadUserZone());
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToCreateZone(context),
            ),
          ],
        ),
        body: BlocConsumer<ZoneBloc, ZoneState>(
          listener: (context, state) {
            if (state is VideoSessionStarted) {
              final zone = state.zones.firstWhere(
                (z) => z.roomId == state.roomId,
              );
              _navigateToLiveView(context, state.roomId, zone);
            } else if (state is ZoneCreated) {
              // Show success message and refresh
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Zone "${state.zones.first.name}" created successfully!',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              // Navigate back to zones list
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } else if (state is ZoneUpdated) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Zone "${state.zones.first.name}" updated successfully!',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              // Navigate back to zones list
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } else if (state is ZoneDeleted) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Zone deleted successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is ZoneError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );

              context.read<ZoneBloc>().add(LoadUserZone());
            }
          },
          builder: (context, state) {
            // Cache zones whenever we have them
            if (state is ZoneLoaded ||
                state is ZoneCreated ||
                state is ZoneUpdated ||
                state is ZoneDeleted ||
                state is VideoSessionStarted ||
                state is VideoSessionEnded) {
              final zones = _getZonesFromState(state);
              _zonesCache = zones;

              // Empty state like mobile cam feed
              if (zones.isEmpty) {
                return _buildEmptyState(context);
              }

              return _buildZonesList(context, zones);
            }

            // While loading or on intermediate states, fall back to cached zones list
            if (state is ZoneLoading && _zonesCache.isNotEmpty) {
              return _buildZonesList(context, _zonesCache);
            }

            if (state is ZoneLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city_outlined, size: 80.sp, color: Colors.grey),
            SizedBox(height: 24.h),
            Text(
              'No zones created yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Create your first monitoring zone to start tracking crowds in specific areas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ElevatedButton.icon(
                onPressed: () => _navigateToCreateZone(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: Text(
                  'Create First Zone',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'How it works:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoStep('1', 'Create a zone with capacity limits'),
                  SizedBox(height: 8.h),
                  _buildInfoStep('2', 'Start live monitoring session'),
                  SizedBox(height: 8.h),
                  _buildInfoStep('3', 'Connect devices to count people'),
                  SizedBox(height: 8.h),
                  _buildInfoStep('4', 'Get alerts when limits are reached'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZonesList(BuildContext context, List<ZoneModel> zones) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ZoneBloc>().add(LoadUserZone());
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return GestureDetector(
            onTap: () {
              // Navigate to live view if zone is active, otherwise show zone details
              if (zone.isActive && zone.roomId != null) {
                _navigateToLiveView(context, zone.roomId!, zone);
              } else {
                _showZoneDetailsDialog(context, zone);
              }
            },
            child: ZoneCard(
              zone: zone,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ZoneForm(zone: zone)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showZoneDetailsDialog(BuildContext context, ZoneModel zone) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.surfaceColor,
            title: Text(
              zone.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow(
                  'Capacity',
                  '${zone.currentCount}/${zone.maximumCount} people',
                ),
                _buildDetailRow('Alert Threshold', '${zone.threshold} people'),
                _buildDetailRow(
                  'Status',
                  zone.isActive ? 'Active' : 'Inactive',
                ),
                if (zone.roomId != null)
                  _buildDetailRow('Room ID', zone.roomId!),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ),
              if (!zone.isActive)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<ZoneBloc>().add(StartVideoSession());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Start Session'),
                ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateZone(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ZoneForm()));
  }

  List<ZoneModel> _getZonesFromState(ZoneState state) {
    if (state is ZoneLoaded) return state.zones;
    if (state is ZoneCreated) return state.zones;
    if (state is ZoneUpdated) return state.zones;
    if (state is ZoneDeleted) return state.zones;
    if (state is VideoSessionStarted) return state.zones;
    if (state is VideoSessionEnded) return state.zones;
    return [];
  }

  void _navigateToLiveView(
    BuildContext context,
    String roomId,
    ZoneModel zone,
  ) {
    // Use the zone's specific token instead of default
    final token =
        zone.zoneToken.isNotEmpty
            ? zone.zoneToken
            : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI5YjQ4ODEwOC0wNjk0LTQ1ZGMtOGM2ZC1hNzQ1NmY1MGEzN2QiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcwODk2MzU0MSwiZXhwIjoxNzE2NzM5NTQxfQ.BruXhAuGULv-BW-8KQIjPNa8u3DjZhDL8YCUW6YSyGU';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ZoneLiveView(zone: zone, token: token, roomId: roomId),
      ),
    );
  }
}
