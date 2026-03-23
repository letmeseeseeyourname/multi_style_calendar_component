import 'package:flutter/material.dart';

/// CupertinoPicker 风格的单列滚轮选择器
class WheelPicker extends StatefulWidget {
  /// 选项数量
  final int itemCount;

  /// 初始选中项索引
  final int initialIndex;

  /// 每项的高度
  final double itemExtent;

  /// 构建每项的文字标签
  final String Function(int index) labelBuilder;

  /// 选中项变化回调
  final ValueChanged<int>? onSelectedItemChanged;

  /// 是否循环滚动
  final bool looping;

  /// 选中项文字样式
  final TextStyle? selectedTextStyle;

  /// 未选中项文字样式
  final TextStyle? unselectedTextStyle;

  const WheelPicker({
    super.key,
    required this.itemCount,
    this.initialIndex = 0,
    this.itemExtent = 40,
    required this.labelBuilder,
    this.onSelectedItemChanged,
    this.looping = false,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  late FixedExtentScrollController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.itemCount - 1);
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedStyle =
        widget.selectedTextStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        );

    final unselectedStyle =
        widget.unselectedTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

    return Stack(
      children: [
        // 选中区域高亮
        Center(
          child: Container(
            height: widget.itemExtent,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
            ),
          ),
        ),
        // 滚轮列表
        ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: widget.itemExtent,
          perspective: 0.005,
          diameterRatio: 1.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() => _currentIndex = index);
            widget.onSelectedItemChanged?.call(index);
          },
          childDelegate: widget.looping
              ? ListWheelChildLoopingListDelegate(
                  children: List.generate(widget.itemCount, (index) {
                    return _buildItem(
                      index,
                      index == _currentIndex ? selectedStyle : unselectedStyle,
                    );
                  }),
                )
              : ListWheelChildBuilderDelegate(
                  childCount: widget.itemCount,
                  builder: (context, index) {
                    return _buildItem(
                      index,
                      index == _currentIndex ? selectedStyle : unselectedStyle,
                    );
                  },
                ),
        ),
        // 上下渐变遮罩
        Positioned.fill(
          child: IgnorePointer(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: widget.itemExtent),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index, TextStyle? style) {
    return Center(
      child: Text(
        widget.labelBuilder(index),
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
