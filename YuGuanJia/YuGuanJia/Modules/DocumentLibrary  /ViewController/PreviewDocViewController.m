//
//  PreviewDocViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import "PreviewDocViewController.h"
#import "RevisionHistoryViewController.h"
#import "LuckySheetViewController.h"
#import "DocumentOperationViewController.h"

// views
#import "PreviewBottomView.h"
#import "YGJPopupMenuButtonItem.h"
#import "PreviewTopView.h"

#import "YGJDocumentsApi.h"

@interface PreviewDocViewController () <PreviewBottomViewDelegate, YGJPopupMenuButtonItemDelegate, PreviewTopViewDelegate, QMUIImagePreviewViewDelegate>

@property (nonatomic, strong) QMUIButton *editBtn;
@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) PreviewBottomView *bottomView;
@property (nonatomic, strong) PreviewTopView *topView;
@property (nonatomic, strong) QMUIImagePreviewView *imagePreviewView;

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NSString *previewUrl;
@property (nonatomic, copy) NSString *tempContent;
@property (nonatomic, copy) NSString *beingSerId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) int tempType;
@property (nonatomic, copy) NSString *tempName;
@property (nonatomic, strong) NSMutableArray *leftMutaArr;
@property (nonatomic, strong) NSMutableArray *rightMutaArr;
@property (nonatomic, assign) BOOL isLoad;
@end

@implementation PreviewDocViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithId:(NSString *)idString {
    if (self = [super init]) {
        self.idString = idString;
    }
    return self;
}
#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange) name:UIDeviceOrientationDidChangeNotification object:nil];

    self.isLoad = false;
    [self initSubviews];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (UIInterfaceOrientationMask)deviceOrientationMask {
    return  UIInterfaceOrientationMaskAllButUpsideDown;
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.title = @"????????????";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.popupByWindow.sourceView = self.editBtn;
   
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(kScale_W(120));
    }];
    
    [self.view addSubview:self.imagePreviewView];
    [self.imagePreviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    [self loadData];
}
#pragma mark - Network Methods
- (void)loadData {

    @weakify(self);
    [YGJDocumentsApi requestDocumentsQueryById:@{@"id":self.idString ? self.idString : @""} success:^(UDAResponseDataModel *model) {

        @strongify(self);
        self.message = model.result[@"message"];
        self.previewUrl = model.result[@"previewUrl"];
        self.tempContent = model.result[@"tempContent"];
        self.tempType = [model.result[@"tempType"] intValue];
        self.tempName = model.result[@"tempName"];
        self.beingSerId = [NSString stringWithFormat:@"%@", model.result[@"beingSerId"]];
        NSArray *buttons = model.result[@"buttons"];
        [self setupButtonsList:buttons];
        self.isLoad = true;
    } error:nil];
}
#pragma mark - Event
- (void)editButtonMethod:(QMUIButton *)btn {
    
//    DocumentOperationViewController *vc = [[DocumentOperationViewController alloc] init];
//    vc.idStr = self.idString;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.popupByWindow showWithAnimated:true];
}

#pragma mark - Public Methods

#pragma mark - Private Method
- (void)setupButtonsList:(NSArray *)buttons {
    if ([buttons count] == 0) {
        return;
    }
    NSDictionary *titDict = @{@"MODIFY": @"??????",
                              @"CANCEL": @"??????",
                              @"REJECT": @"??????",
                              @"CONFIRM_CANCEL":@"????????????",
                              @"CONFIRM_CREATE": @"?????????",
                              @"EDIT": @"????????????",
                              @"CONFIRM": @"????????????",
                              @"MODIFY_LOG": @"??????????????????",
                              @"CREATE_AGAIN": @"???????????????",
                              @"LOGS": @"????????????????????????",
                              @"REJECT_MODIFY":@"????????????",
                              @"REJECT_CANCEL":@"????????????",
                              @"CONFIRM_MODIFY":@"????????????",
                              @"VIEW_DETAIL":@"????????????"
    };
    NSArray *leftMarkArr = @[@"CONFIRM_CREATE", @"EDIT", @"REJECT", @"CONFIRM",@"REJECT_MODIFY",@"REJECT_CANCEL",@"CONFIRM_MODIFY",@"CONFIRM_CANCEL"];
    for (NSString *key in buttons) {
        
        if ([leftMarkArr containsObject:key]) {
            [self.leftMutaArr addObject:titDict[key]];
        } else {
            [self.rightMutaArr addObject:titDict[key]];
        }
    }
    
    if ([self.leftMutaArr count] > 0) {
        [self.topView setupLeftButtons:self.leftMutaArr withMsg:self.message];
    }
    self.editBtn.hidden = ([self.rightMutaArr count] == 0) ? true : false;
    
    // ????????????????????????
    NSMutableArray *popMutaItems = [NSMutableArray array];
    @weakify(self);
    [self.rightMutaArr enumerateObjectsUsingBlock:^(NSString *tit, NSUInteger idx, BOOL *stop) {
        
        @strongify(self);
        [popMutaItems addObject:[YGJPopupMenuButtonItem itemTitle:tit index:idx delegate:self]];
    }];
    self.popupByWindow.items = popMutaItems;
}
- (void)deviceOrientChange {
    [self.topView setupDeviceOrientation];
    
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.top.left.right.equalTo(self.view);
            make.height.mas_offset(kScale_W(50));
        }];
        [self.imagePreviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
        return;
    }
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(kScale_W(120));
    }];
    [self.imagePreviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}
