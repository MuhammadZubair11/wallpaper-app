import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  // controler bana aya
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onSearch;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onSearch,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      // to just clear function ka liy ause ki bs
      setState(() {
        showClear = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        controller: widget.controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: "Search wallpaper......... 🙉",
          hintStyle: TextStyle(color: Colors.white70),
          suffixIcon: showClear
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear();
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onSubmitted: widget.onSearch,
      ),
    );
  }
}
