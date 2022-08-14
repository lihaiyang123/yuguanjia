//
//  UserListCollectionViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserListCollectionViewCellDelegate <NSObject>

@optional

@end

@interface UserListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <UserListCollectionViewCellDelegate>delegate;

- (void)setDataDict:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
