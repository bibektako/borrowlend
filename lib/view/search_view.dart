import 'package:borrowlend/core/common/app_header.dart';
import 'package:borrowlend/features/category/presentation/view/category_explorer.dart';
import 'package:borrowlend/core/common/most_borrowed.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Adjust height as needed
        child: SafeArea(
          // Optional: Avoid status bar overlap
          child: AppHeader(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 361,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xffE4E7EC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(width: 2, color: const Color(0xffE4E7EC)),
                boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.grey)],
              ),
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.search),
            ),
            const SizedBox(height: 18),
            CategoryExplorer(),
            const SizedBox(height: 18),
            MostBorrowed(),
          ],
        ),
      ),
    );
  }
}
