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
    // Fetch all requests when the page loads
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
            // --- THE NEW, SIMPLER FILTER ---
            // Keep any request where the current user is either the owner OR the borrower.
            final history = state.requests.where((r) {
              return r.owner.id == currentUserId || r.borrower.id == currentUserId;
            }).toList();

            if (history.isEmpty) {
              return const Center(child: Text("You have no transaction history."));
            }

            // Display the full history
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final request = history[index];
                final bool amIOwner = request.owner.id == currentUserId;
                final otherParty = amIOwner ? request.borrower.username : request.owner.username;
                final transactionType = amIOwner ? "Lent to" : "Borrowed from";

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      amIOwner ? Icons.arrow_upward : Icons.arrow_downward,
                      color: amIOwner ? Colors.green : Colors.blue,
                    ),
                    title: Text(
                      request.item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$transactionType $otherParty"),
                    trailing: Text(
                      request.status.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
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
}