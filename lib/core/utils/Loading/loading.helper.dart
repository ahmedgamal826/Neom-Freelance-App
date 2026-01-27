import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Services/Contexter/contexter.service.dart';
import '../../Services/Error Handling/error_handling.service.dart';
import 'src/exports.dart';

class LoadingHelper {
  //
  static final _defaultStyling = LoadingHelperStyle(
    indicatorWidget: LoadingAnimationWidget.waveDots(
      color: Theme.of(Contexter.currentContext).colorScheme.primary,
      size: 36.0,
    ),
    maskColor: Colors.transparent,
  );

  //
  static Widget Function(BuildContext, Widget?) initializer({
    Widget Function(BuildContext, Widget?)? builder,
  }) {
    Widget Function(BuildContext, Widget?) b =
        EasyLoading.init(builder: builder);
    return b;
  }

  static void setDefault({LoadingHelperStyle? defaultStyle}) {
    //TODO []: Configure Loading Style
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..animationStyle = EasyLoadingAnimationStyle.opacity
      ..animationDuration =
          defaultStyle?.animationDuration ?? _defaultStyling.animationDuration
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = defaultStyle?.maskColor ?? _defaultStyling.maskColor
      ..indicatorWidget =
          defaultStyle?.indicatorWidget ?? _defaultStyling.indicatorWidget
      ..indicatorColor = Colors.amber
      ..textColor = Colors.black
      ..progressColor = Colors.amber
      ..userInteractions =
          defaultStyle?.userInteractions ?? _defaultStyling.userInteractions
      ..backgroundColor = defaultStyle?.maskColor ?? _defaultStyling.maskColor
      ..dismissOnTap =
          defaultStyle?.dismissOnTap ?? _defaultStyling.dismissOnTap;
  }

  static Future<void> start({LoadingHelperStyle? style}) async {
    style != null ? setDefault(defaultStyle: style) : null;
    return await EasyLoading.show();
  }

  static Future<void> stop({int minTime = 1}) async {
    await Future.delayed(Duration(seconds: minTime));
    return await EasyLoading.dismiss();
  }

  static Future<void> load<T>(
    BuildContext context,
    Future<T>? process, {
    Function(T? v)? onSuccess,
    VoidCallback? onFail,
    VoidCallback? onFinally,
  }) async {
    await start();
    try {
      T? p = await process;
      if (onSuccess != null) onSuccess(p);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'LoadingHelper/load', stackTrace: s);
      if (onFail != null) onFail();
    } finally {
      await stop();
      if (onFinally != null) onFinally();
    }
  }
}
