import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_event.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_state.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/review/presentation/view/review_section.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailView extends StatefulWidget {
  final ItemEntity item;

  const ItemDetailView({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<ReviewViewModel>()),
        BlocProvider(create: (_) => serviceLocator<BorrowedItemsBloc>()),
      ],
      child: BlocBuilder<ItemViewModel, ItemState>(
        builder: (context, state) {
          final currentItem = state.items.firstWhere(
            (i) => i.id == widget.item.id,
            orElse: () => widget.item,
          );

          return Scaffold(
            backgroundColor: colorScheme.background,
            body: SafeArea(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(context, currentItem),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 16),
                            _buildImageCarousel(),
                            const SizedBox(height: 8),
                            if (widget.item.imageUrls.length > 1) ...[
                              _buildImageIndicator(),
                              const SizedBox(height: 24),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.item.name,
                                    style: textTheme.titleLarge?.copyWith(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Rs ${widget.item.borrowingPrice.toStringAsFixed(2)}/Day',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontSize: 22,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Description",
                              style: textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.item.description,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            _buildOwnerInfoWithTheme(context),
                            const SizedBox(height: 24),
                            ReviewSection(
                              itemId: widget.item.id!,
                              averageRating: widget.item.rating ?? 0.0,
                            ),
                            const SizedBox(height: 24),
                          ]),
                        ),
                      ),
                    ],
                  ),

                  // --- Borrow Button (Themed + Snackbar) ---
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: BlocListener<BorrowedItemsBloc, BorrowedItemsState>(
                      listener: (context, state) {
                        if (state is BorrowActionSuccess) {
                          showMySnackBar(
                            context: context,
                            message: state.message,
                            type: SnackBarType.success,
                          );
                          Navigator.pop(context);
                        } else if (state is BorrowedItemsError) {
                          showMySnackBar(
                            context: context,
                            message: state.message,
                            type: SnackBarType.error,
                          );
                        }
                      },
                      child: BlocBuilder<BorrowedItemsBloc, BorrowedItemsState>(
                        builder: (context, state) {
                          final isLoading = state is BorrowedItemsLoading;
                          return ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      context.read<BorrowedItemsBloc>().add(
                                        CreateBorrowRequest(widget.item.id!),
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child:
                                isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text("Borrow Now"),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    ItemEntity currentItem,
  ) {
    final theme = Theme.of(context);
    final color = theme.appBarTheme.iconTheme?.color ?? Colors.black;

    return SliverAppBar(
      pinned: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      centerTitle: true,
      title: Text("Details", style: theme.appBarTheme.titleTextStyle),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(
              currentItem.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border_outlined,
              color:
                  currentItem.isBookmarked ? theme.colorScheme.primary : color,
            ),
            onPressed: () {
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
                  (_, __, ___) => Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey[400],
                    size: 80,
                  ),
              loadingBuilder:
                  (context, child, loading) =>
                      loading == null
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
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildOwnerInfoWithTheme(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Listed by", style: textTheme.titleLarge),
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
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.item.owner?.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.item.owner!.location!,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined),
                tooltip: 'Call Owner',
                color: colorScheme.primary,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined),
                tooltip: 'Message Owner',
                color: colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
