//
//  STSelector.m
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STSelector.h"

@implementation STPseudoClass {
	STPseudoClassType type_;
	NSUInteger index_;
	STSelector* selector_;
}

@synthesize type=type_;
@synthesize index=index_;
@synthesize selector=selector_;

+ (STPseudoClass *)newPseudoClassWithType:(STPseudoClassType)type index:(NSUInteger)index {
	STPseudoClass* klass = [[STPseudoClass alloc] init];
	
	klass.type = type;
	klass.index = index;
	
	return klass;
}

+ (STPseudoClass *)newPseudoClassWithType:(STPseudoClassType)type selector:(STSelector *)selector {
	STPseudoClass* klass = [[STPseudoClass alloc] init];
	
	klass.type = type;
	klass.selector = selector;
	
	return klass;
}

-(BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	STPseudoClass* klass = (STPseudoClass*)object;
	
	if (klass.type != self.type) return NO;
	if (klass.index != self.index) return NO;
	
	if (klass.selector == nil && self.selector == nil) return YES;
	return [klass.selector isEqual:self.selector];
}

- (NSString *)description {
	switch (self.type) {
		case STC_FirstChild:
			return @"first-child";
			break;
		case STC_LastChild:
			return @"last-child";
		case STC_NthChild:
			return [NSString stringWithFormat:@"nth-child(%d)", self.index];
		case STC_NthOfType:
			return [NSString stringWithFormat:@"nth-of-type(%d)", self.index];
		case STC_Not:
			return [NSString stringWithFormat:@"not(%@)", self.selector];
		default:
			break;
	}
	return @"";
}

@end

@implementation STAttributeSelector

@synthesize type;
@synthesize attributeName;
@synthesize attributeValue;

+ (STAttributeSelector *)newExistAttributeSelectorWithName:(NSString *)name {
	return [self newAttributeSelectorWithType:STA_Exist name:name value:nil];
}

+ (STAttributeSelector *)newAttributeSelectorWithType:(STAttributeType)type name:(NSString *)name value:(NSString *)value {
	STAttributeSelector* sel = [[STAttributeSelector alloc] init];
	
	sel.type = type;
	sel.attributeName = name;
	sel.attributeValue = value;
	
	return sel;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	STAttributeSelector* a = (STAttributeSelector*)object;
	
	BOOL result = YES;
	result &= (a.type == self.type);
	result &= (a.attributeName == nil && self.attributeName == nil) || [a.attributeName isEqualToString:self.attributeName];
	result &= (a.attributeValue == nil && self.attributeValue == nil) || [a.attributeValue isEqualToString:self.attributeValue];
	
	return result;
}

- (NSString *)description {
	if (self.type == STA_Exist) {
		return self.attributeName;
	}
	
	NSString* op;
	switch (self.type) {
		case STA_Equal:
			op = @"=";
			break;
		case STA_BeginsWith:
			op = @"^=";
			break;
		case STA_EndsWith:
			op = @"$=";
			break;
		case STA_Contains:
			op = @"*=";
			break;
		default:
			assert(NO);
	}
	
	return [NSString stringWithFormat:@"%@%@%@", self.attributeName, op, self.attributeValue];
}

@end

@implementation STSelector

@synthesize parent;
@synthesize parentType;
@synthesize className;
@synthesize isExactClassName;
@synthesize identifier;
@synthesize pseudoClasses;
@synthesize attributeSelectors;

- (id)init {
	self = [super init];
	
	self.pseudoClasses = [NSArray new];
	self.attributeSelectors = [NSArray new];
	
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	STSelector* selector = (STSelector*)object;
	
	BOOL result = YES;
	
	result &= (self.parent == nil && selector.parent == nil) || [self.parent isEqual:selector.parent];
	result &= [self.className isEqual:selector.className];
	result &= (self.identifier == nil && selector.identifier == nil) || [self.identifier isEqual:selector.identifier];
	result &= self.isExactClassName == selector.isExactClassName;
	result &= self.parentType == selector.parentType;
	result &= [self.pseudoClasses isEqual:selector.pseudoClasses];
	result &= [self.attributeSelectors isEqual:selector.attributeSelectors];
	
	return result;
}

- (NSString *)description {
	NSMutableString* result = [NSMutableString new];
	
	if (self.parent) {
		[result appendFormat:@"%@ ", self.parent];
	}
	
	if (self.parentType == STP_After) {
		[result appendString:@"~ "];
	}
	if (self.parentType == STP_Next) {
		[result appendString:@"+ "];
	}
	if (self.parentType == STP_Parent) {
		[result appendString:@"> "];
	}
	
	[result appendString:self.className];
	
	for (STPseudoClass* pc in self.pseudoClasses) {
		[result appendFormat:@":%@", pc];
	}
	if (self.attributeSelectors.count > 0) {
		[result appendString:@"["];
		for (STAttributeSelector* as in self.attributeSelectors) {
			[result appendFormat:@"%@, ", as];
		}
		[result appendString:@"]"];
	}
	
	if (self.identifier) {
		[result appendFormat:@"#%@", self.identifier];
	}
	
	return result;
}

@end
