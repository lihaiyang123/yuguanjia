//
//  PersonalInformationViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "PersonalInformationViewController.h"
#import "MerchantCAViewController.h"
#import "LegalPersonCAViewController.h"
#import "LoginViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/PHAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>

//views
#import "InformationTableViewCell.h"
#import "BaseTableView.h"

//model
#import "UserModel.h"

@interface PersonalInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *allTableView;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) QMUIButton *exitButton;
@property (nonatomic, strong) UIView *footview;

@property (strong, nonatomic) NSMutableArray *heightArray;
@end

@implementation PersonalInformationViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFaRenTips:) name:@"FAREN-SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFaRenTips:) name:@"SHANGHU-SUCCESS" object:nil];

    @weakify(self)
    [UDAAPIRequest requestUrl:@"/app/users/getUsersInfoByToken" parameter:nil requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self)
        if (requestModel.success) {
            
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:requestModel.result];
            [self.allTableView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (void)showFaRenTips:(NSNotification *)notification {
    [YGJToast showToast:@"ζδΊ€ζε"];
}

- (void)injected {

    [self.allTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"δΈͺδΊΊδΏ‘ζ―";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.heightArray = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[@55,@55,@55,@55,@55]],[NSMutableArray arrayWithArray:@[@55,@55,@55]]]];
    [self createBar];
    [self.view addSubview:self.allTableView];
}

