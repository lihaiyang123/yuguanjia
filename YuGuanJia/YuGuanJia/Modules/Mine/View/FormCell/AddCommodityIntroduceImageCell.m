//
//  AddCommodityIntroduceImageCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/20.
//

#import "AddCommodityIntroduceImageCell.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetCell.h"
#import "EditSelectImageCollectionViewCell.h"

#define kMaxNums 8
#define kColunms 3

#define ITEMWIDTH  kScale_W(60)
#define ITEMHEIGHT kScale_W(60)

@interface AddCommodityIntroduceImageCell ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _isSelectOriginalPhoto;
//    BOOL _kMaxNums;
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *picCollectionView;

@property (nonatomic, strong) UILabel *bottomSpecificationsLabel;//规格

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isDelete;


@end

@implementation AddCommodityIntroduceImageCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(95);
}
+(void)load {
    
    
}

- (void)configure {
    
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.picCollectionView];
    [self.picCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScale_W(67));
    }];
    
    [self.contentView addSubview:self.bottomSpecificationsLabel];
    [self.bottomSpecificationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picCollectionView.mas_bottom).offset(kScale_W(7.5));
        make.left.equalTo(self.contentView.mas_left).offset(kScale_W(12.5));
        make.width.mas_equalTo(kScale_W(100));
        make.height.mas_equalTo(kScale_W(10));
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];



}
-(void)update {
    
    [super update];
    if (self.rowDescriptor.value && ![self.rowDescriptor.tag isEqualToString:@"kGoodsCover"]) {
        if (self.dataArr.count != 0 || self.isDelete) {
            return;
        }
        NSArray *arr = (NSArray *)self.rowDescriptor.value;
        for (int i = 0; i < arr.count; i ++) {
            GoodsPicsListModel *model = (GoodsPicsListModel *)arr[i];
            if (model.picType == 1) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.picUrl]];
                UIImage *image = [UIImage imageWithData:data];
                [self.dataArr addObject:image];
            }
        }
        [self.picCollectionView reloadData];
    }
}

#pragma mark - Setter Getter Methods
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}

- (UILabel *)bottomSpecificationsLabel {
    
    if (!_bottomSpecificationsLabel) {
        
        _bottomSpecificationsLabel = [[UILabel alloc] init];
        _bottomSpecificationsLabel.text = @"（规格大小：40x40）";
        _bottomSpecificationsLabel.textColor = UIColorMakeWithHex(@"#999999");
        _bottomSpecificationsLabel.font = UIFontMake(10);
        
    }
    return _bottomSpecificationsLabel;
}

- (UICollectionView *)picCollectionView {
    
    if (!_picCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _picCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _picCollectionView.backgroundColor = [UIColor whiteColor];
        layout.itemSize = CGSizeMake(ITEMWIDTH, ITEMHEIGHT);
//        layout.minimumLineSpacing = 5;
//        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(kScale_W(3), kScale_W(12.5), kScale_W(0), kScale_W(12.5));
        _picCollectionView.delegate = self;
        _picCollectionView.dataSource = self;
        _picCollectionView.showsHorizontalScrollIndicator = NO;
        _picCollectionView.showsVerticalScrollIndicator = NO;
        [_picCollectionView registerClass:[EditSelectImageCollectionViewCell class] forCellWithReuseIdentifier:@"editImageCell"];

    }
    
    return _picCollectionView;
}

