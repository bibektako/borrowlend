import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_event.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_state.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';

class OngoingBorrowPage extends StatelessWidget {
  final String currentUserId;

  const OngoingBorrowPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Future.microtask(() {
      context.read<BorrowedItemsBloc>().add(FetchBorrowRequests());
    });

    return Scaffold(
      appBar: AppBar(title: const Text("My Borrowed Items")),
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
            final ongoing =
                state.requests.where((r) {
                  final isBorrower = r.borrower.id == currentUserId;
                  final isOngoing = [
                    'pending',
                    'approved',
                    'requested',
                  ].contains(r.status.toLowerCase());
                  return isBorrower && isOngoing;
                }).toList();

            if (ongoing.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No ongoing borrows.",
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
              itemCount: ongoing.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final request = ongoing[index];

                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.item.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            "Status: ${request.status.toUpperCase()}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if ([
                        'requested',
                        'pending',
                      ].contains(request.status)) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 20,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Waiting for approval...",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ] else if (request.status == 'approved') ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text("Pay Now"),
                          onPressed: () {
                            showMySnackBar(
                              context: context,
                              message: "Payment gateway coming soon.",
                              type: SnackBarType.info,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.undo),
                          label: const Text("Return Item"),
                          onPressed: () {
                            context.read<BorrowedItemsBloc>().add(
                              UpdateBorrowRequestStatus(
                                request.id!,
                                'returned',
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text("⚠️ No data available."));
        },
      ),
    );
  }
}
