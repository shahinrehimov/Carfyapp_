import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/presentation/map_picker/map_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class MapPickerPage extends StatefulWidget implements AutoRouteWrapper {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPickerPage({super.key, this.initialLatitude, this.initialLongitude});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => MapPickerCubit(
      initial: initialLatitude != null && initialLongitude != null ? LatLng(initialLatitude!, initialLongitude!) : null,
    ),
    child: this,
  );

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late final MapPickerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MapPickerCubit>();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapPickerCubit, MapPickerState>(
      listenWhen: (prev, curr) => curr.moveToPosition != null && prev.moveToPosition != curr.moveToPosition,
      listener: (context, state) {
        _mapController.move(state.moveToPosition!, 15);
        _cubit.onMapMoved();
      },
      child: Scaffold(
        appBar: CustomAppBarWhite(title: context.localization.mapPickerTitle),
        body: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(widget.initialLatitude ?? 40.4093, widget.initialLongitude ?? 49.8671),
                initialZoom: 13,
                onPositionChanged: (position, _) {
                  _cubit.updatePosition(position.center);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.carfy.app',
                ),
              ],
            ),

            // Fixed center pin
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Icon(Icons.location_pin, size: 48, color: Color(0xFF00569C)),
              ),
            ),

            // Search bar + results
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Column(
                children: [
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: BlocBuilder<MapPickerCubit, MapPickerState>(
                      buildWhen: (prev, curr) => prev.isSearching != curr.isSearching,
                      builder: (context, state) => TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onChanged: _cubit.searchPlaces,
                        onSubmitted: _cubit.searchPlaces,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: context.localization.mapPickerSearch,
                          hintStyle: TextStyle(fontSize: 14, color: context.theme.colors.textLight),
                          prefixIcon: state.isSearching
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.theme.colors.primary,
                                    ),
                                  ),
                                )
                              : Icon(Icons.search, color: context.theme.colors.textLight, size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.close, size: 18, color: context.theme.colors.textLight),
                                  onPressed: () {
                                    _searchController.clear();
                                    _cubit.clearSearch();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),

                  // Results dropdown
                  BlocBuilder<MapPickerCubit, MapPickerState>(
                    buildWhen: (prev, curr) => prev.searchResults != curr.searchResults,
                    builder: (context, state) {
                      if (state.searchResults.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.searchResults.map((result) {
                            return InkWell(
                              onTap: () {
                                _searchController.text = result.displayName.split(',').first.trim();
                                _cubit.selectSearchResult(result);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 18, color: context.theme.colors.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        result.displayName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13, color: context.theme.colors.textDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Current location button
            Positioned(
              right: 12,
              bottom: 90,
              child: BlocBuilder<MapPickerCubit, MapPickerState>(
                buildWhen: (prev, curr) => prev.isLocating != curr.isLocating,
                builder: (context, state) => GestureDetector(
                  onTap: state.isLocating ? null : _cubit.goToCurrentLocation,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: state.isLocating
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.colors.primary),
                          )
                        : Icon(Icons.my_location, size: 22, color: context.theme.colors.primary),
                  ),
                ),
              ),
            ),

            // Confirm button
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: BlocBuilder<MapPickerCubit, MapPickerState>(
                buildWhen: (prev, curr) => prev.position != curr.position,
                builder: (context, state) => CustomButton(
                  text: context.localization.mapPickerConfirm,
                  onPressed: () => context.maybePop(state.position),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
