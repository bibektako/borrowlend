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
    Future.microtask(() {
      debugPrint("📤 Dispatching FetchBorrowRequests from OngoingBorrowPage");
      context.read<BorrowedItemsBloc>().add(FetchBorrowRequests());
    });

    return Scaffold(
      appBar: AppBar(title: const Text("My Borrowed Items")),
      body: BlocBuilder<BorrowedItemsBloc, BorrowedItemsState>(
        builder: (context, state) {
          if (state is BorrowedItemsLoading) {
            debugPrint("🔄 State: Loading Borrow Requests...");
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BorrowedItemsError) {
            debugPrint("❌ Error State: ${state.message}");
            return Center(child: Text(state.message));
          }

          if (state is BorrowedItemsLoaded) {
            debugPrint("✅ BorrowRequests Loaded: ${state.requests.length}");

            final ongoing = state.requests.where((r) {
              final isBorrower = r.borrower.id == currentUserId;
              final isOngoing = ['pending', 'approved', 'requested']
      .contains(r.status.toLowerCase());

              debugPrint(
                  "🔍 Borrow Check - requestId=${r.id}, borrowerMatch=$isBorrower, statusMatch=$isOngoing");

              return isBorrower && isOngoing;
            }).toList();

            debugPrint("📦 Total ongoing borrows (after filter): ${ongoing.length}");

            if (ongoing.isEmpty) {
              return const Center(child: Text("No ongoing borrows."));
            }

            return ListView.builder(
              itemCount: ongoing.length,
              itemBuilder: (context, index) {
                final request = ongoing[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.item.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Status: ${request.status}"),
                        const SizedBox(height: 12),
                        if (request.status == 'requested' || request.status == 'pending')
                          const Text(
                            "⏳ Waiting for approval...",
                            style: TextStyle(color: Colors.orange),
                          ),
                        if (request.status == 'approved') ...[
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Payment gateway coming soon."),
                                ),
                              );
                            },
                            child: const Text("Pay Now"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              context.read<BorrowedItemsBloc>().add(
                                    UpdateBorrowRequestStatus(
                                        request.id!, 'returned'),
                                  );
                            },
                            child: const Text("Return Item"),
                          ),
                        ]
                      ],
                    ),
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
