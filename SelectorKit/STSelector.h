//
//  STSelector.h
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	STC_FirstChild,
	STC_NthChild,
	STC_LastChild,
	STC_NthOfType,
	STC_Not,
} STPseudoClassType;

@class STSelector;

@interface STPseudoClass : NSObject

@property (nonatomic) STPseudoClassType type;

@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) STSelector* selector;

+ (STPseudoClass*)newPseudoClassWithType:(STPseudoClassType)type index:(NSUInteger)index;
+ (STPseudoClass*)newPseudoClassWithType:(STPseudoClassType)type selector:(STSelector*)selector;

@end

typedef enum {
	STA_Exist,
	STA_Equal,
	STA_BeginsWith,
	STA_EndsWith,
	STA_Contains,
} STAttributeType;

@interface STAttributeSelector : NSObject

@property (nonatomic) STAttributeType type;
@property (nonatomic, strong) NSString* attributeName;
@property (nonatomic, strong) NSString* attributeValue;

+ (STAttributeSelector*)newExistAttributeSelectorWithName:(NSString*)name;
+ (STAttributeSelector*)newAttributeSelectorWithType:(STAttributeType)type name:(NSString *)name value:(NSString*)value;

@end

typedef enum {
	STP_Ancestor,
	STP_Parent,
	STP_Next,
	STP_After,
} STParentType;

@interface STSelector : NSObject

@property (nonatomic, strong) STSelector* parent;
@property (nonatomic) STParentType parentType;

@property (nonatomic, strong) NSString* className;
@property (nonatomic) BOOL isExactClassName;

@property (nonatomic, strong) NSString* identifier;

@property (nonatomic, strong) NSArray* pseudoClasses;
@property (nonatomic, strong) NSArray* attributeSelectors;

@end
