//
//  N6HelperUI.h
//  mobip2p
//
//  Created by Guo Yu on 14-10-22.
//  Copyright (c) 2014年 zkbc. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif

UIColor *UIColorFromRGBValue(UInt32 rgbValue);
UIColor *UIColorFromRGBDecValue(unsigned int r, unsigned int g, unsigned int b);
    
NSString * N6GenerateUUID(void);

#ifdef __cplusplus
}
#endif