//
//  ServiceProviderViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "ServiceProviderViewController.h"
#import "CompanyDetailViewController.h"

//views
#import "ServiceTableViewCell.h"
#import "ServiceTopTableViewCell.h"

//models
#import "ServiceChildModel.h"
#import "ServiceProviderModel.h"



@interface ServiceProviderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *dataDicArray;
@property (nonatomic, strong) NSMutableArray *sortArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) NSMutableArray *iconArr;
@property (nonatomic, strong) NSArray<ServiceProviderModel *> *dataArray;
@end

@implementation ServiceProviderViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.totalArray.count != 0) {
        [self.totalArray removeAllObjects];
    }
    //serType 商户类型 0:商品商户 1:存储加工户 2:物流商户 3:个体商户
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/getHandlingUsersInfo" parameter:nil requestType:UDARequestTypePost isShowHUD:NO progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:requestModel.result forKey:@"0"];
            [self.dataDicArray addObject:dict];
            for (int i = 1; i < 5; i ++) {
                
                [self serviceProviderRequestByType:i];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)serviceProviderRequestByType:(NSInteger)type {
    
    @weakify(self);
    NSString *typeStr = [NSString stringWithFormat:@"%ld",type-1];
    [UDAAPIRequest requestUrl:@"/app/serviceProvider/list" parameter:@{@"serType":typeStr,@"pageSize":@(200)} requestType:UDARequestTypeGet isShowHUD:NO progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            NSString *keyStr = [NSString stringWithFormat:@"%ld",type];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:requestModel.result forKey:keyStr];
            [self.dataDicArray addObject:dict];
            if (self.dataDicArray.count == 5) {
                
                NSArray *sortedArray = [self.dataDicArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

                    NSUInteger key1 = [[[obj1 allKeys] firstObject] integerValue];
                    NSUInteger key2 = [[[obj2 allKeys] firstObject] integerValue];
                    return (key1 < key2) ? NSOrderedAscending : NSOrderedDescending;
                }];
                NSLog(@"排序---->%ld : %@", [sortedArray count], sortedArray);
                NSMutableArray *tempMutaArray = [NSMutableArray array];
                for (int i = 0; i < sortedArray.count; i ++) {
                    [tempMutaArray addObject:[ServiceProviderModel modelWithDictionary:sortedArray[i][@(i).stringValue]]];
                }
                self.dataArray = tempMutaArray;
                [self.allTableView reloadData];
                for (int i = 1; i < 5; i ++) {
                    
                    YDZYLog(@"----排序后的数组-----> %@",self.dataArray[i].serviceProviderVoList);
                }
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconArr = [NSMutableArray arrayWithObjects:@"fuwu_jingban",@"fuwu_cangchu",@"fuwu_wuliu",@"fuwu_geti",@"fuwu_shangpin", nil];
    self.titleArray = [NSMutableArray arrayWithObjects:@"我的经办",@"仓储加工商户",@"物流商户",@"个体商户",@"商品商户", nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self.view addSubview:self.allTableView];
}
#pragma mark - tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray[section].isExpand) {
        if (section == 0) {
            return 1;
        }
        return [self.dataArray[section].serviceProviderVoList count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(12.5f, 54, kScreenWidth-25, 1)];
    underLineView.backgroundColor = UNDERLINECOLOR;
    [headView addSubview:underLineView];
    UIControl *backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    UIImageView *turnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 22, 21, 6, 14)];
    turnImageView.image = [[UIImage imageNamed:@"xiayiji"] imageWithRenderingMode:1];
    [backView addSubview:turnImageView];
    backView.tag = 1000 + section;
    headView.backgroundColor = [UIColor clearColor];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5f, 16, 23, 23)];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    leftImageView.image = [UIImage imageNamed:self.iconArr[section]];
    leftImageView.userInteractionEnabled = YES;
    [backView addSubview:leftImageView];
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right+11, 0, 150, 55)];
    [backView addSubview:titlelabel];
    titlelabel.font = SYSTEMFONT(15);
    titlelabel.textColor = CBlackgColor;
    titlelabel.text = [NSString stringWithFormat:@"%@",self.titleArray[section]];
    UILabel *hezuolabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 21, 50, 13)];
    hezuolabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:hezuolabel];
    if (section == 0) {
        hezuolabel.hidden = YES;
    }else{
        hezuolabel.hidden = NO;
        hezuolabel.font = SYSTEMFONT(14);
        hezuolabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
//        hezuolabel.text = [NSString stringWithFormat:@"%@/%@",self.dataArray[section].yiHeZuoStr,self.dataArray[section].totalHeZuoStr];
    }
    if (self.dataArray[section].isExpand) {
        turnImageView.frame = CGRectMake(kScreenWidth - 28, 25, 14, 6);
        turnImageView.image = [[UIImage imageNamed:@"xiayiji_down"] imageWithRenderingMode:1];
    }else{
        turnImageView.frame = CGRectMake(kScreenWidth - 22, 21, 6, 14);
        turnImageView.image = [[UIImage imageNamed:@"xiayiji"] imageWithRenderingMode:1];
    }
    [headView addSubview:backView];
    [backView addTarget:self action:@selector(didClickedSection:) forControlEvents:(UIControlEventTouchUpInside)];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        ServiceTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ServiceTopTableViewCell className]];
        if (!cell) {
            
            cell = [[ServiceTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ServiceTopTableViewCell className]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ServiceProviderModel *model = self.dataArray[0];
        cell.companyTitleLabel.text = model.realName;
//        [cell.leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.serLogo]];
        return cell;

    }else {
        
        ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ServiceTableViewCell className]];
        if (!cell) {
            
            cell = [[ServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ServiceTableViewCell className]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ServiceChildModel *model = self.dataArray[indexPath.section].serviceProviderVoList[indexPath.row];
        cell.companyTitleLabel.text = model.serName;
        [cell.leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.serLogo] placeholderImage:[UIImage imageNamed:@"man"]];
        if (indexPath.section==1) {
            cell.firStatusLabel.text = @"仓储";
            cell.secStatusLabel.text = @"加工";
            cell.secStatusLabel.hidden = NO;
        } else if(indexPath.section == 2) {
            cell.firStatusLabel.text = @"物流";
            cell.secStatusLabel.hidden = YES;
        } else if(indexPath.section == 3) {
            cell.secStatusLabel.hidden = YES;
            cell.firStatusLabel.text = @"个体";
        } else if(indexPath.section == 4) {
            cell.secStatusLabel.hidden = YES;
            cell.firStatusLabel.text = @"商品";
        }
        if ([model.coopStatus isEqualToString:@"1"]) {
            cell.isHeZuoLabel.hidden = NO;
        } else {
            cell.isHeZuoLabel.hidden = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        ServiceChildModel *model = self.dataArray[indexPath.section].serviceProviderVoList[indexPath.row];
        CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] init];
        vc.companyName = model.serName;
        vc.serID = model.serID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didClickedSection:(UIControl *)view {
    NSInteger i = view.tag - 1000;
    self.dataArray[i].isExpand = !self.dataArray[i].isExpand;
    NSIndexSet *index = [NSIndexSet indexSetWithIndex:i];
    [_allTableView reloadSections:index withRowAnimation:(UITableViewRowAnimationAutomatic)];
    /** 如果需要收起上一个分区 就用下面的代码 */
    //    [self.dataArray enumerateObjectsUsingBlock:^(AddFeedbackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if ([obj.title isEqualToString:self.dataArray[i].title]) {
    //            obj.isExpand = !obj.isExpand;
    //        }
    //        else{
    //            obj.isExpand = NO;
    //        }
    //    }];
        //刷新列表
    //    [_tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableView *)allTableView {
    if (!_allTableView) {
        _allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
        _allTableView.delegate = self;
        _allTableView.dataSource = self;
        _allTableView.backgroundColor = [UIColor clearColor];
        _allTableView.showsVerticalScrollIndicator = YES;
        if (@available(iOS 11.0, *)) {
            _allTableView.estimatedRowHeight = 0;
            _allTableView.estimatedSectionFooterHeight = 0;
            _allTableView.estimatedSectionHeaderHeight = 0;
        }
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _allTableView;
}

- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
- (NSMutableArray *)dataDicArray {
    if (!_dataDicArray) {
        _dataDicArray = [NSMutableArray array];
    }
    return _dataDicArray;
}
- (NSMutableArray *)sortArray {
    
    if (!_sortArray) {
        _sortArray = [NSMutableArray array];
    }
    return _sortArray;
}

@end
