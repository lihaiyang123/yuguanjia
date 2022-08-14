//
//  TemplatePreviewViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import "TemplatePreviewViewController.h"
#import "LuckySheetViewController.h"

// views
#import "PreviewBottomView.h"

#import "YGJDocumentsApi.h"

@interface TemplatePreviewViewController () <PreviewBottomViewDelegate, QMUIImagePreviewViewDelegate>

@property (nonatomic, strong) QMUIButton *editBtn;
@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) PreviewBottomView *bottomView;
@property (nonatomic, strong) QMUIImagePreviewView *imagePreviewView;

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NSString *previewUrl;
@property (nonatomic, copy) NSString *tempContent;
@property (nonatomic, copy) NSString *tempName;
@property (nonatomic, assign) int tempType;
@property (nonatomic, assign) BOOL isLoad;
@end

@implementation TemplatePreviewViewController

- (instancetype)initWithId:(NSString *)idString {
    if (self = [super init]) {
        self.idString = idString;
    }
    return self;
}
#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}
- (UIInterfaceOrientationMask)deviceOrientationMask {
    return  UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.title = @"模版预览";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.popupByWindow.sourceView = self.editBtn;
    
    [self.view addSubview:self.imagePreviewView];
    [self.imagePreviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
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
    [YGJDocumentsApi requestTemplatesQueryById:@{@"id":self.idString ? self.idString : @""} success:^(UDAResponseDataModel *model) {
        
        @strongify(self);
        if ([model.result[@"tempStatus"] integerValue] == 0) {
            //审核中状态隐藏编辑按钮
            self.editBtn.hidden = YES;
        }
        self.previewUrl = model.result[@"previewUrl"];
        self.tempContent = model.result[@"tempContent"];
        self.tempName = model.result[@"tempName"];
        self.tempType = [model.result[@"tempType"] intValue];
        self.isLoad = false;
    } error:nil];
    
    self.popupByWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"新建" handler:^(QMUIPopupMenuButtonItem *aItem) {
        @strongify(self);

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
        [aItem.menuView hideWithAnimated:true];
    }],
//    [QMUIPopupMenuButtonItem itemWithImage:nil title:@"编辑模版" handler:^(QMUIPopupMenuButtonItem *aItem) {
//        @strongify(self);
//        [aItem.menuView hideWithAnimated:true];
//        NSString *tempName = CDNULLString(self.tempName) ? @"" : self.tempName;
//        [self.navigationController pushViewController:[[LuckySheetViewController alloc] initWithDict:@{@"id": self.idString, @"tempContent": self.tempContent, @"tempType": @(self.tempType).stringValue, @"tempName": tempName} wthStatus:ExcelStautsTemplateEdit] animated:true];
//    }],
    [QMUIPopupMenuButtonItem itemWithImage:nil title:@"自定义模版" handler:^(QMUIPopupMenuButtonItem *aItem) {
        @strongify(self);
        [aItem.menuView hideWithAnimated:true];
        NSString *tempName = CDNULLString(self.tempName) ? @"" : self.tempName;
        [self.navigationController pushViewController:[[LuckySheetViewController alloc] initWithDict:@{@"id": self.idString, @"tempContent": self.tempContent, @"tempType": @(self.tempType).stringValue, @"tempName": tempName} wthStatus:ExcelStautsTemplateCustom] animated:true];
    }]];
}
#pragma mark - Event
- (void)editButtonMethod:(QMUIButton *)btn {
    if ([YGJSQLITE_MANAGER isShouldToAuthentication]) {
        
        [YGJCommonPopup showPopupStatus:YGJPopupStatusAuth complete:nil cancelHandler:nil];
        return;
    }
    [self.popupByWindow showWithAnimated:true];
}

#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - External Delegate

/// MARK: QMUIImagePreviewViewDelegate
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    
    @weakify(self);
    zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    zoomImageView.image = nil; // 第 2 张图将图片清空，模拟延迟加载的场景
    [zoomImageView showLoading];// 显示 loading（loading 也可与图片同时显示）
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.previewUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        @strongify(self);
//        NSUInteger indexForZoomImageView = [imagePreviewView indexForZoomImageView:zoomImageView];
//        if (indexForZoomImageView == index)
        if (finished) [zoomImageView hideEmptyView];
        if (image) zoomImageView.image = image;
        if (error) {
            NSString *msgText = self.isLoad ? @"文件加载失败" : @"文件加载中...";
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
/// 确认新建 流程ID processID, 合作方ID: teamworkID
- (void)confirmNewExcelWithProcessID:(NSString *)processID withTeamworkID:(NSString *)teamworkID {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setInt:self.tempType forKey:@"tempType"];
    [params jk_setObj:self.tempContent forKey:@"tempContent"];
    [params jk_setObj:self.previewUrl forKey:@"previewUrl"];
    [params jk_setObj:teamworkID forKey:@"beingSerId"];
    [params jk_setObj:processID forKey:@"serProcId"];
    
    @weakify(self);
    [YGJDocumentsApi requestDocumentsAdd:params success:^(UDAResponseDataModel *model) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:true];
        
    } error:nil];
}
#pragma mark – Getters and Setters
- (void)setPreviewUrl:(NSString *)previewUrl {
    _previewUrl = previewUrl;
    if (_previewUrl.length == 0) return;
    
    [self.imagePreviewView.collectionView reloadData];
}
- (QMUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[QMUIButton alloc] qmui_initWithImage:nil title:@"编辑"];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_editBtn addTarget:self action:@selector(editButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
//        _editBtn.spacingBetweenImageAndTitle = 6.0;
        _editBtn.titleLabel.font = UIFontBoldMake(16);
//        _editBtn.imagePosition = QMUIButtonImagePositionRight;
        _editBtn.frame = CGRectMake(0, 0, 80, 40);
    }
    return _editBtn;
}

- (QMUIPopupMenuView *)popupByWindow {
    if (!_popupByWindow) {
        _popupByWindow = [[QMUIPopupMenuView alloc] init];
        _popupByWindow.automaticallyHidesWhenUserTap = true;// 点击空白地方消失浮层
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
- (QMUIImagePreviewView *)imagePreviewView {
    if (!_imagePreviewView) {
        _imagePreviewView = [[QMUIImagePreviewView alloc] init];
        _imagePreviewView.delegate = self;
        _imagePreviewView.loadingColor = UIColorGray;// 设置每张图片里的 loading 的颜色，需根据业务场景来修改
        _imagePreviewView.collectionViewLayout.minimumLineSpacing = 0;// 去掉每张图片之间的间隙
    }
    return _imagePreviewView;
}
@end
