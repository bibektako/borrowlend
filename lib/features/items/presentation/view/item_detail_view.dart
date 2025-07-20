import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailView extends StatefulWidget {
  final ItemEntity item;

  const ItemDetailView({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round();
      if (newPage != null && newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemViewModel, ItemState>(
      builder: (context, state) {
        final currentItem = state.items.firstWhere(
          (i) => i.id == widget.item.id,
          orElse:
              () => widget.item, // Fallback to the initial item if not found
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, currentItem),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),
                      _buildImageCarousel(),
                      const SizedBox(height: 8),
                      if (widget.item.imageUrls.length > 1) ...[
                        _buildImageIndicator(),
                        const SizedBox(height: 24),
                      ] else ...[
                        const SizedBox(height: 16),
                      ],
                      _buildTitleAndPrice(),
                      const SizedBox(height: 24),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildOwnerInfo(),
                      const SizedBox(height: 24),
                      _buildReviewSection(),
                      const SizedBox(height: 40),
                      _buildBorrowButton(),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    ItemEntity currentItem,
  ) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      centerTitle: true,
      title: const Text(
        "Details",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(
              currentItem.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border_outlined,
              color:
                  currentItem.isBookmarked ? Colors.blueAccent : Colors.black,
            ),
            onPressed: () {
              // 6. DISPATCH THE EVENT to the ItemViewModel.
              context.read<ItemViewModel>().add(
                ToggleBookmarkEvent(
                  itemId: currentItem.id!,
                  isCurrentlyBookmarked: currentItem.isBookmarked,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: PageView.builder(
          controller: _pageController,
          itemCount:
              widget.item.imageUrls.isNotEmpty
                  ? widget.item.imageUrls.length
                  : 1,
          itemBuilder: (context, index) {
            if (widget.item.imageUrls.isEmpty) {
              return Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 80,
              );
            }

            String imagePath = widget.item.imageUrls[index];
            if (imagePath.startsWith('/')) {
              imagePath = imagePath.substring(1);
            }
            final imageUrl = '${ApiEndpoints.serverAddress}/$imagePath';
            

            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey[400],
                    size: 80,
                  ),
              loadingBuilder:
                  (context, child, progress) =>
                      progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.item.imageUrls.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color:
                _currentPage == index
                    ? Colors.blueAccent
                    : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '\Rs${widget.item.borrowingPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Listed by",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.owner?.username ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.item.owner?.location != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.item.owner!.location!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, color: Colors.blue),
                tooltip: 'Call Owner',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined, color: Colors.green),
                tooltip: 'Message Owner',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextButton(onPressed: () {}, child: const Text("See All")),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Text(
                (widget.item.rating ?? 0.0).toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.star, color: Colors.amber, size: 32),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Based on user reviews. More reviews coming soon!",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBorrowButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF111827),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        "Borrow Now",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
