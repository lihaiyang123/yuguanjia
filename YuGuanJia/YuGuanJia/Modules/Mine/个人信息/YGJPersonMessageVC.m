//
//  YGJPersonMessageVC.m
//  YuGuanJia
//
//  Created by 李海洋 on 2022/8/13.
//

#import "YGJPersonMessageVC.h"
#import "MerchantCAViewController.h"
#import "LegalPersonCAViewController.h"
#import "LoginViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/PHAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <YJYTextView/YJYCustomTextView.h>

//model
#import "UserModel.h"
#import "YGJPersonMessageModel.h"
@interface YGJPersonMessageVC ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//公司全称输入
@property (weak, nonatomic) IBOutlet YJYCustomTextView *companyNameTF;
//公司全称高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameHeightCon;
//简介输入
@property (weak, nonatomic) IBOutlet YJYCustomTextView *introTF;
//简介高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introHeightCon;
//商户电话输入
@property (weak, nonatomic) IBOutlet YJYCustomTextView *phoneTF;
//商户电话高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeightCon;
//商户属性
@property (weak, nonatomic) IBOutlet UILabel *attributeLb;
//商户属性右侧图标
@property (weak, nonatomic) IBOutlet UIImageView *attributeRightImage;
//商户认证按钮
@property (weak, nonatomic) IBOutlet UIButton *merchantsCerBtn;
//法人认证按钮
@property (weak, nonatomic) IBOutlet UIButton *legalPersonCerBtn;
//平台认证按钮
@property (weak, nonatomic) IBOutlet UIButton *platformCerBtn;

@property (strong, nonatomic) YGJPersonMessageModel *model;

@end

