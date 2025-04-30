import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotel.dart';
import 'package:hotel_list_app/features/hotels/presentation/pages/hotel_detail_page.dart';
import 'package:hotel_list_app/features/hotels/presentation/viewmodels/hotel_viewmodel.dart';
import 'package:hotel_list_app/features/hotels/presentation/widgets/filter_bottom_sheet.dart';
import 'package:hotel_list_app/features/hotels/presentation/widgets/hotel_card.dart';
import 'package:hotel_list_app/features/hotels/presentation/widgets/shimmer_box.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({Key? key}) : super(key: key);

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  StreamSubscription? _linkSub;
  String? _pendingHotelName;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _listenToInitialUri();
    _listenToLiveUriStream();
    Future.microtask(() {
      final vm = Provider.of<HotelViewModel>(context, listen: false);
      vm.loadHotelsData();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _debounceScroll(
                Provider.of<HotelViewModel>(context, listen: false));
          });
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = context.read<HotelViewModel>();
    viewModel.addListener(() {
      if (!_handled && _pendingHotelName != null) {
        _tryHandlePendingNavigation();
      }
    });
  }

  Future<void> _listenToInitialUri() async {
    try {
      final uri = await getInitialUri();
      _parseDeepLink(uri);
    } catch (e) {
      debugPrint('Initial URI error: $e');
    }
  }

  void _listenToLiveUriStream() {
    _linkSub = uriLinkStream.listen((Uri? uri) {
      _parseDeepLink(uri);
    }, onError: (e) {
      debugPrint("Stream URI error: $e");
    });
  }

  void _parseDeepLink(Uri? uri) {
    if (uri != null) {
      _pendingHotelName = Uri.decodeComponent(uri.pathSegments[0]);
      _tryHandlePendingNavigation();
    }
  }

  void _tryHandlePendingNavigation() {
    if (_handled || _pendingHotelName == null) return;

    final viewModel = context.read<HotelViewModel>();

    if (viewModel.hotels.isNotEmpty) {
      final normalized = _pendingHotelName!.toLowerCase().trim();

      List<Hotel> target = viewModel.hotels
          .where(
            (h) => h.name.toLowerCase().trim() == normalized,
          )
          .toList();

      if (target.isNotEmpty) {
        _handled = true;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HotelDetailPage(hotel: target.first),
          ),
        );
      }
      _pendingHotelName = null; // clear it
    }
  }

  void _debounceScroll(HotelViewModel vm) {
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(const Duration(milliseconds: 300), () {
      vm.loadMoreHotels();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HotelViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Hotels')),
          body: vm.isLoading
              ? const _HotelListLoadingSkeleton()
              : vm.hasError
                  ? _buildErrorState(vm)
                  : Column(
                      children: [
                        if (vm.quickFilters.isNotEmpty)
                          SizedBox(
                            height: 50,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.quickFilters.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final filter = vm.quickFilters[index];
                                final isSelected =
                                    vm.isQuickFilterSelected(filter.id);
                                return Container(
                                  key: Key('quick_filter_$index'),
                                  child: ChoiceChip(
                                    label: Text(filter.name),
                                    selected: isSelected,
                                    onSelected: (_) =>
                                        vm.toggleQuickFilter(filter.id),
                                    selectedColor: Colors.blueAccent,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(8),
                            itemCount:
                                vm.hotels.length + (vm.isFetchingMore ? 2 : 0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (_, index) {
                              if (index >= vm.hotels.length) {
                                return const _HotelCardShimmer();
                              }
                              return HotelCard(
                                  hotel: vm.hotels[index], index: index);
                            },
                          ),
                        ),
                      ],
                    ),
          floatingActionButton: FloatingActionButton.extended(
            key: Key('open_filter_sheet_button'),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => FilterBottomSheet(
                  allFilters: vm.filters,
                  selectedFilters: vm.selectedCategoryIds,
                  onApply: (selected) {
                    vm.applySelectedFilters(selected);
                    Navigator.of(context).pop();
                  },
                  onClear: () {
                    vm.clearAllFilters();
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            icon: const Icon(Icons.filter_list),
            label: vm.selectedCategoryIds.isNotEmpty
                ? Text('Filters (${vm.selectedCategoryIds.length})')
                : const Text('Filter'),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(HotelViewModel vm) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(vm.errorMessage ?? 'Something went wrong.'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: vm.retry,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _HotelCardShimmer extends StatelessWidget {
  const _HotelCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerBox(width: double.infinity, height: 120),
        SizedBox(height: 8),
        ShimmerBox(width: 100, height: 14),
        SizedBox(height: 4),
        ShimmerBox(width: 60, height: 12),
      ],
    );
  }
}

class _HotelListLoadingSkeleton extends StatelessWidget {
  const _HotelListLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // QUICK FILTER SHIMMER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, __) => const ShimmerBox(width: 80, height: 30),
            ),
          ),
        ),

        // GRID SHIMMER
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (_, __) => const _HotelCardShimmer(),
          ),
        ),
      ],
    );
  }
}
