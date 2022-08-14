//
//  EditSelectImageCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/7.
//


#import "EditSelectImageCollectionViewCell.h"

@implementation EditSelectImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        
        CGFloat itemWidth = kScale_W(60);
        CGFloat itemHeight = itemWidth;
        self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        self.bigImageView.layer.masksToBounds = YES;
        self.bigImageView.layer.cornerRadius = 5;
        self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bigImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bigImageView];
        
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(itemWidth-15, 0, 15, 15);
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_liucheng"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.hidden = YES;
        [self.bigImageView addSubview:self.deleteButton];
    }
    return  self;
}


- (void)deleteButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
