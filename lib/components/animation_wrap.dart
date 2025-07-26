import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

class AnimationWrap extends StatefulWidget {
  final double spacing;
  final Padding padding;
  final List<Widget>? children;
  final Key? movingChildKey;
  const AnimationWrap({
    super.key,
    this.children,
    this.padding = const Padding(padding: EdgeInsets.all(AppDimentions.paddingSmall)),
    this.movingChildKey,
    this.spacing = AppDimentions.paddingSmall,
  });

  @override
  State<AnimationWrap> createState() => _AnimationWrapState();
}

class _AnimationWrapState extends State<AnimationWrap> {
  Map<Key, Offset>? _prevPositions;
  // 各子要素のサイズを保持するリスト
  final List<Size> _childrenSizes = [];
  // 各子要素のGlobalKey
  late List<GlobalKey> _childrenKeys;
  // 測定開始時刻（タイムアウト対策）
  DateTime? _measurementStartTime;

  @override
  void initState() {
    super.initState();
    _initKeys();
  }

  @override
  void didUpdateWidget(covariant AnimationWrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children?.length != widget.children?.length) {
      _initKeys();
    }
  }

  void _initKeys() {
    final count = widget.children?.length ?? 0;
    // childrenの数に合わせてGlobalKeyを生成
    final keys = List.generate(count, (_) => GlobalKey());
    _childrenSizes.clear();
    _childrenSizes.addAll(List.generate(count, (_) => Size.zero));
    _childrenKeys = keys;
    _measurementStartTime = null; // 測定時刻をリセット
  }

  // サイズ計測用
  void _onChildLayout(int index, Size size) {
    if (index < _childrenSizes.length && _childrenSizes[index] != size && size.width > 0 && size.height > 0) {
      setState(() {
        _childrenSizes[index] = size;
      });
    }
  }

  // すべての子のサイズが取得できているか（タイムアウト含む）
  bool get _allSizesReady {
    final children = widget.children;
    if (children == null || children.isEmpty) return true;
    
    // タイムアウトチェック（3秒後に強制的に表示）
    if (_measurementStartTime != null) {
      final elapsed = DateTime.now().difference(_measurementStartTime!);
      if (elapsed.inSeconds > 3) {
        return true;
      }
    }
    
    return _childrenSizes.length == children.length &&
           !_childrenSizes.any((s) => s == Size.zero);
  }

  @override
  Widget build(BuildContext context) {
    // BaseScaffoldとの互換性のため、MediaQueryを使用してLayoutBuilderを回避
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth.clamp(0.0, AppDimentions.screenWidth.toDouble());
    final children = widget.children ?? [];
    
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    // まず全ての子のサイズを計測する
    if (!_allSizesReady) {
      // 測定開始時刻を記録
      _measurementStartTime ??= DateTime.now();
      
      // Stackで子を並べてサイズを計測（LayoutBuilderを使わずにサイズ測定）
      return SizedBox(
        width: maxWidth,
        height: 0, // 測定中は高さを0に
        child: Opacity(
          opacity: 0, // 測定中は非表示
          child: Wrap(
            spacing: widget.spacing,
            children: List.generate(children.length, (i) {
              return _MeasureSize(
                key: _childrenKeys[i],
                onChange: (size) => _onChildLayout(i, size),
                child: children[i],
              );
            }),
          ),
        ),
      );
    }

    // タイムアウト時は未測定の子に仮サイズを設定
    final bool isTimedOut = _measurementStartTime != null && 
        DateTime.now().difference(_measurementStartTime!).inSeconds > 3;
    if (isTimedOut) {
      for (int i = 0; i < children.length; i++) {
        if (i >= _childrenSizes.length || _childrenSizes[i] == Size.zero) {
          if (i >= _childrenSizes.length) {
            _childrenSizes.add(const Size(100, 40)); // 仮サイズ
          } else {
            _childrenSizes[i] = const Size(100, 40); // 仮サイズ
          }
        }
      }
    }

    // 各子の座標を計算（下揃え対応）
    final positions = <Offset>[];
    final rowIndices = <List<int>>[];
    final rowHeights = <double>[];
    final rowYs = <double>[];

    double x = 0;
    double y = 0;
    double rowHeight = 0;
    List<int> currentRow = [];

    for (int i = 0; i < children.length; i++) {
      final size = i < _childrenSizes.length ? _childrenSizes[i] : const Size(100, 40);
      if (x + size.width > maxWidth && currentRow.isNotEmpty) {
        // 行を確定 - 現在の行の最大高さを使ってy座標を更新
        rowIndices.add(List.from(currentRow));
        rowHeights.add(rowHeight);
        rowYs.add(y);
        y += rowHeight + widget.spacing;
        x = 0;
        rowHeight = size.height; // 新しい行の最初の要素の高さで初期化
        currentRow.clear();
      } else {
        // 現在の行内で最大高さを更新
        if (size.height > rowHeight) rowHeight = size.height;
      }
      currentRow.add(i);
      x += size.width + widget.spacing;
    }
    // 最終行
    if (currentRow.isNotEmpty) {
      rowIndices.add(List.from(currentRow));
      rowHeights.add(rowHeight);
      rowYs.add(y);
    }

    // 各子の座標を下揃えで計算
    for (int row = 0; row < rowIndices.length; row++) {
      final indices = rowIndices[row];
      final y = rowYs[row];
      double x = 0;
      for (final i in indices) {
        final size = i < _childrenSizes.length ? _childrenSizes[i] : const Size(100, 40);
        positions.add(Offset(x, y));
        x += size.width + widget.spacing;
      }
    }

    // 1行目のrowWidthを計算し、全体のx座標をシフト
    double firstRowWidth = 0;
    double tempX = 0;
    double maxHeight = 0;
    for (int i = 0; i < children.length; i++) {
      final size = i < _childrenSizes.length ? _childrenSizes[i] : const Size(100, 40);
      if (tempX + size.width > maxWidth && i != 0) {
        break;
      }
      firstRowWidth += size.width;
      if (tempX != 0) firstRowWidth += widget.spacing;
      tempX += size.width + widget.spacing;
      if (size.height > maxHeight) maxHeight = size.height;
    }
    final offsetX = (maxWidth - firstRowWidth) / 2;
    for (int i = 0; i < positions.length; i++) {
      positions[i] = Offset(positions[i].dx + offsetX, positions[i].dy);
    }

    // Stackの高さを計算
    final totalHeight = rowIndices.isNotEmpty ? rowYs.last + rowHeights.last : 0.0;

    // AnimatedPositioned用に前回座標を保持
    _prevPositions ??= {};
    final newPositions = <Key, Offset>{};
    for (int i = 0; i < children.length; i++) {
      final key = children[i].key;
      if (key != null) {
        newPositions[key] = positions[i];
      }
    }

    final stackChildren = <Widget>[];
    for (int i = children.length - 1; i >= 0; i--) {
      final child = children[i];
      final key = child.key;
      final pos = positions[i];
      if (key != null && _prevPositions != null && _prevPositions!.containsKey(key)) {
        stackChildren.add(
          AnimatedPositioned(
            key: ValueKey('animated_$key'),
            left: pos.dx,
            top: pos.dy,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: child,
          ),
        );
      } else {
        stackChildren.add(Positioned(left: pos.dx, top: pos.dy, child: child));
      }
    }
    // _prevPositionsを更新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _prevPositions = newPositions);
    });

    if (widget.movingChildKey != null) {
      // movingChildを最前面に移動
      final targetKey = ValueKey('animated_${widget.movingChildKey}');

      for (int i = 0; i < stackChildren.length; i++) {
        final child = stackChildren[i];
        if (child.key == targetKey) {
          // 見つかった要素を削除して最後に追加（最前面に）
          final movingChild = stackChildren.removeAt(i);
          stackChildren.add(movingChild);
          break;
        }
      }
    }

    return SizedBox(
      width: maxWidth,
      height: totalHeight,
      child: Stack(children: stackChildren),
    );
  }
}

/// 子Widgetのサイズを計測するためのWidget
class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({super.key, required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final contextBox = context.findRenderObject();
        if (contextBox is RenderBox && contextBox.hasSize) {
          final size = contextBox.size;
          if (_oldSize != size && size.width > 0 && size.height > 0) {
            _oldSize = size;
            widget.onChange(size);
          }
        }
      }
    });
    return widget.child;
  }
}
