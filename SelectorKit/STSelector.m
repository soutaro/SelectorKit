//
//  STSelector.m
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STSelector.h"

@implementation STPseudoClass {
	NSString* name_;
	NSArray* params_;
}

@synthesize name=name_;
@synthesize params=params_;

+ (STPseudoClass *)newPseudoClassWithType:(NSString *)name params:(NSArray *)params {
	STPseudoClass* klass = [[STPseudoClass alloc] init];
	
	klass.name = name;
	klass.params = params;
	
	return klass;
}

-(BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	STPseudoClass* klass = (STPseudoClass*)object;
	
	if (![klass.name isEqual:self.name]) return NO;
	
	if (klass.params == nil && self.params == nil) return YES;
	return [klass.params isEqual:self.params];
}

- (NSString *)description {
	if (self.params.count > 0) {
		return [NSString stringWithFormat:@"%@(%@)",
				self.name,
				[self.params componentsJoinedByString:@", "]];
	} else {
		return self.name;
	}
}

@end

@implementation STAttributeSelector

@synthesize type;
@synthesize attributeName;
@synthesize attributeString;
@synthesize attributeNumber;

+ (STAttributeSelector *)newExistAttributeSelectorWithName:(NSString *)name {
	return [self newAttributeSelectorWithType:STA_Exist name:name number:nil];
}

+ (STAttributeSelector *)newAttributeSelectorWithType:(STAttributeType)type name:(NSString *)name string:(NSString *)value {
	STAttributeSelector* sel = [[STAttributeSelector alloc] init];
	
	sel.type = type;
	sel.attributeName = name;
	sel.attributeString = value;
	
	return sel;
}

+ (STAttributeSelector *)newAttributeSelectorWithType:(STAttributeType)type name:(NSString *)name number:(NSNumber *)value {
	STAttributeSelector* sel = [[STAttributeSelector alloc] init];
	
	sel.type = type;
	sel.attributeName = name;
	sel.attributeNumber = value;
	
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
	result &= (a.attributeNumber == nil && self.attributeNumber == nil) || [a.attributeNumber isEqualToNumber:self.attributeNumber];
	result &= (a.attributeString == nil && self.attributeString == nil) || [a.attributeString isEqualToString:self.attributeString];
	
	return result;
}

- (NSString *)description {
	if (self.type == STA_Exist) {
		return self.attributeName;
	}
	
	if (self.attributeNumber == nil && self.attributeString == nil) {
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
	
	NSObject* value = self.attributeNumber ? self.attributeNumber : self.attributeString;
	return [NSString stringWithFormat:@"%@%@%@", self.attributeName, op, value];
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
	
	if (self.isExactClassName) {
		[result appendString:@"<:"];
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
