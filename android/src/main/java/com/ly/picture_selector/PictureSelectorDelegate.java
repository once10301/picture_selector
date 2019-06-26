package com.ly.picture_selector;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.yuyh.library.imgsel.ISNav;
import com.yuyh.library.imgsel.common.ImageLoader;
import com.yuyh.library.imgsel.config.ISListConfig;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class PictureSelectorDelegate implements PluginRegistry.ActivityResultListener {
    private static final int REQUEST_LIST_CODE = 0;

    private Activity activity;

    private MethodCall methodCall;
    private MethodChannel.Result result;

    PictureSelectorDelegate(
            Activity activity) {
        this.activity = activity;
    }

    public void select(MethodChannel.Result result) {
        this.result = result;
        ISNav.getInstance().init(new ImageLoader() {
            @Override
            public void displayImage(Context context, String path, ImageView imageView) {
                Glide.with(context).load(path).into(imageView);
            }
        });
        ISListConfig config = new ISListConfig.Builder()
                .multiSelect(false)
                .statusBarColor(Color.parseColor("#AE252F"))
                .title("相册")
                .titleColor(Color.WHITE)
                .titleBgColor(Color.parseColor("#AE252F"))
                .needCrop(true)
                .cropSize(1, 1, 200, 200)
                .needCamera(true)
                .build();
        ISNav.getInstance().toListActivity(activity, config, REQUEST_LIST_CODE);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_LIST_CODE && resultCode == RESULT_OK && data != null) {
            List<String> pathList = data.getStringArrayListExtra("result");
            if (pathList.size() > 0) {
                result.success(pathList.get(0));
            }
        }
        return false;
    }


}
