import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_event.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_state.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BorrowRequestsPage extends StatefulWidget {
  final String currentUserId;

  const BorrowRequestsPage({super.key, required this.currentUserId});

  @override
  State<BorrowRequestsPage> createState() => _BorrowRequestsPageState();
}

class _BorrowRequestsPageState extends State<BorrowRequestsPage> {
  static const String _baseImageUrl = "http://localhost:5050/";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BorrowedItemsBloc>().add(FetchBorrowRequests());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Borrow Requests")),
      body: BlocConsumer<BorrowedItemsBloc, BorrowedItemsState>(
        listener: (context, state) {
          if (state is BorrowActionSuccess) {
            showMySnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
          } else if (state is BorrowedItemsError) {
            showMySnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is BorrowedItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BorrowedItemsLoaded) {
            final filtered =
                state.requests.where((r) {
                  final amIOwner = r.owner.id == widget.currentUserId;
                  final isPending = [
                    'pending',
                    'approved',
                    'requested',
                  ].contains(r.status.toLowerCase());
                  return amIOwner && isPending;
                }).toList();

            if (filtered.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No pending borrow requests.",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final request = filtered[index];
                final item = request.item;
                final imageUrl =
                    item.imageUrls.isNotEmpty
                        ? _baseImageUrl + item.imageUrls.first
                        : null;

                final isApproved = request.status.toLowerCase() == 'approved';

                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    height: 180,
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "⚠️ Unable to load image",
                                    ),
                                  ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          item.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Requested by: ${request.borrower.username}",
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isApproved)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.undo),
                                label: const Text("Cancel Approval"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<BorrowedItemsBloc>().add(
                                    UpdateBorrowRequestStatus(
                                      request.id ?? '',
                                      'pending',
                                    ),
                                  );
                                  showMySnackBar(
                                    context: context,
                                    message:
                                        "Approval cancelled for '${item.name}'",
                                    type: SnackBarType.success,
                                  );
                                },
                              )
                            else ...[
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text("Approve"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<BorrowedItemsBloc>().add(
                                    UpdateBorrowRequestStatus(
                                      request.id ?? '',
                                      'approved',
                                    ),
                                  );
                                  showMySnackBar(
                                    context: context,
                                    message:
                                        "Approved request for '${item.name}'",
                                    type: SnackBarType.success,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text("Deny"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<BorrowedItemsBloc>().add(
                                    UpdateBorrowRequestStatus(
                                      request.id ?? '',
                                      'denied',
                                    ),
                                  );
                                  showMySnackBar(
                                    context: context,
                                    message:
                                        "Denied request for '${item.name}'",
                                    type: SnackBarType.success,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is BorrowedItemsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
