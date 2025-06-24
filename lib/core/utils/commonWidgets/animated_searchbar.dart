import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String)? onSearch;

  const AnimatedSearchBar({super.key, this.onSearch});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();


    _focusNode.addListener(() {
      setState(() {
        _isExpanded = _focusNode.hasFocus;
      });
    });

    _controller.addListener(() {
      // This ensures the clear icon appears/disappears as user types
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearText() {
    _controller.clear();
    widget.onSearch?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    const double collapsedSize = 44;

    return SizedBox(
      height: AppDimensions.screenHeight * 0.08,
      width: AppDimensions.screenWidth,
      child: Stack(
        children: [
          // Expanded Search Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 8,
            right: _isExpanded ? 0 : 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isExpanded
                  ? MediaQuery.of(context).size.width * 0.9
                  : collapsedSize,
              height: collapsedSize,
              constraints:  BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  if (_isExpanded)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  if (_isExpanded) const SizedBox(width: 15),
                  if (_isExpanded) const Icon(Icons.search, color: Colors.grey),
                  if (_isExpanded) const SizedBox(width: 8),
                  if (_isExpanded)
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        cursorColor: Colors.black,
                        style:  TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.gray8),
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        onChanged: widget.onSearch,
                      ),
                    ),

                  if (_isExpanded && _controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: _clearText,
                    ),
                ],
              ),
            ),
          ),

          // Collapsed Icon
          if (!_isExpanded)
            Positioned(
              top: 8,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                  _focusNode.requestFocus();
                },
                child: Container(
                  width: collapsedSize,
                  height: collapsedSize,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