#pragma mark - θ?Ύη½?ε―Όθͺζ 
- (void)createBar {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"δΏε­" forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - tableView delegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *sectionHeightArray = self.heightArray[indexPath.section];
    CGFloat height = [sectionHeightArray[indexPath.row] floatValue];
    NSLog(@"%f",height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InformationTableViewCell className]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.underLineView.hidden = indexPath.row == 2;
    cell.cellIndexPath = indexPath;
    @weakify(self);
    cell.heightBlock = ^(CGFloat height, NSIndexPath * _Nonnull cellIndexPath) {
        @strongify(self);
        NSMutableArray *sectionArray = self.heightArray[cellIndexPath.section];
        if ([sectionArray[cellIndexPath.row] floatValue] != height) {
            sectionArray[cellIndexPath.row] = @(height);
            [self.allTableView reloadRow:cellIndexPath.row inSection:cellIndexPath.section withRowAnimation:UITableViewRowAnimationNone];
            InformationTableViewCell *currentCell = (InformationTableViewCell *)[self.allTableView cellForRowAtIndexPath:cellIndexPath];
            [currentCell.rightInputTF.textView resignFirstResponder];
        }
    };
    
    cell.textChangeBlock = ^(NSString * _Nonnull text, NSIndexPath * _Nonnull cellIndexPath) {
        @strongify(self);
        if (cellIndexPath.section == 0) {
            if (cellIndexPath.row == 1) {
                self.dataDic[@"fullName"] = text;
            }else if (indexPath.row == 2) {
                self.dataDic[@"serDesc"] = text;
            } else if (indexPath.row == 3) {
                self.dataDic[@"serPhone"] = text;
            }
        }
    };
    if (indexPath.section == 0) {
        cell.rightRenZhengLabel.hidden = YES;
        if (indexPath.row == 0) {
            [cell.headImageView sd_setImageWithURL:self.imageURL && self.imageURL.length ? self.imageURL : self.dataDic[@"serLogo"]];
            cell.leftTipsLabel.hidden = YES;
            cell.rightInputTF.hidden = YES;
            cell.headImageView.hidden = NO;
            cell.nextImageView.hidden = NO;

        } else if (indexPath.row == 1) {
            
            cell.headImageView.hidden = YES;
            cell.nextImageView.hidden = YES;
            cell.leftTipsLabel.hidden = NO;
            cell.rightInputTF.hidden = NO;
            cell.leftTipsLabel.text = @"ε¬εΈε¨η§°";
            cell.rightInputTF.text = self.dataDic[@"fullName"];
            
        }else if (indexPath.row == 2) {
            
            cell.headImageView.hidden = YES;
            cell.nextImageView.hidden = YES;
            cell.leftTipsLabel.hidden = NO;
            cell.rightInputTF.hidden = NO;
            cell.leftTipsLabel.text = @"η?δ»";
            cell.rightInputTF.text = self.dataDic[@"serDesc"];
        } else if (indexPath.row == 3) {
            
            cell.headImageView.hidden = YES;
            cell.nextImageView.hidden = YES;
            cell.leftTipsLabel.hidden = NO;
            cell.rightInputTF.hidden = NO;
            cell.leftTipsLabel.text = @"εζ·η΅θ―";
            cell.rightInputTF.text = self.dataDic[@"serPhone"];
            
        } else {
            cell.headImageView.hidden = YES;
            cell.rightInputTF.hidden = NO;
            cell.rightInputTF.enabled = false;
            cell.leftTipsLabel.text = @"εζ·θΊ«δ»½ε±ζ§";
            NSArray *localID = [YGJSQLITE_MANAGER getUserIdentity];
            if ([localID count] != 0) {
                NSArray *titleArr = @[@"εεεζ·",@"δ»ε¨ε ε·₯εζ·",@"η©ζ΅εζ·",@"δΈͺδ½εζ·"];
                cell.nextImageView.hidden = NO;
                if ([localID count] == 1) {
                    NSInteger idx = [localID[0] integerValue];
                    cell.rightInputTF.text = titleArr[idx];
                } else {
                    NSInteger idx = [localID[0] integerValue];
                    NSInteger idx1 = [localID[1] integerValue];
                    cell.rightInputTF.text = [NSString stringWithFormat:@"%@,%@",titleArr[idx],titleArr[idx1]];
                }
            }else {
                cell.nextImageView.hidden = YES;
                NSArray *serTypes = self.dataDic[@"serTypes"];
                NSArray *titleArr = @[@"εεεζ·",@"δ»ε¨ε ε·₯εζ·",@"η©ζ΅εζ·",@"δΈͺδ½εζ·"];
                if ([serTypes count] == 1) {
                    NSInteger idx = [serTypes[0] integerValue];
                    cell.rightInputTF.text = titleArr[idx];
                } else {
                    if ([serTypes count] >= 2) {
                        NSInteger idx = [serTypes[0] integerValue];
                        NSInteger idx1 = [serTypes[1] integerValue];
                        cell.rightInputTF.text = [NSString stringWithFormat:@"%@,%@",titleArr[idx],titleArr[idx1]];
                    }
                }
            }
        }
    } else {
        cell.rightRenZhengLabel.hidden = NO;
        cell.rightInputTF.hidden = YES;
        cell.headImageView.hidden = YES;
        cell.nextImageView.hidden = YES;
        if (indexPath.row == 0) {
            
            if ([self.dataDic[@"serCert"] integerValue] == 1) {
                cell.rightRenZhengLabel.text = @"ε·²θ?€θ―";
            } else {
                cell.rightRenZhengLabel.text = @"ε»θ?€θ―";
            }
            cell.leftTipsLabel.text = @"εζ·θ?€θ―";
        } else if (indexPath.row == 1) {
            
            if ([self.dataDic[@"idcardCert"] integerValue] == 1) {
                cell.rightRenZhengLabel.text = @"ε·²θ?€θ―";
            } else {
                cell.rightRenZhengLabel.text = @"ε»θ?€θ―";
            }
            cell.leftTipsLabel.text = @"ζ³δΊΊθ?€θ―";
        }else {
            
            if ([self.dataDic[@"platCert"] integerValue] == 1) {
                cell.rightRenZhengLabel.text = @"ε·²θ?€θ―";
            } else {
                cell.rightRenZhengLabel.text = @"ε»θ?€θ―";
            }
            cell.leftTipsLabel.text = @"εΉ³ε°θ?€θ―";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 48;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(12.5f, 22, 100, 15);
    headLabel.backgroundColor = KClearColor;
    headLabel.text = @"θ?€θ―";
    headLabel.font = FONTSIZEBOLD(16);
    [headerView addSubview:headLabel];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 48);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self openPhoto];
        } else if (indexPath.row == 4	) {
            NSArray *localID = [YGJSQLITE_MANAGER getUserIdentity];
            if ([localID count] != 0) {
                [self selectedID];
            }
        }
    } else {
        
        if (indexPath.row == 0) {
            if ([self.dataDic[@"serCert"] integerValue] == 1) {
                
                [YGJToast showToast:@"ζ¨ε·²θ?€θ―οΌ"];
                return;
            }
            MerchantCAViewController *vc = [[MerchantCAViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            if ([self.dataDic[@"idcardCert"] integerValue] == 1) {
                
                [YGJToast showToast:@"ζ¨ε·²θ?€θ―οΌ"];
                return;
            }
            LegalPersonCAViewController *vc = [[LegalPersonCAViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            if ([self.dataDic[@"platCert"] integerValue] == 1) {
                
                [YGJToast showToast:@"ζ¨ε·²θ?€θ―οΌ"];
                return;
            }
        }
    }
}

- (void)selectedID {
    
    NSArray *titleArr = @[@"εεεζ·",@"δ»ε¨ε ε·₯εζ·",@"η©ζ΅εζ·",@"δΈͺδ½εζ·"];
    YGJAlertView *alertView = [[YGJAlertView alloc] initWithButtonTitleArr:titleArr withTitle:@"ιζ©θΊ«δ»½" isLogin:YES];
    alertView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [alertView show];
    
    @weakify(self);
    alertView.selectedArrButtonBlock = ^(NSMutableArray * _Nonnull buttonTitleArr,NSMutableArray * _Nonnull buttonTagArr) {
        
        @strongify(self);
        [YGJSQLITE_MANAGER clearLoginIdentity];
        [YGJSQLITE_MANAGER updateLoginIdentity:buttonTagArr];
        [self.allTableView reloadData];
    };
}

- (void)rightButtonOnClicked {
    
    NSIndexPath *fullNamePath=[NSIndexPath indexPathForRow:1 inSection:0];//ε¬εΈεε­
    InformationTableViewCell *fullNameCell = (InformationTableViewCell *)[self.allTableView cellForRowAtIndexPath:fullNamePath];
    NSString *fullNameStr = fullNameCell.rightInputTF.text;
    
    NSIndexPath *introPath=[NSIndexPath indexPathForRow:2 inSection:0];//η?δ»
    InformationTableViewCell *introCell = (InformationTableViewCell *)[self.allTableView cellForRowAtIndexPath:introPath];
    NSString *introStr = introCell.rightInputTF.text;
    
    NSIndexPath *phonePath=[NSIndexPath indexPathForRow:3 inSection:0];//η΅θ―
    InformationTableViewCell *phoneCell = (InformationTableViewCell *)[self.allTableView cellForRowAtIndexPath:phonePath];
    NSString *phoneStr = phoneCell.rightInputTF.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (fullNameStr && fullNameStr.length) {
        [params setObject:fullNameStr forKey:@"fullName"];
    }
    if (introStr && introStr.length) {
        [params setObject:introStr forKey:@"serDesc"];
    }
    if (self.imageURL && self.imageURL.length) {
        [params setObject:self.imageURL forKey:@"serLogo"];
    }
    if (phoneStr && phoneStr.length) {
        [params setObject:phoneStr forKey:@"serPhone"];
    }
    
//    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/editUserInfo" parameter:params requestType:UDARequestTypePut isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
//        @strongify(self);
        if (requestModel.success) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            UserModel *model = [UserModel modelWithDictionary:requestModel.result];
            [YGJSQLITE_MANAGER updateUserInfoModel:model];
            [YGJToast showToast:@"δΏε­ζε"];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (BaseTableView *)allTableView {
    
    if (!_allTableView) {
        
        _allTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, kScreenHeight-kStatusBarHeight-kTabBarHeight) style:UITableViewStylePlain];
        if(@available(iOS 15.0, *)){
            _allTableView.sectionHeaderTopPadding = 0;
        }
        _allTableView.dataSource = self;
        _allTableView.delegate = self;
        _allTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _allTableView.tableFooterView = self.footview;
        [_allTableView registerClass:[InformationTableViewCell class] forCellReuseIdentifier:[InformationTableViewCell className]];
        [self.footview addSubview:self.exitButton];
    }
    
    return _allTableView;
}

- (void)openPhoto {
    WS(weakSelf)
    NSString *takePhotoTitle = @"ζη§";
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"ε»ηΈειζ©" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"εζΆ" style:UIAlertActionStyleCancel handler:nil];
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
        //θ?Ύη½?ζη§εηεΎηε―θ’«ηΌθΎ
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
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        
        [YGJToast showToast:@"θ―·ε¨η³»η»θ?Ύη½?δΈ­εθ?ΈεΎ‘η?‘ε?ΆζεΌηΈε"];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)judgeCameraAuthorizationStatus {
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status ==AVAuthorizationStatusDenied || status ==AVAuthorizationStatusRestricted){
        
        [YGJToast showToast:@"θ―·ε¨η³»η»θ?Ύη½?δΈ­εθ?ΈεΎ‘η?‘ε?ΆζεΌηΈζΊ"];
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
    //εζεΎηθ½¬ζNSData
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
                YDZYLog(@"ιΏδΌ εεΌ εΎη ----> %@",requestModel);
                weakSelf.headImage = image;
                weakSelf.imageURL = requestModel.result[@"filePath"];
                [weakSelf.allTableView reloadData];
                
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

- (void)exitButtonEvent:(UIButton *)btn {
    
    @weakify(self)
    [UDAAPIRequest requestUrl:@"/app/base/logout" parameter:nil requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self)
        if (requestModel.code == 0) {
            [self switchViewController];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}
- (void)switchViewController {
    [YGJSQLITE_MANAGER clearLoginToken];
    LoginViewController *rootViewController = [LoginViewController new];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    typedef void (^Animation)(void);
    Animation animation = ^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:false];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        });
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:window duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}
#pragma mark - Setter Getter Methods
- (UIView *)footview {
    if (!_footview) {
        _footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.0)];
        _footview.backgroundColor = [UIColor clearColor];
    }
    return _footview;
}
- (QMUIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"set_exit") title:@"ιεΊη»ε½"];
        _exitButton.frame = CGRectMake(38, 45, SCREEN_WIDTH - 76.0, 50.0);
        _exitButton.imagePosition = QMUIButtonImagePositionLeft;
        _exitButton.titleLabel.font = UIFontBoldMake(18);
        _exitButton.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        [_exitButton setTitleColor:UIColorMakeWithHex(@"#4E8BED") forState:UIControlStateNormal];
        _exitButton.layer.cornerRadius = 50.0/2.0;
        _exitButton.layer.masksToBounds = true;
        _exitButton.spacingBetweenImageAndTitle = 7.f;
        [_exitButton addTarget:self action:@selector(exitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FAREN-SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHANGHU-SUCCESS" object:nil];
}
@end
