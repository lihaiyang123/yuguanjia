//
//  YGJSQLiteManager.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/22.
//

#import "YGJSQLiteManager.h"
// 定位
#import <CoreLocation/CoreLocation.h>
//models
#import "UserModel.h"

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

static NSString *const YGJSQLiteName = @"YGJSQLiteName";

static NSString *const YGJLoginToken = @"YGJLoginToken";

static NSString *const YGJLoginIdentity = @"YGJLoginIdentity";

static NSString *const YGJLoginRequestIdentity = @"YGJLoginRequestIdentity";

static NSString *const YGJUserModel = @"YGJUserModel";

static NSString *const YGJEventId = @"YGJEventId";


@interface YGJSQLiteManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) YYCache *cache;
@property (nonatomic, strong) NSString *documentFolder;

/// 登录后的token
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, strong, readwrite) NSMutableArray  *identityArr;
@property (nonatomic, strong, readwrite) NSMutableArray  *requestIdentityArr;
@property (nonatomic, copy, readwrite) NSString *cityName;
@property (nonatomic, strong, readwrite) UserModel *model;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation YGJSQLiteManager

+ (instancetype)manager {
	static YGJSQLiteManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
	});
	return manager;
}
#pragma mark - Intial Methods
- (instancetype)init {
	self = [super init];
	if (self) {

		[self setupUserInformation];
        self.makeOrientation = UIInterfaceOrientationMaskPortrait;
	}
	return self;
}
- (void)setupUserInformation {

	self.token = (NSString *)[self.cache objectForKey:YGJLoginToken];
}

#pragma mark - Public Methods
/// 是否登录
- (BOOL)isLogin {

	return self.token.length > 0;
}

/// 更新用户信息
- (void)updateLoginToken:(NSString *)token {
	self.token = token;
	[self.cache setObject:token forKey:YGJLoginToken];
}

/// 清除用户信息
- (void)clearLoginToken {
	self.token = @"";
	[self.cache removeObjectForKey:YGJLoginToken];
}

///
- (void)updateLoginIdentity:(NSMutableArray *)identityArr {
    self.identityArr = identityArr;
    [self.cache setObject:identityArr forKey:YGJLoginIdentity];
}
///
- (void)clearLoginIdentity {
    
    [self.identityArr removeAllObjects];
    [self.cache removeObjectForKey:YGJLoginIdentity];
}

/// 更新后台返回的用户身份
- (void)updateLoginRequestIdentity:(NSMutableArray *)requestIdentityArr {
    
    self.requestIdentityArr = requestIdentityArr;
    [self.cache setObject:requestIdentityArr forKey:YGJLoginRequestIdentity];
}

/// 清除后台返回的用户身份
- (void)clearLoginRequestIdentity {
    
    [self.requestIdentityArr removeAllObjects];
    [self.cache removeObjectForKey:YGJLoginRequestIdentity];
}

/// 更新我的待办第一条数据的eventId YGJEventId
- (void)updateEventId:(NSInteger)eventId {
    [self.cache setObject:[NSString stringWithFormat:@"%ld",eventId] forKey:YGJEventId];
}

/// 清除我的待办第一条数据的eventId
- (void)clearEventId {
    [self.cache removeObjectForKey:YGJEventId];
}

/// 获取我的待办第一条数据的eventId
- (NSString *)getEventId {
    return (NSString *)[self.cache objectForKey:YGJEventId];
}

/// 是否需要去认证
- (BOOL)isShouldToAuthentication {
    
    // 后台返回没有数据去认证
//    UserModel *model = (UserModel *)[self.cache objectForKey:YGJUserModel];
//    NSString *string = [NSString stringWithFormat:@"%ld",model.userType];
//    if ([NSString isBlankString:string]) return YES;
    //本地缓存有数据去认证
//    NSMutableArray *cacheArr = (NSMutableArray *)[self.cache objectForKey:YGJLoginIdentity];
//    if (cacheArr.count > 0) return YES;
    UserModel *model = (UserModel *)[self.cache objectForKey:YGJUserModel];
    if (model.serCert == 0 && model.idcardCert == 0) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *)getUserIdentity {
    return (NSMutableArray *)[self.cache objectForKey:YGJLoginIdentity];
}
///
- (void)updateUserInfoModel:(UserModel *)model {
    self.model = model;
    [self.cache setObject:model forKey:YGJUserModel];
}
///
- (void)clearUserInfoModel {
    [self.cache removeObjectForKey:YGJUserModel];
}
///
- (UserModel *)getUserInfoModel {
    return (UserModel *)[self.cache objectForKey:YGJUserModel];
}
/// 开始定位
- (void)startUpdatingLocation {
    self.cityName = @"上海市";
	// 推断定位操作是否被同意
	if(![CLLocationManager locationServicesEnabled]) {
		// 提示用户无法进行定位操作
		UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
					       }];
		UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		                                    //跳入当前App设置界面
		                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
					    }];
		[alertVC addAction:cancelAction];
		[alertVC addAction:setAction];
		[kRootViewController presentViewController:alertVC animated:true completion:nil];
		return;
	}
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	// 開始定位
	[self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - Private Method

#pragma mark - External Delegate
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	CLLocation *currentLocation = [locations lastObject];
	// 获取当前所在的城市名
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	//依据经纬度反向地理编译出地址信息
	[geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {

	         if (array.count > 0) {
			 CLPlacemark *placemark = [array objectAtIndex:0];
			 YDZYLog(@"%@",placemark.name);
			 //获取城市
			 NSString *city = placemark.locality;
			 if (!city) {
				 //四大直辖市的城市信息无法通过locality获得，仅仅能通过获取省份的方法来获得（假设city为空，则可知为直辖市）
				 city = placemark.administrativeArea;
			 }
			 self.cityName = city;
		 } else if (error == nil && [array count] == 0) {
			 YDZYLog(@"No results were returned.");
		 } else if (error != nil) {
			 YDZYLog(@"An error occurred = %@", error);
		 }
	 }];
	//系统会一直更新数据。直到选择停止更新。由于我们仅仅须要获得一次经纬度就可以，所以获取之后就停止更新
	[manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (error.code == kCLErrorDenied) {
		// 提示用户出错原因。可按住Option键点击 KCLErrorDenied的查看很多其它出错信息，可打印error.code值查找原因所在
	}
}
// MARK:懒加载
- (YYCache *)cache {
	if (!_cache) {
		self.documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
		NSString *path = [self.documentFolder stringByAppendingPathComponent:YGJSQLiteName];
		_cache = [[YYCache alloc] initWithPath:path];
		_cache.diskCache.ageLimit = MAXFLOAT;
		_cache.diskCache.autoTrimInterval = MAXFLOAT;
	}
	return _cache;
}

- (NSMutableArray *)identityArr {
    
    if (!_identityArr) {
        _identityArr = [NSMutableArray array];
    }
    return _identityArr;
}

- (NSMutableArray *)requestIdentityArr {
    
    if (!_requestIdentityArr) {
        _requestIdentityArr = [NSMutableArray array];
    }
    return _requestIdentityArr;
}


@end
