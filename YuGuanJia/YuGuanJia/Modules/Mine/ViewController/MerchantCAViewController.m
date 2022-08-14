//
//  MerchantCAViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "MerchantCAViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MerchantCAViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *shuiNumLabel;
@property (nonatomic, strong) UITextField *companyNameTF;
@property (nonatomic, strong) UITextField *shuiNumTF;
@property (nonatomic, strong) UIImageView *bigAddImageView;
@property (nonatomic, copy) NSString *imageURL;

@end

@implementation MerchantCAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.title = @"商户认证";
    [self createBar];
    [self createUI];
}
#pragma mark - 设置导航栏
- (void)createBar {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)createUI {
    
    UIView *companyView = [[UIView alloc] init];
    companyView.frame = CGRectMake(0, 10, kScreenWidth, 55);
    companyView.backgroundColor = KWhiteColor;
    [self.view addSubview:companyView];
    
    self.companyNameLabel = [[UILabel alloc] init];
    self.companyNameLabel.frame = CGRectMake(13, 0, 200, 54);
    self.companyNameLabel.textColor = KBlackColor;
    self.companyNameLabel.font = [UIFont systemFontOfSize:16];
    self.companyNameLabel.textAlignment = NSTextAlignmentLeft;
    self.companyNameLabel.text = @"公司全称";
    [companyView addSubview:self.companyNameLabel];
    
    self.companyNameTF = [[UITextField alloc] init];
    self.companyNameTF.frame = CGRectMake(kScreenWidth-313, 13, 300, 15);
    self.companyNameTF.placeholder = @"请输入";
    [self.companyNameTF setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
    self.companyNameTF.textAlignment = NSTextAlignmentRight;
    self.companyNameTF.font = [UIFont systemFontOfSize:16];
    self.companyNameTF.textColor = KBlackColor;
    [companyView addSubview:self.companyNameTF];
    
    UIView *underLineView = [[UIView alloc] init];
    underLineView.backgroundColor = UNDERLINECOLOR;
    underLineView.frame = CGRectMake(13, 54, kScreenWidth-26, 1);
    [companyView addSubview:underLineView];
    
    UIView *shuiNumView = [[UIView alloc] init];
    shuiNumView.frame = CGRectMake(0, companyView.bottom, kScreenWidth, 55);
    shuiNumView.backgroundColor = KWhiteColor;
    [self.view addSubview:shuiNumView];
    
    self.shuiNumLabel = [[UILabel alloc] init];
    self.shuiNumLabel.frame = CGRectMake(13, 0, 200, 54);
    self.shuiNumLabel.textColor = KBlackColor;
    self.shuiNumLabel.font = [UIFont systemFontOfSize:16];
    self.shuiNumLabel.textAlignment = NSTextAlignmentLeft;
    self.shuiNumLabel.text = @"税务编号";
    [shuiNumView addSubview:self.shuiNumLabel];
    
    self.shuiNumTF = [[UITextField alloc] init];
    self.shuiNumTF.frame = CGRectMake(kScreenWidth-313, 13, 300, 15);
    self.shuiNumTF.placeholder = @"请输入";
    [self.shuiNumTF setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
    self.shuiNumTF.textAlignment = NSTextAlignmentRight;
    self.shuiNumTF.font = [UIFont systemFontOfSize:16];
    self.shuiNumTF.textColor = KBlackColor;
    [shuiNumView addSubview:self.shuiNumTF];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.backgroundColor = KClearColor;
    tipsLabel.frame = CGRectMake(13, shuiNumView.bottom+22, 200, 15);
    tipsLabel.textColor = KBlackColor;
    tipsLabel.font = FONTSIZEBOLD(16);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.text = @"上传企业营业执照";
    [self.view addSubview:tipsLabel];
        
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, tipsLabel.bottom+10, kScreenWidth, 180);
    bottomView.backgroundColor = KWhiteColor;
    [self.view addSubview:bottomView];
        
    UIView *bigGrayView = [[UIView alloc] init];
    bigGrayView.frame = CGRectMake(12, 20, kScreenWidth-24, 136);
    bigGrayView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    bigGrayView.layer.masksToBounds = YES;
    bigGrayView.layer.cornerRadius = 5;
    bigGrayView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    bigGrayView.layer.borderWidth = 1;
    [bottomView addSubview:bigGrayView];
    
    self.bigAddImageView = [[UIImageView alloc] init];
    self.bigAddImageView.userInteractionEnabled = YES;
    self.bigAddImageView.frame = CGRectMake((bigGrayView.width-60)/2.0, 38, 60, 60);
    self.bigAddImageView.image = [UIImage imageNamed:@"bigAdd"];
    self.bigAddImageView.contentMode = UIViewContentModeScaleToFill;
    [bigGrayView addSubview:self.bigAddImageView];
    UITapGestureRecognizer *bigAddTap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigAddTapAction)];
    [bigGrayView addGestureRecognizer:bigAddTap];
}

