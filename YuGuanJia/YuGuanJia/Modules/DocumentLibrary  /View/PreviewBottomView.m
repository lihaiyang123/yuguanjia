//
//  PreviewBottomView.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/27.
//

#import "PreviewBottomView.h"

#import "YGJPopupMenuButtonItem.h"

// models
#import "MineFlowModel.h"
#import "YGJSerModel.h"

@interface PreviewBottomView () <YGJPopupMenuButtonItemDelegate>

@property (nonatomic, weak) id <PreviewBottomViewDelegate>delegate;
@property (nonatomic, strong) QMUIButton *processButton; // 流程
@property (nonatomic, strong) QMUIButton *teamworkButton; // 合作方, 服务商
@property (nonatomic, strong) QMUIButton *sureButton;

@property (nonatomic, strong) QMUIPopupMenuView *processPopup;
@property (nonatomic, strong) QMUIPopupMenuView *teamworkPopup;

@property (nonatomic, strong) NSMutableArray *processMutaArray;
@property (nonatomic, strong) NSMutableArray *teamworkMutaArray;

@property (nonatomic, copy) NSString *processID;
@property (nonatomic, copy) NSString *teamworkID;
@end

@implementation PreviewBottomView

- (instancetype)initWithDelegate:(id<PreviewBottomViewDelegate>)delegate {

	if (self = [super init]) {

		self.delegate = delegate;
		[self setupView];
	}
	return self;
}

#pragma mark - Intial Methods
- (void)setupView {

    self.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
	[self addSubview:self.processButton];
	self.processPopup.sourceView = self.processButton;

	[self addSubview:self.teamworkButton];
	self.teamworkPopup.sourceView = self.teamworkButton;
//	self.teamworkPopup.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"新建" handler:^(QMUIPopupMenuButtonItem *aItem) {
//
//	                                      [aItem.menuView hideWithAnimated:true];
//				      }]];
	[self addSubview:self.sureButton];
    
    [self loadRequest];
}
#pragma mark - Events
- (void)allButtonEvent:(QMUIButton *)btn {

	if (btn.tag == 3000) { // 审批流程
		[self.processPopup showWithAnimated:true];
		return;
	}
	if (btn.tag == 3001) { // 合作方

		[self.teamworkPopup showWithAnimated:true];
		return;
	}

	// 确认新建
    if (self.processID.length == 0) {
        [YGJToast showToast:@"请选择审批流程"];
        return;
    }
    if (!self.teamworkButton.hidden && self.teamworkID.length == 0) {
        [YGJToast showToast:@"请选择合作方"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(confirmNewExcelWithProcessID:withTeamworkID:)]) {
        [self.delegate confirmNewExcelWithProcessID:self.processID withTeamworkID:self.teamworkID];
    }
}
#pragma mark - Public Methods
- (void)setupHiddenTeamworkButtonWithBeingSerId:(NSString *)beingSerId {

    self.teamworkButton.hidden = true;
    self.teamworkID = beingSerId;
}

#pragma mark - Private Method
- (void)loadRequest {

	@weakify(self);
	[UDAAPIRequest requestUrl:@"/app/process/mylist" parameter:@{@"pageNo":@(1), @"pageSize": @(40)} requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {

	 } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
         @strongify(self);
         if (requestModel.success) {
			 MineFlowModel *model = [MineFlowModel modelWithDictionary:requestModel.result];
			 [self.processMutaArray addObjectsFromArray:model.records];
             [self setProcessPopupList];
		 }
	 } errorBlock:^(NSError * _Nullable error) {
	 }];
    
    [UDAAPIRequest requestUrl:@"/app/serviceProvider/list" parameter:@{@"pageSize":@(200)} requestType:UDARequestTypeGet isShowHUD:NO progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            YGJSerModel *model = [YGJSerModel modelWithDictionary:requestModel.result];
            [self.teamworkMutaArray addObjectsFromArray:model.serviceProviderVoList];
            [self setteamworkPopupList];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (void)setProcessPopupList {
    
    NSMutableArray *popMutaItems = [NSMutableArray array];
    
    @weakify(self);
    [self.processMutaArray enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL *stop) {
        
        @strongify(self);
        YGJPopupMenuButtonItem *item = [YGJPopupMenuButtonItem itemTitle:objDict[@"procName"] index:idx delegate:self];
        item.isProcess = true;
        [popMutaItems addObject:item];
    }];
    
    self.processPopup.items = popMutaItems;
}

- (void)setteamworkPopupList {
    
    NSMutableArray *popMutaItems = [NSMutableArray array];

    @weakify(self);
    [self.teamworkMutaArray enumerateObjectsUsingBlock:^(YGJSerItemModel *obj, NSUInteger idx, BOOL *stop) {

        @strongify(self);
        YGJPopupMenuButtonItem *item = [YGJPopupMenuButtonItem itemTitle:obj.serName index:idx delegate:self];
        item.isProcess = false;
        [popMutaItems addObject:item];
    }];

    self.teamworkPopup.items = popMutaItems;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGFloat btnW = CGRectGetWidth(self.frame)/3.0;
	CGFloat btnH = CGRectGetHeight(self.frame);

	self.processButton.frame = CGRectMake(0, 0, btnW, btnH);
	self.teamworkButton.frame = CGRectMake(btnW, 0, btnW, btnH);
	self.sureButton.frame = CGRectMake(btnW * 2, 0, btnW, btnH);
}

