package com.ly.picture_selector;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;

import com.luck.picture.lib.PictureSelectionModel;
import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


public class PictureSelectorDelegate implements PluginRegistry.ActivityResultListener {
    private Activity activity;
    private MethodChannel.Result result;
    boolean enableCrop, compress;

    PictureSelectorDelegate(Activity activity) {
        this.activity = activity;
    }

    public void select(MethodCall call, MethodChannel.Result result) {
        this.result = result;
        int type = call.argument("type");
        int max = call.argument("max");
        int spanCount = call.argument("spanCount");
        boolean isCamera = call.argument("isCamera");
        enableCrop = call.argument("enableCrop");
        compress = call.argument("compress");
        int ratioX = call.argument("ratioX");
        int ratioY = call.argument("ratioY");
        List<String> selectList = call.argument("selectList");
        List<LocalMedia> list = new ArrayList<>();
        for (int i = 0; i < selectList.size(); i++) {
            LocalMedia localMedia = new LocalMedia();
            localMedia.setPath(selectList.get(i));
            list.add(localMedia);
        }
        this.result = result;
        PictureSelectionModel model = PictureSelector.create(activity)
                .openGallery(type)//全部.PictureMimeType.ofAll()、图片.ofImage()、视频.ofVideo()、音频.ofAudio()
                .loadImageEngine(GlideEngine.createGlideEngine())// 外部传入图片加载引擎，必传项
                .maxSelectNum(max)// 最大图片选择数量 int
                .minSelectNum(1)// 最小选择数量 int
                .imageSpanCount(spanCount)// 每行显示个数 int
                .selectionMode(max == 1 ? PictureConfig.SINGLE : PictureConfig.MULTIPLE)// 多选 or 单选 PictureConfig.MULTIPLE or PictureConfig.SINGLE
                .isSingleDirectReturn(true)// 单选模式下是否直接返回
                .previewImage(true)// 是否可预览图片 true or false
                .isCamera(isCamera)// 是否显示拍照按钮 true or false
                .imageFormat(PictureMimeType.PNG)// 拍照保存图片格式后缀,默认jpeg
                .enableCrop(enableCrop)// 是否裁剪 true or false
                .compress(compress)// 是否压缩 true or false
                .selectionMedia(list);// 是否传入已选图片 List<LocalMedia> list
        if (enableCrop) {
            model.withAspectRatio(ratioX, ratioY);// int 裁剪比例 如16:9 3:2 3:4 1:1 可自定义
        }
        model.forResult(PictureConfig.CHOOSE_REQUEST);//结果回调onActivityResult code
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK && requestCode == PictureConfig.CHOOSE_REQUEST && data != null) {
            List<LocalMedia> selectList = PictureSelector.obtainMultipleResult(data);
            final List<Map<String, String>> list = new ArrayList<>();
            for (int i = 0; i < selectList.size(); i++) {
                Map<String, String> map = new HashMap<>();
                map.put("path", selectList.get(i).getPath());
                map.put("cropPath", selectList.get(i).getCutPath());
                map.put("compressPath", selectList.get(i).getCompressPath());
                list.add(map);
            }
            result.success(list);
        }
        return false;
    }

}