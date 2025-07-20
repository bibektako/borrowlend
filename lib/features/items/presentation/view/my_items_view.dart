import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/view/add_items_view.dart';
import 'package:borrowlend/features/items/presentation/view/edit_item_view.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyItemsView extends StatelessWidget {
  const MyItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<ItemViewModel>()..add(LoadMyItemsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Listed Items'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<ItemViewModel>(), 
                    ),
                    BlocProvider.value(
                      value: context.read<CategoryBloc>(), // Pass existing CategoryBloc
                    ),
                  ],
                  child: const AddItemView(),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          // Allow the user to pull-to-refresh the list.
          onRefresh: () async {
            context.read<ItemViewModel>().add(LoadMyItemsEvent());
          },
          // BlocBuilder rebuilds the UI in response to state changes.
          child: BlocBuilder<ItemViewModel, ItemState>(
            builder: (context, state) {
              // Handle the initial loading state.
              if (state.status == ItemStatus.loading && state.myItems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle the failure state.
              if (state.status == ItemStatus.failure) {
                return Center(
                    child: Text(state.errorMessage ?? 'Could not load your items.'));
              }

              // Handle the empty state (after loading is complete).
              if (state.myItems.isEmpty) {
                return const Center(
                  child: Text(
                    'You have not listed any items yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // On success, display the list of items.
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80), // Space for FAB
                itemCount: state.myItems.length,
                itemBuilder: (context, index) {
                  final item = state.myItems[index];
                  // Use a dedicated widget for the list tile for cleanliness.
                  return _MyItemTile(item: item);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A custom, stateless tile widget to display a single user-owned item.
class _MyItemTile extends StatelessWidget {
  final ItemEntity item;
  const _MyItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (item.imageUrls.isNotEmpty) {
      String imagePath = item.imageUrls.first;
      if (imagePath.startsWith('/')) {
        imagePath = imagePath.substring(1);
      }
      imageUrl = '${ApiEndpoints.serverAddress}/$imagePath';
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 70,
                height: 70,
                child: imageUrl != null
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Status: ${item.status}',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
              tooltip: 'Edit Item',
              onPressed: () {
                // Navigate to the EditItemView, passing the ViewModel and the item to edit.
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                       BlocProvider.value(
                        value: context.read<ItemViewModel>(),
                      ),
                       BlocProvider.value(
                        value: context.read<CategoryBloc>(),
                      ),
                    ],
                    child: const EditItemView(),
                  ),
                  // Pass the item to be edited via RouteSettings arguments.
                  settings: RouteSettings(arguments: item),
                ));
              },
            ),
            // --- DELETE BUTTON ---
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Delete Item',
              onPressed: () async {
                // Show a confirmation dialog before deleting.
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to permanently delete this item?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                // If the user confirmed, dispatch the DeleteItemEvent.
                if (confirm == true) {
                  context.read<ItemViewModel>().add(DeleteItemEvent(itemId: item.id!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}