//
//  SKViewSelector.m
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SKViewSelector.h"

@interface SKViewSelector ()

- (BOOL)testClassOfView:(UIView*)view selector:(STSelector*)selector;
- (BOOL)testAttributesOfView:(UIView*)view attributeSelector:(STAttributeSelector*)attr;

- (BOOL)testAttributesOfView:(UIView *)view attributeSelector:(STAttributeSelector*)attr;

@end

@implementation SKViewSelector {
	NSMutableArray* views_;
}

@synthesize views = views_;

+ (NSArray *)selectViewsWithSelector:(STSelector *)selector fromView:(UIView *)view {
	SKViewSelector* vs = [[SKViewSelector alloc] init];
	
	[vs testView:view withSelector:selector];
	
	return vs.views;
}

- (id)init {
	self = [super init];
	
	views_ = [NSMutableArray new];
	
	return self;
}

- (void)testView:(UIView *)view withSelector:(STSelector *)selector {
	[self testViewPath:view withSelector:selector];
	
	for (UIView* subview in view.subviews) {
		[self testView:subview withSelector:selector];
	}
}

- (BOOL)testView:(UIView *)view withComponent:(STSelector *)selector {
	if (selector.identifier) {
		if (![selector.identifier isEqualToString:view.accessibilityIdentifier]) {
			return NO;
		}
	}
	
	if (![self testClassOfView:view selector:selector]) {
		return NO;
	}
	
	for (STAttributeSelector* attr in selector.attributeSelectors) {
		if (![self testAttributesOfView:view attributeSelector:attr]) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)testViewPath:(UIView *)view withSelector:(STSelector *)selector {
	if (![self testView:view withComponent:selector]) {
		return NO;
	}
	
	BOOL result = NO;
	
	if (!selector.parent) {
		result = YES;
	}
	
	UIView* superview = view.superview;
	STSelector* parentSelector = selector.parent;
	
	while (superview) {
		if ([self testViewPath:superview withSelector:parentSelector]) {
			result = YES;
			break;
		}
		superview = superview.superview;
	}

	if (result) {
		if (selector.isCursor) {
			[views_ removeObject:view];
			[views_ addObject:view];
		}
	}
	
	return result;
}

- (BOOL)testClassOfView:(UIView *)view selector:(STSelector *)selector {
	NSString* className = selector.className;
	if ([className isEqualToString:@"*"]) {
		return YES;
	}
	
	if (selector.isExactClassName) {
		return [className isEqualToString:NSStringFromClass([view class])];
	} else {
		return [view isKindOfClass:NSClassFromString(className)];
	}
}

- (BOOL)testAttributesOfView:(UIView *)view attributeSelector:(STAttributeSelector*)attr {
	SEL selector = NSSelectorFromString(attr.attributeName);
	
	if (attr.type == STA_Exist) {
		return [view respondsToSelector:selector];
	}
	
	if (![view respondsToSelector:selector]) {
		return NO;
	}
	
	NSMethodSignature* signature = [view methodSignatureForSelector:selector];
	if (signature.numberOfArguments != 2) return NO;

	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
	@try {
		[invocation setSelector:selector];
		[invocation invokeWithTarget:view];
	}
	@catch (NSException *exception) {
		return NO;
	}
	
	if (strcmp(signature.methodReturnType, @encode(void)) == 0) {
		if (attr.type == STA_Exist && attr.attributeNumber == nil && attr.attributeString == nil) {
			return YES;
		} else {
			return NO;
		}
	}
	
	if (strcmp(signature.methodReturnType, @encode(id)) == 0) {
		__autoreleasing id result;
		[invocation getReturnValue:&result];
		
		if (attr.attributeNumber) {
			NSNumber* number = (NSNumber*)result;
			return [attr.attributeNumber isEqualToNumber:number];
		}
		if (attr.attributeString) {
			NSString* string = [result description];

			switch (attr.type) {
				case STA_Exist: 
					assert(NO);
				case STA_Equal:
					return [string isEqualToString:attr.attributeString];
				case STA_BeginsWith:
					return [string hasPrefix:attr.attributeString];
				case STA_Contains:
					return [string rangeOfString:attr.attributeString].location != NSNotFound;
				case STA_EndsWith:
					return [string hasSuffix:attr.attributeString];
			}
		}
	}
	
	return NO;
}

@end
