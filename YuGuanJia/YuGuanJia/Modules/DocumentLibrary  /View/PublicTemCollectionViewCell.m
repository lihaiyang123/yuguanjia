//
//  PublicTemCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/28.
//

#import "PublicTemCollectionViewCell.h"

// mdoels
#import "YGJDocModel.h"

@implementation PublicTemCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    [self.contentView addSubview:self.temImageView];
    [self.contentView addSubview:self.temNameLabel];
    
    self.temImageView.frame = CGRectMake(0, 0, kScale_W(107.5f), kScale_W(74.5f));
//    self.temImageView.image = [UIImage imageNamed:@"出仓单"];
    self.temNameLabel.frame = CGRectMake(0, _temImageView.bottom+kScale_W(10), kScale_W(107.5f), kScale_W(13.5f));
}
- (void)setupDocItemModel:(YGJDocItemModel *)itemModel {
    
    if (itemModel.tempStatus != 0) {
        self.temNameLabel.text = itemModel.tempName ? itemModel.tempName : @"-";
    } else {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（审核中）",itemModel.tempName]];
        NSRange range1 = [[str string] rangeOfString:@"（审核中）"];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#FF0000") range:range1];
        self.temNameLabel.attributedText = str;
    }
    [self.temImageView sd_setImageWithURL:[NSURL URLWithString:itemModel.previewUrl] placeholderImage:[UIImage imageNamed:@"出仓单"]];
}

- (UIImageView *)temImageView {
    
    if (!_temImageView) {
        _temImageView = [[UIImageView alloc] init];
        _temImageView.contentMode = UIViewContentModeScaleAspectFit;
        _temImageView.layer.masksToBounds = YES;
        _temImageView.layer.cornerRadius = 5;
    }
    return _temImageView;
}

- (UILabel *)temNameLabel {
    
    if (!_temNameLabel) {
        _temNameLabel = [[UILabel alloc] init];
        _temNameLabel.text = @"入仓单";
        _temNameLabel.font = SYSTEMFONT(14);
        _temNameLabel.textAlignment = 1;
        _temNameLabel.textColor = KBlackColor;
    }
    return _temNameLabel;
}
@end
