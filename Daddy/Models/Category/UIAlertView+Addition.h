//
//  UIAlertView+Addition.h
//  BaseTrunk
//
//  Created by wangyong on 15/1/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void (^VoidBlock)();

typedef void (^SDismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface UIAlertView (Block) <UIAlertViewDelegate> 
+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(SDismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled;

@property (nonatomic, copy) SDismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end