#pragma mark - External Delegate
// MARK: PreviewTopViewDelegate
- (void)leftButtonEventWithTitle:(NSString *)title {
    @weakify(self);
    if ([title isEqualToString:@"?????????"]) {
        
        [self.view addSubview:self.bottomView];
        [self.bottomView setupHiddenTeamworkButtonWithBeingSerId:self.beingSerId];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.right.equalTo(self.view);
            make.height.mas_offset(kScale_W(50));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
        return;
    }
    if ([title isEqualToString:@"????????????"]) {
        NSString *tempName = CDNULLString(self.tempName) ? @"" : self.tempName;
        [self.navigationController pushViewController:[[LuckySheetViewController alloc] initWithDict:@{@"id": self.idString, @"tempContent": self.tempContent, @"tempType": @(self.tempType).stringValue, @"tempName": tempName} wthStatus:ExcelStautsDocunment] animated:true];
        return;
    }
    if ([title isEqualToString:@"????????????"]) {
        
        [YGJDocumentsApi requestDocumentsConfirm:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:^{
            
        }];
        return;
    }

    if ([title isEqualToString:@"??????"]) {
        
        [self rejectedDoc];
        return;
    }
    
    if ([title isEqualToString:@"????????????"]) {
        
        [self rejectedModifyDoc];
        return;
    }
    
    if ([title isEqualToString:@"????????????"]) {
        
        [self rejectedCancelDoc];
        return;
    }

    if ([title isEqualToString:@"????????????"]) {
        [YGJDocumentsApi requestDocumentsModify:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:^{
            
        }];
        return;
    }
}

/// ??????????????????????????????
- (void)rejectedDoc {
    
    @weakify(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        [YGJDocumentsApi requestDocumentsRejectTurndown:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:nil];

    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"???????????????" message:@"??????????????????????????????????????????" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];

}
/// ????????????
- (void)rejectedModifyDoc {
    
    @weakify(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        [YGJDocumentsApi requestDocumentsRejectModify:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];

        } error:^{
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"???????????????" message:@"??????????????????????????????????????????" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
/// ????????????
- (void)rejectedCancelDoc {
    
    @weakify(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [YGJDocumentsApi requestDocumentsRejectCancel:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:^{
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"???????????????" message:@"??????????????????????????????????????????" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
// MARK: YGJPopupMenuButtonItemDelegate
- (void)didSelectRowAtIndex:(NSUInteger)index withTitle:(NSString *)title {
    
    @weakify(self);
//    if ([title isEqualToString:@"??????"]) {
//        [YGJDocumentsApi requestDocumentsApprove:@{@"id": self.idString, @"remark": @""} success:^(UDAResponseDataModel *model) {
//            @strongify(self);
//            [self.navigationController popViewControllerAnimated:true];
//        } error:nil];
//        return;
//    }????????????????????????
    if ([title isEqualToString:@"????????????????????????"]) {
        DocumentOperationViewController *vc = [[DocumentOperationViewController alloc] init];
        vc.idStr = self.idString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"??????"]) {
        [self cancelDoc];
        return;
    }
    if ([title isEqualToString:@"???????????????"]) {
        
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.right.equalTo(self.view);
            make.height.mas_offset(kScale_W(50));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
        return;
    }
    if ([title isEqualToString:@"??????????????????"]) {
        [self.navigationController pushViewController:[[RevisionHistoryViewController alloc] initWithId:self.idString] animated:true];
        return;
    }
    if ([title isEqualToString:@"??????"]) {
        [YGJDocumentsApi requestDocumentsModify:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:^{
            
        }];
        return;
    }
    if ([title isEqualToString:@"????????????"]) {
        
        NSString *tempName = CDNULLString(self.tempName) ? @"" : self.tempName;
        [self.navigationController pushViewController:[[LuckySheetViewController alloc] initWithDict:@{@"id": self.idString, @"tempContent": self.tempContent, @"tempType": @(self.tempType).stringValue, @"tempName": tempName} wthStatus:ExcelStautsDocunmentNonEditable] animated:true];
        return;
    }
}
/// ??????
- (void)cancelDoc {
    
    @weakify(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"??????" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        [YGJDocumentsApi requestDocumentsCancel:@{@"id": self.idString} success:^(UDAResponseDataModel *model) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:true];
        } error:nil];

    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"???????????????" message:@"??????????????????????????????????????????" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];

}
/// MARK: PreviewBottomViewDelegate
/// ???????????? ??????ID processID, ?????????ID: teamworkID
- (void)confirmNewExcelWithProcessID:(NSString *)processID withTeamworkID:(NSString *)teamworkID {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:self.idString forKey:@"id"];
    [params jk_setObj:processID forKey:@"serProcId"];

    @weakify(self);
    [YGJDocumentsApi requestDocumentsConfirmCreate:params success:^(UDAResponseDataModel *model) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:true];
    } error:^{
        
    }];
}

