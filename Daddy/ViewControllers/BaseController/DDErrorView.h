//
//  DDErrorView.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDErrorView : UIImageView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setText:(NSString*)text image:(NSString *)image;
@end
