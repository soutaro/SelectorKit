//
//  SKViewSelector.h
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSelector.h"

@interface SKViewSelector : NSObject

@property (nonatomic, readonly) NSMutableArray* views;

+ (NSArray*)selectViewsWithSelector:(STSelector*)selector fromView:(UIView*)view;

- (void)testView:(UIView*)view withSelector:(STSelector*)selector;

- (BOOL)testView:(UIView*)view withComponent:(STSelector*)selector;
- (BOOL)testViewPath:(UIView*)view withSelector:(STSelector*)selector;

@end
