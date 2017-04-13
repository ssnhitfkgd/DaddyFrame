//
//  DDTableCellProtocol.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

@protocol DDTableCellProtocol <NSObject>

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@optional
- (void)cellSelected;
@end
