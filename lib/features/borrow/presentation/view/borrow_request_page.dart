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
  static const String _baseImageUrl =
      "http://localhost:5050/"; // 👈 Change to IP if testing on device

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      debugPrint("🔄 Dispatching FetchBorrowRequests");
      context.read<BorrowedItemsBloc>().add(FetchBorrowRequests());
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("👤 currentUserId: ${widget.currentUserId}");

    return Scaffold(
      appBar: AppBar(title: const Text("Borrow Requests")),
      body: BlocBuilder<BorrowedItemsBloc, BorrowedItemsState>(
        builder: (context, state) {
          if (state is BorrowedItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BorrowedItemsError) {
            debugPrint("❌ Error loading borrow requests: ${state.message}");
            return Center(child: Text(state.message));
          }

          if (state is BorrowedItemsLoaded) {
            debugPrint(
              "✅ Loaded ${state.requests.length} total borrow requests",
            );

            for (var req in state.requests) {
              debugPrint("📦 Borrow Request:");
              debugPrint("   ▶ requestId: ${req.id}");
              debugPrint("   ▶ item: ${req.item.name}");
              debugPrint("   ▶ ownerId: ${req.owner.id}");
              debugPrint("   ▶ borrower: ${req.borrower.username}");
              debugPrint("   ▶ status: ${req.status}");
            }

            final filtered =
                state.requests.where((r) {
                  final amIOwner = r.owner.id == widget.currentUserId;
                  final isOngoing = [
                    'pending',
                    'approved',
                    'requested',
                  ].contains(r.status.toLowerCase());
                  return amIOwner && isOngoing;
                }).toList();

            debugPrint("📥 Total filtered requests: ${filtered.length}");

            if (filtered.isEmpty) {
              return const Center(child: Text("No pending requests."));
            }

            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final request = filtered[index];
                final item = request.item;
                final imageUrl =
                    item.imageUrls.isNotEmpty
                        ? _baseImageUrl + item.imageUrls.first
                        : null;

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
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Text("⚠️ Failed to load image"),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Requested by: ${request.borrower.username}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text("Approve"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                context.read<BorrowedItemsBloc>().add(
                                  UpdateBorrowRequestStatus(
                                    request.id ?? '',
                                    'approved',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.close),
                              label: const Text("Deny"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                context.read<BorrowedItemsBloc>().add(
                                  UpdateBorrowRequestStatus(
                                    request.id ?? '',
                                    'denied',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
