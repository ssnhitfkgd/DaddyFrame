//
//  UIButton+Addition.m
//  BaseTrunk
//
//  Created by yong on 1/9/12.
//  Copyright (c) 2012 yong. All rights reserved.
//


#import "UIButton+Addition.h"


@implementation UIButton_Vertical

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = (self.frame.size.height-[self titleLabel].height)/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    [self titleLabel].bottom = self.height-1;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end

//居左
@implementation UIButton_LeftBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Left image
    self.imageView.left = 0;
    [self.imageView setTop:0];
    [self.imageView setContentMode:UIViewContentModeCenter];
}


@end

//居左
@implementation UIButton_Left

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Left image
    self.imageView.left = 0;
    
    // Left text
    self.titleLabel.left = self.imageView.right+10.f;
//    self.titleLabel.centerY = self.imageView.centerY;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
}


@end

//居左
@implementation UIButton_LeftImage
- (id)initWithFrame:(CGRect)frame outgoing:(BOOL)outgoing
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.left = !outgoing;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Left image
    
    if(self.left)
    {
        self.imageView.left = 10.;
        self.titleLabel.right = self.width - 10;
        self.titleLabel.top = (self.height - self.titleLabel.height)/2+1;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        self.titleLabel.left = 10.;
        self.imageView.right = self.width - 10;
        self.titleLabel.top = (self.height - self.titleLabel.height)/2+1;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
}


@end
//居左
@implementation UIButton_Avatar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Left image
    self.imageView.left  = 0.;
    self.imageView.top  = 0.;
    self.imageView.width  = self.width;
    self.imageView.height  = self.height;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.width / 2.0;
    // Left text
    self.titleLabel.hidden = YES;
}


@end

@implementation UIButton_Web

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.width = 19.;
    self.imageView.height = 19.;
    
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.centerX = self.width/2.;
    self.imageView.centerY = self.height/2;
    
    
}

@end


@implementation UIButton_Bottom

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(0, 0, self.width, self.imageView.width)];
    [self.titleLabel setFrame:CGRectMake(0, self.imageView.bottom + 8, self.width, self.height - self.imageView.height)];
}

@end