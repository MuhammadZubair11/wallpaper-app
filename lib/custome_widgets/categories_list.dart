import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/view_models/catogries_view%20model.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final Function(String) onTap;
  // constructor call kraaa ga ab
  const CategoryList({Key? key, required this.categories, required this.onTap})
    : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    // oof set  logic
    final offset = (index * 100.0) - screenWidth / 2 + 50;
    scrollController.animateTo(
      // scroll method ha jo list ko auto pichay kara ga
      offset.clamp(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent,
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<ChipSelectionProvider>(context);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = selectedProvider.selected == category;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                selectedProvider.selectChip(category);
                widget.onTap(category);

                // Scroll automatically
                _scrollToIndex(index);
              },
              child: Chip(
                label: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: isSelected
                    ? Colors.brown
                    : Colors.black.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
