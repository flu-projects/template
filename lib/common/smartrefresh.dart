import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallet/utils/utils.dart';

Widget getSmartRefresher({
  required RefreshController controller,
  required Widget child,
  VoidCallback? onLoading,
  VoidCallback? onRefresh,
  enablePullUp = true,
  enablePullDown = true,
  String tooltip = '正在加載中',
  Widget? footer,
}) {
  var _key = GlobalKey<_LoadingState>();
  return SmartRefresher(
    enablePullUp: enablePullUp,
    enablePullDown: enablePullDown,
    controller: controller,
    child: child,
    onLoading: onLoading,
    onRefresh: onRefresh,
    header: CustomHeader(
      builder: (context, mode) {
        return _Loading(key: _key, text: tooltip);
      },
      onModeChange: (state) {
        if (state == RefreshStatus.canRefresh) {
          _key.currentState?.start();
        } else {
          _key.currentState?.stop();
        }
      },
      height: dp.d120,
    ),
    footer: footer ??
        CustomFooter(
          builder: (
            BuildContext context,
            LoadStatus? mode,
          ) {
            Widget body = Text(
              '暂无更多数据',
              style: textSize12.copyWith(color: white),
            );
            if (mode == LoadStatus.idle) {
              body = Text('上拉加载', style: textSize12.copyWith(color: white));
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body =
                  Text('加载失败！点击重试！', style: textSize12.copyWith(color: white));
            } else if (mode == LoadStatus.canLoading) {
              body = Text('松手,加载更多!', style: textSize12.copyWith(color: white));
            }
            return SizedBox(
              height: dp.d50,
              child: Center(child: body),
            );
          },
        ),
  );
}

class _Loading extends StatefulWidget {
  final String text;
  const _Loading({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<_Loading>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  void start() {
    if (_controller?.isAnimating ?? true) {
      return;
    }
    _controller?.forward();
  }

  void stop() {
    _controller?.stop();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 360),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 360).animate(_controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: dp.d94,
        height: dp.d94,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation!,
              child: Icon(Icons.ac_unit_outlined),
            ),
            Gaps.vGap4,
            Text(
              widget.text,
              style: textSize12.copyWith(
                fontWeight: semiBold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
