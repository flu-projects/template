import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 240);
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

class BottomSheet extends StatefulWidget {
  const BottomSheet({
    Key? key,
    this.animationController,
    this.enableDrag = true,
    this.backgroundColor,
    this.elevation,
    this.shape,
    required this.onClosing,
    required this.builder,
  })  : assert(elevation == null || elevation >= 0.0),
        super(key: key);

  final AnimationController? animationController;
  final VoidCallback onClosing;
  final WidgetBuilder builder;
  final bool enableDrag;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  _BottomSheetState createState() => _BottomSheetState();
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _bottomSheetDuration,
      debugLabel: 'BottomSheet',
      vsync: vsync,
    );
  }
}

class _BottomSheetState extends State<BottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double get _childHeight {
    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController!.status == AnimationStatus.reverse;

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(widget.enableDrag);
    if (_dismissUnderway) return;
    widget.animationController!.value -= details.primaryDelta! / (_childHeight);
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(widget.enableDrag);
    if (_dismissUnderway) return;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        widget.onClosing();
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      widget.onClosing();
    } else {
      widget.animationController!.forward();
    }
  }

  bool extentChanged(DraggableScrollableNotification notification) {
    if (notification.extent == notification.minExtent) {
      widget.onClosing();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme =
        Theme.of(context).bottomSheetTheme;
    final Color? color =
        widget.backgroundColor ?? bottomSheetTheme.backgroundColor;
    final double elevation =
        widget.elevation ?? bottomSheetTheme.elevation ?? 0;
    final ShapeBorder? shape = widget.shape ?? bottomSheetTheme.shape;

    final Widget bottomSheet = Material(
      key: _childKey,
      color: color,
      elevation: elevation,
      shape: shape,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: extentChanged,
        child: widget.builder(context),
      ),
    );
    return !widget.enableDrag
        ? bottomSheet
        : GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: bottomSheet,
            excludeFromSemantics: true,
          );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(
    this.progress,
    this.isScrollControlled,
    this.keyboardHeight,
  );

  final double progress;
  final bool isScrollControlled;
  final double keyboardHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 12.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
      0.0,
      size.height - childSize.height * progress - keyboardHeight,
    );
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({
    Key? key,
    this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.isScrollControlled = false,
  }) : super(key: key);

  final _ModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  String? _getRouteLabel(MaterialLocalizations localizations) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return localizations.dialogLabel;
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String? routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (BuildContext context, Widget? child) {
        final double animationValue = mediaQuery.accessibleNavigation
            ? 1.0
            : widget.route!.animation!.value;
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: _ModalBottomSheetLayout(
                animationValue,
                widget.isScrollControlled,
                MediaQuery.of(context).viewInsets.bottom,
              ),
              child: BottomSheet(
                animationController: widget.route!._animationController,
                onClosing: () {
                  if (widget.route!.isCurrent) {
                    Navigator.pop(context);
                  }
                },
                builder: widget.route!.builder!,
                backgroundColor: widget.backgroundColor,
                elevation: widget.elevation,
                shape: widget.shape,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    this.backgroundColor,
    this.cbarrierColor,
    this.elevation,
    this.shape,
    required this.isScrollControlled,
    RouteSettings? settings,
  }) : super(settings: settings);

  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final Color? cbarrierColor;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  Duration get transitionDuration => _bottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => cbarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(
        route: this,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        isScrollControlled: isScrollControlled,
      ),
    );
    if (theme != null) bottomSheet = Theme(data: theme!, child: bottomSheet);
    return bottomSheet;
  }
}

Future<T?> showModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  Color? barrierColor,
  double? elevation,
  ShapeBorder? shape,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _ModalBottomSheetRoute<T>(
      builder: builder,
      theme: Theme.of(context),
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      cbarrierColor: barrierColor,
      elevation: elevation,
      shape: shape,
    ),
  );
}

PersistentBottomSheetController<T> showBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
}) {
  assert(debugCheckHasScaffold(context));

  return Scaffold.of(context).showBottomSheet<T>(
    builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
  );
}
