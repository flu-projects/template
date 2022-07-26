import 'package:flutter/material.dart';
import 'package:wallet/utils/utils.dart';

Future<T?> centerDialog<T>({
  required BuildContext context,
  // String? content,
  // String? image,
  required WidgetBuilder builder,
  EdgeInsets? padding,
  Color barrierColor = Colors.black,
}) async {
  return await showDialog(
    context: context,
    useSafeArea: false,
    barrierColor: barrierColor.withOpacity(0.8),
    builder: (_) {
      return Scaffold(
        backgroundColor: transparent,
        body: Align(
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              padding: padding,
              child: builder.call(context),
            ),
          ),
        ),
      );
    },
  );
}

Future<T?> bottomDialog<T>(
  BuildContext context, {
  Color? barrierColor,
  EdgeInsets? padding,
  BoxDecoration? decoration,
  required WidgetBuilder builder,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    barrierColor: barrierColor,
    isScrollControlled: true,
    builder: (_) {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: width,
                padding: padding,
                decoration: decoration ??
                    BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(dp.d18),
                      ),
                    ),
                child: builder(context),
              ),
            ],
          ),
        ),
      );
    },
  );
}
