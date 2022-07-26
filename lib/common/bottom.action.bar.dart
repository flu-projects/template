import 'package:flutter/material.dart';
import 'package:wallet/utils/utils.dart';

Widget buildBottomActions({
  required TabController controller,
  required List<String> items,
  required ValueChanged<int> onIndexChanged,
}) {
  return Container(
    alignment: Alignment.center,
    child: TabBar(
      controller: controller,
      tabs: List.generate(
        items.length,
        (index) {
          return Tab(text: items[index]);
        },
      ),
      labelStyle: textSize16,
      labelColor: red,
      unselectedLabelColor: white,
      indicator: CircleTabIndicator(
        borderSide: const BorderSide(width: 2),
        insets: EdgeInsets.only(bottom: dp.d6),
      ),
      onTap: onIndexChanged,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.symmetric(horizontal: dp.d6),
    ),
  );
}

class BottomActionAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? title;
  final VoidCallback? goBack;
  final Color leadingColor;
  final List<Widget>? actions;
  final WidgetBuilder? bottomBuilder;
  final double? bottomHeight;
  final bool leadingVisible;
  final double? actionWidth;
  final Color? backgroundColor;
  final double? elevation;
  BottomActionAppbar({
    Key? key,
    this.title,
    this.goBack,
    this.leadingColor = Colors.black,
    this.actions,
    this.bottomBuilder,
    this.bottomHeight,
    this.leadingVisible = true,
    this.actionWidth,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key) {
    assert(
      (bottomBuilder == null && bottomHeight == null) ||
          (bottomBuilder != null && bottomHeight != null),
      'bottomBuilder & bottomHeight at the same time is null or not null',
    );
  }

  @override
  _BottomActionAppbarState createState() => _BottomActionAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(
        statusBarHeight + dp.d44 + (bottomHeight ?? 0),
      );
}

class _BottomActionAppbarState extends State<BottomActionAppbar> {
  static const double _defaultElevation = 0.0;
  static const Color _defaultShadowColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final Color backgroundColor = widget.backgroundColor ??
        appBarTheme.backgroundColor ??
        theme.primaryColor;

    return Material(
      color: backgroundColor,
      elevation: widget.elevation ?? appBarTheme.elevation ?? _defaultElevation,
      shadowColor: appBarTheme.shadowColor ?? _defaultShadowColor,
      surfaceTintColor: Colors.white,
      child: Semantics(
        explicitChildNodes: true,
        child: _body(backgroundColor),
      ),
    );
  }

  Widget _body(Color backgroundColor) {
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + dp.d44 + (widget.bottomHeight ?? 0.0),
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: dp.d44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: widget.actionWidth ?? dp.d66,
                  child: Row(
                    children: [
                      if (widget.leadingVisible) Icon(Icons.arrow_back_ios)
                    ],
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  child: Center(
                    child: widget.title ?? Container(),
                  ),
                ),
                Gaps.hGap10,
                SizedBox(
                  width: (widget.actionWidth ?? dp.d66) - dp.d16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...widget.actions ??
                          [
                            Container(width: dp.d24),
                          ],
                    ],
                  ),
                ),
                Gaps.hGap16,
              ],
            ),
          ),
          if (widget.bottomBuilder != null)
            SizedBox(
              height: widget.bottomHeight,
              child: widget.bottomBuilder!.call(context),
            ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  const CircleTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CircleTabIndicator) {
      return CircleTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CircleTabIndicator) {
      return CircleTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    // RRect.fromLTRBR(
    //   indicator.left,
    //   indicator.bottom - borderSide.width,
    //   indicator.left + indicator.width,
    //   indicator.bottom,
    //   Radius.circular(dp.d2),
    // );
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final CircleTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
