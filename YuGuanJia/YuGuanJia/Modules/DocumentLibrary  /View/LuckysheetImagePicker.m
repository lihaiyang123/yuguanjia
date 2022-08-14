//
//  LuckysheetImagePicker.m
//  YuGuanJia
//
//  Created by ggzj on 2021/8/7.
//

#import "LuckysheetImagePicker.h"

@interface LuckysheetImagePicker() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id <LuckysheetImagePickerDelegate>delegate;

@end

@implementation LuckysheetImagePicker

- (instancetype)initWithDelegate:(id<LuckysheetImagePickerDelegate>)delegate {
    if (self = [super init]) {
        
        self.delegate = delegate;
    }
    return self;
}

- (void)openImagePicker {
    // 请求访问照片库的权限，在 iOS 8 或以上版本中可以利用这个方法弹出 Alert 询问用户是否授权
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpAlbumStyle];
            });
        }];
    } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized) {
        [self showCameraSetAlertView:@"相册"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUpAlbumStyle];
    });
}

- (void)setUpAlbumStyle {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = true;

        [[QMUIHelper visibleViewController] presentViewController:picker animated:true completion:nil];
    });
}
- (void)showCameraSetAlertView:(NSString *)toolString {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@权限未开启",toolString] message:[NSString stringWithFormat:@"%@权限未开启，请进入系统【设置】>【隐私】>【%@】中打开开关,开启%@功能",toolString,toolString,toolString] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    [[QMUIHelper visibleViewController] presentViewController:alertVC animated:true completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    // 当选择的类型是图片
    if (![type isEqualToString:@"public.image"]) {
        
        [YGJToast showToast:@"请选择图片资源"];
        return;
    }
    [SVProgressHUD show];
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    @weakify(self);
    [UDAAPIRequest uploadImagesUrl:@"/image/uploadImg" parameters:nil name:@"file" images:@[image] fileNames:nil imageScale:1 imageType:@"png" progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            [SVProgressHUD dismiss];
            [YGJToast showToast:@"附件添加成功"];
            if ([self.delegate respondsToSelector:@selector(uploadAttachmentSuccess:)]) {
                [self.delegate uploadAttachmentSuccess:requestModel.result[@"filePath"]];
            }
        } else {
            [SVProgressHUD dismiss];
            [YGJToast showToast:@"附件上传失败"];
        }
    } errorBlock:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        [YGJToast showToast:@"附件上传失败"];
    }];
}
@end