#pragma mark - External Delegate

/// MARK: YGJPopupMenuButtonItemDelegate
- (void)didSelectRowAtIndex:(NSUInteger)index isProcess:(BOOL)isProcess {
    
    if (isProcess) { // 选择流程
//        self.processMutaArray[index];
        NSDictionary *dict = self.processMutaArray[index];
        [self.processButton setTitle:dict[@"procName"] forState:UIControlStateNormal];
        self.processID = [NSString stringWithFormat:@"%@", dict[@"id"]];
        return;
    }
    
    YGJSerItemModel *itemModel = self.teamworkMutaArray[index];
    [self.teamworkButton setTitle:itemModel.serName forState:UIControlStateNormal];
    self.teamworkID = [NSString stringWithFormat:@"%d", itemModel.id];
}

#pragma mark – Getters and Setters
- (QMUIButton *)processButton {
	if (!_processButton) {
		_processButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"down_home") title:@"选择审批流程"];
		_processButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		_processButton.tag = 3000;
		[_processButton addTarget:self action:@selector(allButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
		[_processButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
		_processButton.spacingBetweenImageAndTitle = 6.0;
		_processButton.titleLabel.font = UIFontMake(14.0);
		_processButton.imagePosition = QMUIButtonImagePositionRight;
	}
	return _processButton;
}
- (QMUIButton *)teamworkButton {
	if (!_teamworkButton) {
		_teamworkButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"down_home") title:@"选择合作方"];
		_teamworkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		_teamworkButton.tag = 3001;
		[_teamworkButton addTarget:self action:@selector(allButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
		[_teamworkButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
		_teamworkButton.spacingBetweenImageAndTitle = 6.0;
		_teamworkButton.titleLabel.font = UIFontMake(14.0);
		_teamworkButton.imagePosition = QMUIButtonImagePositionRight;
	}
	return _teamworkButton;
}
- (QMUIButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"down_home") title:@"确认创建"];
		_sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		_sureButton.tag = 3002;
		[_sureButton addTarget:self action:@selector(allButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
		[_sureButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
		[_sureButton setBackgroundColor:UIColorMakeWithHex(@"#4581EB")];
		_sureButton.titleLabel.font = UIFontMake(14.0);
	}
	return _sureButton;
}
- (QMUIPopupMenuView *)processPopup {
	if (!_processPopup) {
		_processPopup = [[QMUIPopupMenuView alloc] init];
		_processPopup.automaticallyHidesWhenUserTap = true;// 点击空白地方消失浮层
		_processPopup.tintColor = UIColorMakeWithHex(@"#333333");
		_processPopup.maskViewBackgroundColor = [UIColor clearColor];
		_processPopup.shouldShowItemSeparator = true;
		_processPopup.minimumWidth = SCREEN_WIDTH/3.0;
		_processPopup.maximumHeight = 362;
		_processPopup.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {

			aItem.button.titleLabel.font = UIFontMake(15);
			aItem.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
			[aItem.button setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
			[aItem.button setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateHighlighted];
			aItem.button.highlightedBackgroundColor = UIColorMakeWithHex(@"#FFFFFF");
		};
		_processPopup.didHideBlock = ^(BOOL hidesByUserTap) {
		};
	}
	return _processPopup;;
}
- (QMUIPopupMenuView *)teamworkPopup {
	if (!_teamworkPopup) {
		_teamworkPopup = [[QMUIPopupMenuView alloc] init];
		_teamworkPopup.automaticallyHidesWhenUserTap = true;// 点击空白地方消失浮层
		_teamworkPopup.tintColor = UIColorMakeWithHex(@"#333333");
		_teamworkPopup.maskViewBackgroundColor = [UIColor clearColor];
		_teamworkPopup.shouldShowItemSeparator = true;
		_teamworkPopup.minimumWidth = SCREEN_WIDTH/3.0;
		_teamworkPopup.maximumHeight = 362;
		_teamworkPopup.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {

			aItem.button.titleLabel.font = UIFontMake(15);
			aItem.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
			[aItem.button setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
			[aItem.button setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateHighlighted];
			aItem.button.highlightedBackgroundColor = UIColorMakeWithHex(@"#FFFFFF");
		};
		_teamworkPopup.didHideBlock = ^(BOOL hidesByUserTap) {
		};
	}
	return _teamworkPopup;;
}
- (NSMutableArray *)processMutaArray {
    if (!_processMutaArray) {
        _processMutaArray = [NSMutableArray array];
    }
    return _processMutaArray;
}
- (NSMutableArray *)teamworkMutaArray {
    if (!_teamworkMutaArray) {
        _teamworkMutaArray = [NSMutableArray array];
    }
    return _teamworkMutaArray;
}
@end
