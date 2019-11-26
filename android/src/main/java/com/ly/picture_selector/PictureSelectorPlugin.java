package com.ly.picture_selector;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PictureSelectorPlugin implements MethodCallHandler {

  private PictureSelectorDelegate delegate;

  private PictureSelectorPlugin(  PictureSelectorDelegate delegate) {

    this.delegate = delegate;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "picture_selector");
    final PictureSelectorDelegate delegate = new PictureSelectorDelegate(registrar.activity());
    registrar.addActivityResultListener(delegate);
    channel.setMethodCallHandler(new PictureSelectorPlugin(delegate));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("select")) {
      delegate.select(call, result);
    } else {
      result.notImplemented();
    }
  }

}