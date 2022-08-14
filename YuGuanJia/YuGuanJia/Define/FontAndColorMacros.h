//
//  FontAndColorMacros.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//  Copyright © 2020 test. All rights reserved.
//

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  颜色区

//主题色 导航栏颜色
#define CNavBgColor  [UIColor colorWithHexString:@"#4581EB"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"#FFFFFF"]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
                                \
                                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                 blue:((float)(rgbValue & 0xFF))/255.0 \
                                                alpha:1.0]
//默认页面背景色 #EEEEEE
#define CBlackgColor [UIColor colorWithHexString:@"333333"]
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]
#define UNDERLINECOLOR [UIColor colorWithHexString:@"EEEEEE"]

#define ColorString(string) [UIColor colorWithHexString:string]
#define YDCG_ImageName(imageName) [UIImage imageNamed:(imageName)]


//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor  [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor  [UIColor blueColor]
#define KRedColor   [UIColor redColor]



#pragma mark -  字体区
#define FFont16 [UIFont systemFontOfSize:16.0f]
#define FFont14 [UIFont systemFontOfSize:14.0f]
#define FFont12 [UIFont systemFontOfSize:12.0f]
#define FFont10 [UIFont systemFontOfSize:10.0f]
//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define FONTSIZE(FONTSIZE)    [UIFont fontWithName:@"PingFang SC" size:(FONTSIZE)]
#define FONTSIZEBOLD(FONTSIZE)    [UIFont fontWithName:@"PingFang-SC-Bold" size:(FONTSIZE)]
#endif /* FontAndColorMacros_h */
