import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/providers/providers.dart';

class MapSection extends ConsumerStatefulWidget {
  const MapSection({super.key});

  @override
  ConsumerState<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends ConsumerState<MapSection> {
  final MapController _mapController = MapController();

  void _centerMap(Position position) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        _mapController.camera.zoom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final geolocationService = ref.watch(geolocationServiceProvider);

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<Position>(
        stream: geolocationService.getPositionStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.location_off, color: Theme.of(context).colorScheme.error),
            );
          }

          final position = snapshot.data;
          if (position == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Schedule map centering after build
          _centerMap(position);

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(position.latitude, position.longitude),
              initialZoom: 13,
              minZoom: 5,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'pw.landon.yourtour',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(position.latitude, position.longitude),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
} 