@implementation YGJPersonMessageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFaRenTips:) name:@"FAREN-SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFaRenTips:) name:@"SHANGHU-SUCCESS" object:nil];

    @weakify(self)
    [UDAAPIRequest requestUrl:@"/app/users/getUsersInfoByToken" parameter:nil requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        @strongify(self)
        if (requestModel.success) {
            self.model = [YGJPersonMessageModel mj_objectWithKeyValues:requestModel.result];
            [self showData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (void)showFaRenTips:(NSNotification *)notification {
    [YGJToast showToast:@"提交成功"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self initUI];
    [self createBar];
}

- (void)initUI{
    WS(weakSelf);
    self.companyNameTF.placeholder = @"请输入公司全称";
    self.companyNameTF.font = [UIFont systemFontOfSize:15];
    self.companyNameTF.initiLine = 1;
    self.companyNameTF.maxLine = 0;
    self.companyNameTF.maxLength = 200;
    self.companyNameTF.textAlignment = NSTextAlignmentRight;
    self.companyNameTF.placeholderColor = UIColorFromRGB(0xbbbbbb);
    self.companyNameTF.textHeightChangeBlock = ^(CGFloat height) {
        weakSelf.companyNameHeightCon.constant = height + 10 > 55 ? height + 10 : 55;
    };
    
    self.introTF.placeholder = @"请输入简介";
    self.introTF.font = [UIFont systemFontOfSize:15];
    self.introTF.initiLine = 1;
    self.introTF.maxLine = 0;
    self.introTF.maxLength = 200;
    self.introTF.textAlignment = NSTextAlignmentRight;
    self.introTF.placeholderColor = UIColorFromRGB(0xbbbbbb);
    self.introTF.textHeightChangeBlock = ^(CGFloat height) {
        weakSelf.introHeightCon.constant = height + 10 > 55 ? height + 10 : 55;
    };
    
    self.phoneTF.placeholder = @"请输入商户电话";
    self.phoneTF.font = [UIFont systemFontOfSize:15];
    self.phoneTF.initiLine = 1;
    self.phoneTF.maxLine = 1;
    self.phoneTF.maxLength = 11;
    self.phoneTF.textAlignment = NSTextAlignmentRight;
    self.phoneTF.placeholderColor = UIColorFromRGB(0xbbbbbb);
    self.phoneTF.textHeightChangeBlock = ^(CGFloat height) {
        weakSelf.phoneHeightCon.constant = height + 10 > 55 ? height + 10 : 55;
    };
}

- (void)showData{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.serLogo]];
    self.companyNameTF.text = self.model.fullName && self.model.fullName.length ? self.model.fullName : @"";
    self.introTF.text = self.model.serDesc && self.model.serDesc.length ? self.model.serDesc : @"";
    self.phoneTF.text = self.model.serPhone ? self.model.serPhone : @"";
    NSArray *localID = [YGJSQLITE_MANAGER getUserIdentity];
    if ([localID count] != 0) {
        self.attributeRightImage.hidden = NO;
        NSArray *titleArr = @[@"商品商户",@"仓储加工商户",@"物流商户",@"个体商户"];
        if ([localID count] == 1) {
            NSInteger idx = [localID[0] integerValue];
            self.attributeLb.text = titleArr[idx];
        } else {
            NSInteger idx = [localID[0] integerValue];
            NSInteger idx1 = [localID[1] integerValue];
            self.attributeLb.text = [NSString stringWithFormat:@"%@,%@",titleArr[idx],titleArr[idx1]];
        }
    }else {
        self.attributeRightImage.hidden = YES;
        NSArray *serTypes = self.model.serTypes;
        NSArray *titleArr = @[@"商品商户",@"仓储加工商户",@"物流商户",@"个体商户"];
        if ([serTypes count] == 1) {
            NSInteger idx = [serTypes[0] integerValue];
            self.attributeLb.text = titleArr[idx];
        } else {
            if ([serTypes count] >= 2) {
                NSInteger idx = [serTypes[0] integerValue];
                NSInteger idx1 = [serTypes[1] integerValue];
                self.attributeLb.text = [NSString stringWithFormat:@"%@,%@",titleArr[idx],titleArr[idx1]];
            }
        }
    }
    
    if (self.model.serCert) {
        [self.merchantsCerBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [self.merchantsCerBtn setTitle:@"已认证" forState:UIControlStateHighlighted];
    } else {
        [self.merchantsCerBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [self.merchantsCerBtn setTitle:@"去认证" forState:UIControlStateHighlighted];
    }
    if (self.model.idcardCert) {
        [self.legalPersonCerBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [self.legalPersonCerBtn setTitle:@"已认证" forState:UIControlStateHighlighted];
    } else {
        [self.legalPersonCerBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [self.legalPersonCerBtn setTitle:@"去认证" forState:UIControlStateHighlighted];
    }
    if (self.model.platCert) {
        [self.platformCerBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [self.platformCerBtn setTitle:@"已认证" forState:UIControlStateHighlighted];
    } else {
        [self.platformCerBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [self.platformCerBtn setTitle:@"去认证" forState:UIControlStateHighlighted];
    }
}

#pragma mark - 设置导航栏
- (void)createBar {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//头像被点击
- (IBAction)headImageAction:(id)sender {
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

//商户身份属性被点击
- (IBAction)attributeAction:(id)sender {
    NSArray *titleArr = @[@"商品商户",@"仓储加工商户",@"物流商户",@"个体商户"];
    YGJAlertView *alertView = [[YGJAlertView alloc] initWithButtonTitleArr:titleArr withTitle:@"选择身份" isLogin:YES];
    alertView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [alertView show];
    
    @weakify(self);
    alertView.selectedArrButtonBlock = ^(NSMutableArray * _Nonnull buttonTitleArr,NSMutableArray * _Nonnull buttonTagArr) {
        @strongify(self);
        [YGJSQLITE_MANAGER clearLoginIdentity];
        [YGJSQLITE_MANAGER updateLoginIdentity:buttonTagArr];
        NSString *attributeStr = [buttonTitleArr componentsJoinedByString:@","];
        self.attributeLb.text = attributeStr;
    };
}
//认证被点击
- (IBAction)cerAction:(UIButton *)sender {
    NSInteger index = sender.tag - 600;
    if (index == 0) {
        if (self.model.serCert) {
            [YGJToast showToast:@"您已认证！"];
            return;
        }
        MerchantCAViewController *vc = [[MerchantCAViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        if (self.model.idcardCert) {
            [YGJToast showToast:@"您已认证！"];
            return;
        }
        LegalPersonCAViewController *vc = [[LegalPersonCAViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (self.model.platCert) {
            [YGJToast showToast:@"您已认证！"];
            return;
        }
    }
}
//保存按钮点击
- (void)rightButtonOnClicked {
    //公司名字
    NSString *fullNameStr = self.companyNameTF.text;
    //简介
    NSString *introStr = self.introTF.text;
    //电话
    NSString *phoneStr = self.phoneTF.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (fullNameStr && fullNameStr.length) {
        [params setObject:fullNameStr forKey:@"fullName"];
    }
    if (introStr && introStr.length) {
        [params setObject:introStr forKey:@"serDesc"];
    }
    if (self.model.serLogo && self.model.serLogo.length) {
        [params setObject:self.model.serLogo forKey:@"serLogo"];
    }
    if (phoneStr && phoneStr.length) {
        [params setObject:phoneStr forKey:@"serPhone"];
    }
    [UDAAPIRequest requestUrl:@"/app/users/editUserInfo" parameter:params requestType:UDARequestTypePut isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        if (requestModel.success) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            UserModel *model = [UserModel modelWithDictionary:requestModel.result];
            [YGJSQLITE_MANAGER updateUserInfoModel:model];
            [YGJToast showToast:@"保存成功"];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}
//调用相机
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
//是否开启相册权限
- (BOOL)judgeImagePickerAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        
        [YGJToast showToast:@"请在系统设置中允许御管家打开相册"];
        return NO;
    } else {
        return YES;
    }
}
//是否开启相机权限
- (BOOL)judgeCameraAuthorizationStatus {
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status ==AVAuthorizationStatusDenied || status ==AVAuthorizationStatusRestricted){
        
        [YGJToast showToast:@"请在系统设置中允许御管家打开相机"];
        return NO;
    } else {
        return YES;
    }
}
//判断权限是否开启
- (BOOL)judgeImagePickerwithSourceType:(UIImagePickerControllerSourceType)type {
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        return [self judgeImagePickerAuthorizationStatus];
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        return [self judgeCameraAuthorizationStatus];
    }
    return YES;
}
//获取到图片以后进行上传
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //先把图片转成NSData
    WS(weakSelf)
    //    NSString *token = [kNSUserDefaults objectForKey:@"userToken"];
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
                weakSelf.headImageView.image = image;
                weakSelf.model.serLogo = requestModel.result[@"filePath"];
                
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FAREN-SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHANGHU-SUCCESS" object:nil];
}


@end
