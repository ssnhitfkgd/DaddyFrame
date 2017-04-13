//
//  DDNavigationController.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDNavigationController.h"
#import "Colours.h"

@implementation DDNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if(self)
    {
        self.interactivePopGestureRecognizer.delegate = (id)self;

        self.delegate = (id)self;
        [self.navigationBar setTranslucent:NO];
        
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.tintColor = [UIColor whiteColor];
        
        NSDictionary *navibarTextDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],  NSForegroundColorAttributeName,[UIFont systemFontOfSize:12], NSFontAttributeName, nil];
        self.navigationBar.titleTextAttributes = navibarTextDic;
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.interactivePopGestureRecognizer.delegate = (id)self;
            self.delegate = self;
        }
        
        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon_trunslate"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    
        
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return false;
    }
    return true;
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;

    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
    return UIInterfaceOrientationPortrait;
}

@end
