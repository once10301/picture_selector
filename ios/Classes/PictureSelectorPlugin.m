#import "PictureSelectorPlugin.h"
#import <TZImagePickerController.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation PictureSelectorPlugin

UIViewController *_viewController;


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"picture_selector"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    PictureSelectorPlugin* instance = [[PictureSelectorPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"select" isEqualToString:call.method]) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowTakePicture = true;
        imagePickerVc.allowPickingVideo = false;
        imagePickerVc.allowPickingImage = true;
        imagePickerVc.allowPickingOriginalPhoto = false;
        imagePickerVc.allowPickingGif = false;
        imagePickerVc.allowPickingMultipleVideo = false;
        imagePickerVc.allowCrop = true;
        imagePickerVc.scaleAspectFillCrop = true;
        NSInteger top = (SCREEN_HEIGHT - SCREEN_WIDTH) / 2;
        imagePickerVc.cropRect = CGRectMake(0, top, SCREEN_WIDTH, SCREEN_WIDTH);
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            UIImage *image = photos[0];
            image = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
            NSString *path = [self getImagePath:image];
            result(path);
        }];
        [_viewController presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

//压缩图片
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSString *)getImagePath:(UIImage *)Image {
    NSString * filePath = nil;
    NSData * data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 0.5);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString * ImagePath = [[NSString alloc]initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,ImagePath];
    return filePath;
}
@end