#pragma mark - collectionView代理
//设置collectionView一共有多少块
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}
//设置每一块的内容cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditSelectImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"editImageCell" forIndexPath:indexPath];
    
    if (indexPath.row != self.dataArr.count) {
        cell.deleteButton.hidden = NO;
    }else{
        cell.deleteButton.hidden = YES;
    }
    
    if (indexPath.row == self.dataArr.count) {
        cell.bigImageView.image = [UIImage imageNamed:@"edit_Add"];
    }else{
        cell.bigImageView.image = self.dataArr[indexPath.row];
    }
    @weakify(self);
    cell.deleteBlock = ^{
        @strongify(self);
        self.isDelete = YES;
        if ([self.rowDescriptor.tag isEqualToString:@"kGoodsCover"]) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.selectedAssets removeObjectAtIndex:indexPath.row];
            [self.picCollectionView reloadData];
        } else {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.picCollectionView reloadData];
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArr.count) {
        
        NSString *takePhotoTitle = @"拍照";
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        [alertVc addAction:takePhotoAction];
        UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushTZImagePickerController];
        }];
        [alertVc addAction:imagePickerAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (popover) {
            popover.sourceView = cell;
            popover.sourceRect = cell.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self.formViewController presentViewController:alertVc animated:YES completion:nil];
        
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (kMaxNums <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxNums columnNumber:kColunms delegate:self pushPhotoPickerVc:YES];
    
     imagePickerVc.barItemTextColor = [UIColor blackColor];
     [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
     imagePickerVc.navigationBar.tintColor = [UIColor blackColor];
     imagePickerVc.naviBgColor = [UIColor whiteColor];
     imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (kMaxNums > 1) {
        // 1.设置目前已经选中的图片数组
//        if (self.isFromManeger == YES) {
//            imagePickerVc.selectedAssets = self.selectedAssetsAdd; // 目前已经选中的图片数组
//        }else{
            imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
//        }
    }
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.formViewController.view.frame.size.width - 2 * left;
    NSInteger top = (self.formViewController.view.frame.size.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.formViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self.formViewController presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self.formViewController presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self.formViewController presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        YDZYLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([type isEqualToString:@"public.image"]) {
//
//        if (![self judgeImagePickerwithSourceType:picker.sourceType])
//        {
//            return;
//        }
//
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        [self.dataArr addObject:image];
//        [self.picCollectionView reloadData];
//
//    }
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];


    
}
- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)type{
    
    if (![self judgeImagePickerwithSourceType:type]){

        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        __weak id weakSelf = self;
        picker.delegate = weakSelf;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = type;
        picker.navigationBar.tintColor=[UIColor blackColor];
        [self.formViewController presentViewController:picker animated:YES completion:nil];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
       {
           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
           __weak id weakSelf = self;
           picker.delegate = weakSelf;
           picker.allowsEditing = YES;
           picker.sourceType = type;
           picker.navigationBar.tintColor=[UIColor blackColor];
           [self.formViewController presentViewController:picker animated:YES completion:nil];
       }
}

- (BOOL)judgeImagePickerAuthorizationStatus
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted){
        
        [YGJToast showToast:@"请在系统设置中允许御管家打开相册"];
        return NO;
    }else
    {
        return YES;
    }
}

- (BOOL)judgeCameraAuthorizationStatus
{
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status ==AVAuthorizationStatusDenied || status ==AVAuthorizationStatusRestricted){
        
        [YGJToast showToast:@"请在系统设置中允许御管家打开相机"];
        return NO;
    }else
    {
        return YES;
    }
}

- (BOOL)judgeImagePickerwithSourceType:(UIImagePickerControllerSourceType)type
{
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        return [self judgeImagePickerAuthorizationStatus];
    }else if (type == UIImagePickerControllerSourceTypeCamera)
    {
        return [self judgeCameraAuthorizationStatus];
    }
    return YES;
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    [self.selectedAssets addObject:asset];
    [self.dataArr addObject:image];
    [self.picCollectionView reloadData];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _dataArr = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self printAssetsName:assets];
    
    [SVProgressHUD show];
    NSMutableArray *picUrlArr = [NSMutableArray array];
    for (int i = 0; i < _dataArr.count; i ++) {
        
        NSMutableArray *uploadArr = [NSMutableArray arrayWithObject:_dataArr[i]];
        @weakify(self);
        [UDAAPIRequest uploadImagesUrl:@"/image/uploadImg" parameters:nil name:@"file" images:uploadArr fileNames:nil imageScale:1 imageType:@"png" progressBlock:^(CGFloat value) {
            
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            
            @strongify(self);
            if (requestModel.success) {
                
                [SVProgressHUD dismiss];
                [picUrlArr addObject:requestModel.result[@"filePath"]];
                self.rowDescriptor.value = picUrlArr;
                [self.picCollectionView reloadData];
            }else{
                [SVProgressHUD dismiss];
            }
            
        } errorBlock:^(NSError * _Nullable error) {
            [SVProgressHUD dismiss];
        }];
    }

}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
         YDZYLog(@"图片名字:%@",fileName);
    }
}

- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {

    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.formViewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.formViewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePickerVc;
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)selectedAssets{
    
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}


- (void)dealloc
{
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RejectedGoodsForm-CanEdit" object:nil];
}
@end
