import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotel.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailPage({Key? key, required this.hotel}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  int _currentImage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('hotel_detail_page'),
      body: CustomScrollView(
        slivers: [
          _buildImageCarousel(context),
          SliverToBoxAdapter(child: _buildHotelInfo(context)),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.hotel.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _currentImage = index);
              },
              itemBuilder: (_, index) {
                return Hero(
                  tag: widget.hotel.name, // same tag used from list screen!
                  child: CachedNetworkImage(
                    imageUrl: widget.hotel.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                );
              },
            ),

            // Close button
            Positioned(
              top: 60,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),

            // Page indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.hotel.imageUrls.length, (index) {
                  final isActive = _currentImage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 8 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      key: const Key('hotel_title'),
                      widget.hotel.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.hotel.city,
                      style: TextStyle(color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.hotel.openingHours != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text("Opening hours:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.hotel.openingHours!),
              ],
            ),
          if (widget.hotel.overviewText != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  widget.hotel.overviewText!,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          const SizedBox(height: 16),
          ...widget.hotel.thingsToDo
              .map((thing) => _buildThingToDoCard(thing))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildThingToDoCard(HotelThingToDo thing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                thing.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            if (thing.badge != null)
              Container(
                constraints: const BoxConstraints(maxWidth: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  thing.badge!,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
          ],
        ),
        subtitle: thing.subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  thing.subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )
            : null,
        children: [
          if (thing.content != null)
            ...thing.content!.expand(
              (group) => group.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 6, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(item.text)),
                    ],
                  ),
                ),
              ),
            ),
          if (thing.items != null && thing.items!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: thing.items!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final item = thing.items![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: 140,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 140,
                              height: 100,
                              color: Colors.grey.shade200,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 140,
                              height: 100,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        if (item.title != null && item.title!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SizedBox(
                              width: 140,
                              child: Text(
                                item.title!,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
