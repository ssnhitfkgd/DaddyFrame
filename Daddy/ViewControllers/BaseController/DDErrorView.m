//
//  DDErrorView.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//


#import "DDErrorView.h"

@implementation DDErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:YES];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 150, 150)];
        [self addSubview:_imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottom + 20, 280, 14 + 2)];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setTextColor:[UIColor colorWithRed:155./255. green:155./255. blue:155./255. alpha:1.0]];
        [_textLabel setNumberOfLines:0];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textLabel];
        
        
    }
    
    return self;
}

- (void)setText:(NSString*)text image:(NSString *)image
{
    
    [self setHidden:NO];
    
    
    if(text)
    {
        [_textLabel setText:text];
    }
    
    if(image)
    {
        [_imageView setHidden:NO];
        [_imageView setImage:[UIImage imageNamed:image]];
        [_imageView setCenterX:self.centerX];
        [_imageView setTop:(self.height - self.imageView.height)/2];
        [_textLabel setTop:_imageView.bottom + 20];
        [_textLabel setCenterX:self.centerX];
    }
    else
    {
        [_imageView setHidden:YES];
        [_textLabel setCenterY:(self.height - _textLabel.height)/2.0];
        [_textLabel setCenterX:self.centerX];
    }
   
}

@end
