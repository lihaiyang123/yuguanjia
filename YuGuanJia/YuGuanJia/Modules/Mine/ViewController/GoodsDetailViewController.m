//
//  GoodsDetailViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/9.
//

#import "GoodsDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "EditMyGoodsViewController.h"

#import <WKWebViewJavascriptBridge.h>

//views
#import "GoodsDetailBottomView.h"



#define YGJHTMLBUNDLE  [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"html.bundle"]]
#define  INIT_DATA(data)   [NSString stringWithFormat:@"initData('%@')", data]

static NSString *const kGoMerchantHomepage    = @"goMerchantHomepage";

@interface GoodsDetailViewController ()<WKUIDelegate ,WKNavigationDelegate,GoodsDetailBottomViewDelegate>

@property (nonatomic, readwrite, strong) WKWebView *webView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, strong)  id requestData;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, copy) NSString *serName;
@property (nonatomic, strong) GoodsDetailBottomView *goodsDetailBottomView;
@property (nonatomic, strong) QMUILabel *goodStateLabel;

@end

@implementation GoodsDetailViewController

- (instancetype)initWithId:(NSString *)idString {
    if (self = [super init]) {
        _idString = idString;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.isLoaded = false;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F2F4F5"]];
    [self initSubviews];
}

#pragma mark - Intial Methods
- (void)initSubviews {
        
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    [self registerNativeFunctions];
    [self loadRequest];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(kScale_W(40), 0, 0, 0);
    [self.webView.scrollView addSubview:self.goodStateLabel];

}
- (void)registerNativeFunctions {
    
    if (!_bridge) {
        [WKWebViewJavascriptBridge enableLogging];
        self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [self.bridge setWebViewDelegate:self];
    }
    @weakify(self);
    [_bridge registerHandler:kGoMerchantHomepage handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        
        CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] init];
        vc.companyName = self.serName;
        vc.serID = self.idString;
        [self.navigationController pushViewController:vc animated:true];
    }];
}

#pragma mark - Private Method
- (void)loadRequest {
    
    if (self.isPreview) {
        NSMutableDictionary *tmpMutaDict = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
        [tmpMutaDict jk_setObj:@(true) forKey:@"isPreview"];
        self.requestData = tmpMutaDict;
        if ([self.dataDic jk_stringForKey:@"goodsVo"]) {
            self.serName = self.dataDic[@"goodsVo"][@"serName"];
        }
        if (self.isLoaded) [self reloadWebviewData];
    }else {
        
        @weakify(self);
        [UDAAPIRequest requestUrl:@"/app/goods/queryById" parameter:@{@"id": self.idString} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            
            @strongify(self);
            if (requestModel.success) {
                NSMutableDictionary *tmpMutaDict = [NSMutableDictionary dictionaryWithDictionary:requestModel.result];
                [tmpMutaDict jk_setObj:@(false) forKey:@"isPreview"];
                self.requestData = tmpMutaDict; //jsonPrettyStringEncoded];
                [self refreshGoodsStatus];
                if ([requestModel.result jk_stringForKey:@"goodsVo"]) {
                    self.serName = requestModel.result[@"goodsVo"][@"serName"];
                }
                if (self.isLoaded) [self reloadWebviewData];
            }
        } errorBlock:^(NSError * _Nullable error) {
            
        }];
    }
}
///设置商品状态
- (void)refreshGoodsStatus {
    
    [self.view addSubview:self.goodsDetailBottomView];
    NSArray *stateArr = @[@"审核中",@"审核通过",@"被拒绝",@"上架中",@"已下架"];
    NSInteger state = [self.requestData[@"goodsVo"][@"state"] integerValue];
    self.goodStateLabel.text = stateArr[state];
    
    
//    if (state == YGJGoodsStatusUnderReview) {
//        self.goodsDetailBottomView.hidden = YES;
//    } else {
        
        self.goodsDetailBottomView.goodsID = [self.requestData[@"goodsVo"][@"id"] integerValue];
        self.goodsDetailBottomView.goodsStatus = YGJGoodsStatusApproved;
        if (state == YGJGoodsStatusRejected) {
            self.goodsDetailBottomView.rejectReason = @"xxxxxxx";
            [self.goodsDetailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(kScale_W(85));
            }];
        } else {
            [self.goodsDetailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(kScale_W(60));
            }];
        }
//        CGFloat webBottom = self.view.bottom-self.goodsDetailBottomView.height;
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.goodsDetailBottomView.mas_top);
        }];

//    }
    

}

/// 刷新webview的数据
- (void)reloadWebviewData {
    if (!self.requestData) return;
    [self.bridge callHandler:@"initData" data:self.requestData responseCallback:^(id responseData) {
    }];
}
#pragma mark - WKUIDelegate ,WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.isLoaded = true;
    [self reloadWebviewData];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    YDZYLog(@"加载出现错误:  %@", [error localizedDescription]);
}
// 解决内存占用过大白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    [webView reload];
}

#pragma mark - GoodsDetailBottomViewDelegate
- (void)pushEditGoodsViewController {
    
    EditMyGoodsViewController *vc = [[EditMyGoodsViewController alloc] init];
    vc.idStr = [NSString stringWithFormat:@"%@",self.requestData[@"goodsVo"][@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popGoodsListViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Setter Getter Methods

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
        _webView.scrollView.showsVerticalScrollIndicator = false;
        [_webView setOpaque:false]; //解决iOS9.2以上黑边问题
        _webView.multipleTouchEnabled = true;//关闭多点触控
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = false;
        _webView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)){
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        NSString *indexHtml = [YGJHTMLBUNDLE pathForResource:@"ExcelDetail/index" ofType:@"html"];
//        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@#/pages/mall/mall", indexHtml]];
        NSString *indexPath = [@"file://" stringByAppendingString:[NSString stringWithFormat:@"%@#/pages/mall/mall", [YGJHTMLBUNDLE pathForResource:@"mall/index" ofType:@"html"]]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:indexPath]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.2.220:8080/"]];

        [_webView loadRequest:request];
    }
    return _webView;
}

- (GoodsDetailBottomView *)goodsDetailBottomView {
    
    if (!_goodsDetailBottomView) {
        _goodsDetailBottomView = [[GoodsDetailBottomView alloc] initWithFrame:CGRectZero withDelegate:self];
    }
    return _goodsDetailBottomView;
}

- (QMUILabel *)goodStateLabel {

    if (!_goodStateLabel) {
        _goodStateLabel = [[QMUILabel alloc] initWithFrame:CGRectMake(10, -kScale_W(40), kScreenWidth-20, kScale_W(40))];
        _goodStateLabel.textColor = UIColorMakeWithHex(@"#FF1F44");
        _goodStateLabel.font = UIFontBoldMake(18);
    }
    return _goodStateLabel;
}

@end