/// MARK: QMUIImagePreviewViewDelegate
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    
    @weakify(self);
    zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    zoomImageView.image = nil; // ??? 2 ???????????????????????????????????????????????????
    [zoomImageView showLoading];// ?????? loading???loading ??????????????????????????????
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.previewUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        @strongify(self);
//        NSUInteger indexForZoomImageView = [imagePreviewView indexForZoomImageView:zoomImageView];
//        if (indexForZoomImageView == index)
        if (finished) [zoomImageView hideEmptyView];
        if (image) zoomImageView.image = image;
        if (error) {
            NSString *msgText = self.isLoad ? @"??????????????????" : @"???????????????...";
            [zoomImageView showEmptyViewWithText:msgText];
        }
    }];
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index {

}

/// MARK: PreviewBottomViewDelegate

#pragma mark ??? Getters and Setters
- (void)setPreviewUrl:(NSString *)previewUrl {
    _previewUrl = previewUrl;
    if (_previewUrl.length == 0) return;
    
    [self.imagePreviewView.collectionView reloadData];
}
- (QMUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[QMUIButton alloc] qmui_initWithImage:nil title:@"??????"];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_editBtn addTarget:self action:@selector(editButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
//        _editBtn.spacingBetweenImageAndTitle = 6.0;
        _editBtn.titleLabel.font = UIFontBoldMake(16);
//        _editBtn.imagePosition = QMUIButtonImagePositionRight;
        _editBtn.frame = CGRectMake(0, 0, 80, 40);
        _editBtn.hidden = true;
    }
    return _editBtn;
}

- (QMUIPopupMenuView *)popupByWindow {
    if (!_popupByWindow) {
        _popupByWindow = [[QMUIPopupMenuView alloc] init];
        _popupByWindow.automaticallyHidesWhenUserTap = true;// ??????????????????????????????
        _popupByWindow.tintColor = UIColorMakeWithHex(@"#333333");
        _popupByWindow.maskViewBackgroundColor = [UIColor clearColor];
        _popupByWindow.shouldShowItemSeparator = true;
        _popupByWindow.minimumWidth = 123;
        _popupByWindow.maximumHeight = 262;
        _popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            
            aItem.button.titleLabel.font = UIFontMake(15);
            aItem.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [aItem.button setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
            [aItem.button setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateHighlighted];
            aItem.button.highlightedBackgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        };
        _popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        };
    }
    return _popupByWindow;;
}
- (PreviewBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PreviewBottomView alloc] initWithDelegate:self];
    }
    return _bottomView;
}
- (PreviewTopView *)topView {
    if (!_topView) {
        _topView = [[PreviewTopView alloc] initWithDelegate:self];
    }
    return _topView;
}
- (QMUIImagePreviewView *)imagePreviewView {
    if (!_imagePreviewView) {
        _imagePreviewView = [[QMUIImagePreviewView alloc] init];
        _imagePreviewView.delegate = self;
        _imagePreviewView.loadingColor = UIColorGray;// ???????????????????????? loading ??????????????????????????????????????????
        _imagePreviewView.collectionViewLayout.minimumLineSpacing = 0;// ?????????????????????????????????
    }
    return _imagePreviewView;
}
- (NSMutableArray *)leftMutaArr {
    if (!_leftMutaArr) {
        _leftMutaArr = [NSMutableArray array];
    }
    return _leftMutaArr;
}
- (NSMutableArray *)rightMutaArr {
    if (!_rightMutaArr) {
        _rightMutaArr = [NSMutableArray array];
    }
    return _rightMutaArr;
}
@end
