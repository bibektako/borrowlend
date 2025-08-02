import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_event.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_state.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';

class TransactionHistoryPage extends StatelessWidget {
  final String currentUserId;

  const TransactionHistoryPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future.microtask(() {
      context.read<BorrowedItemsBloc>().add(FetchBorrowRequests());
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: BlocBuilder<BorrowedItemsBloc, BorrowedItemsState>(
        builder: (context, state) {
          if (state is BorrowedItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BorrowedItemsError) {
            return Center(child: Text(state.message));
          }

          if (state is BorrowedItemsLoaded) {
            final history =
                state.requests.where((r) {
                  return r.owner.id == currentUserId ||
                      r.borrower.id == currentUserId;
                }).toList();

            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "You have no transaction history yet.",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final request = history[index];
                final bool amIOwner = request.owner.id == currentUserId;
                final otherParty =
                    amIOwner
                        ? request.borrower.username
                        : request.owner.username;
                final transactionType = amIOwner ? "Lent to" : "Borrowed from";
                final isReturned = request.status.toLowerCase() == "returned";

                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          amIOwner
                              ? Colors.green.withOpacity(0.15)
                              : Colors.blue.withOpacity(0.15),
                      child: Icon(
                        amIOwner
                            ? Icons.upload_rounded
                            : Icons.download_rounded,
                        color: amIOwner ? Colors.green : Colors.blue,
                      ),
                    ),
                    title: Text(
                      request.item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "$transactionType $otherParty",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          request.status,
                          theme,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _statusColor(request.status, theme),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("No data."));
        },
      ),
    );
  }

  Color _statusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "returned":
        return Colors.blue;
      case "denied":
        return Colors.red;
      default:
        return theme.colorScheme.onSurface.withOpacity(0.6);
    }
  }
}
