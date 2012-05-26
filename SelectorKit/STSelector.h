//
//  STSelector.h
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSelector;

@interface STPseudoClass : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* params;

+ (STPseudoClass*)newPseudoClassWithType:(NSString*)name params:(NSArray*)params;

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