- (void)bigAddTapAction {
    
    [self openPhoto];
    
}
- (void)rightButtonOnClicked {
    
    if ([NSString isBlankString:_companyNameTF.text]) {
        [YGJToast showToast:@"请输入公司名称"];
        return;
    }
    
    if ([NSString isBlankString:_shuiNumTF.text]) {
        [YGJToast showToast:@"请输入税务编号"];
        return;
    }
    
    UIImage *image = [UIImage imageNamed:@"bigAdd"];
    if ([_bigAddImageView.image isEqual:image]) {
        
        [YGJToast showToast:@"请上传营业执照"];
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_companyNameTF.text,@"fullName",_shuiNumTF.text,@"serNo",self.imageURL,@"serPic", nil];
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/editUserInfo" parameter:dict requestType:UDARequestTypePut isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            YDZYLog(@"----商户认证------");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHANGHU-SUCCESS" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (void)openPhoto {
    WS(weakSelf)
    NSString *takePhotoTitle = @"拍照";
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)type {
    
    if (![self judgeImagePickerwithSourceType:type]) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        __weak id weakSelf = self;
        picker.delegate = weakSelf;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = type;
        picker.navigationBar.tintColor=[UIColor blackColor];
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
           __weak id weakSelf = self;
           picker.delegate = weakSelf;
           picker.allowsEditing = YES;
           picker.sourceType = type;
           picker.navigationBar.tintColor=[UIColor blackColor];
           [self presentViewController:picker animated:YES completion:nil];
       }
}

- (BOOL)judgeImagePickerAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted){
        [YGJToast showToast:@"请在系统设置中允许御管家打开相册"];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)judgeCameraAuthorizationStatus {
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status ==AVAuthorizationStatusDenied || status ==AVAuthorizationStatusRestricted){
        [YGJToast showToast:@"请在系统设置中允许御管家打开相机"];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)judgeImagePickerwithSourceType:(UIImagePickerControllerSourceType)type {
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        return [self judgeImagePickerAuthorizationStatus];
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        return [self judgeCameraAuthorizationStatus];
    }
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(weakSelf)
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD show];
        if (![self judgeImagePickerwithSourceType:picker.sourceType]) {
            return;
        }
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSArray *imageArr = [NSArray arrayWithObject:image];
        [UDAAPIRequest uploadImagesUrl:@"/image/uploadImg" parameters:nil name:@"file" images:imageArr fileNames:nil imageScale:1 imageType:@"png" progressBlock:^(CGFloat value) {
            
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            if (requestModel.success) {
                [SVProgressHUD dismiss];
                YDZYLog(@"长传单张图片 ----> %@",requestModel);
                weakSelf.bigAddImageView.frame = CGRectMake(0, 0, kScreenWidth-24, 136);
                weakSelf.bigAddImageView.image = image;
                weakSelf.imageURL = requestModel.result[@"filePath"];
            } else {
                [SVProgressHUD dismiss];
            }
        } errorBlock:^(NSError * _Nullable error) {
            [SVProgressHUD dismiss];
        }];
    }];
        
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
