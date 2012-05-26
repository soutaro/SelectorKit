//
//  STParser.m
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STParser.h"

@interface STParser ()

@property (nonatomic, retain) STToken* nextToken;
@property (nonatomic, retain) STLexer* lexer;

- (void)advanceToken;
- (void)assertTokenTypeAndAdvance:(STTokenType)type;
- (void)assertTokenType:(STTokenType)type;

@end

@implementation STParser

@synthesize lexer;
@synthesize nextToken;

+ (STParser *)newParserWithLexer:(STLexer *)lexer {
	STParser* parser = [[STParser alloc] init];
	
	parser.lexer = lexer;
	[parser advanceToken];
	
	return parser;
}

- (void)advanceToken {
	self.nextToken = [self.lexer nextToken];
}

- (void)assertTokenTypeAndAdvance:(STTokenType)type {
	[self assertTokenType:type];
	[self advanceToken];
}

- (void)assertTokenType:(STTokenType)type {
	if (self.nextToken.type != type) {
		assert(NO);
	}
}

- (STSelector *)parseSelectorWithParent:(STSelector *)parent {
	if (self.lexer.eof) {
		return parent;
	}
	
	if (self.nextToken.type == STT_Rparen) {
		return parent;
	}
	
	STParentType type = STP_Ancestor;
	switch (self.nextToken.type) {
		case STT_GT:
			type = STP_Parent;
			[self advanceToken];
			break;
		case STT_Tilda:
			type = STP_After;
			[self advanceToken];
			break;
		case STT_Plus:
			type = STP_Next;
			[self advanceToken];
			break;
		default:
			break;
	}
	
	STSelector* selector = [self parseSelectorComponent];
	selector.parentType = type;
	selector.parent = parent;
	
	return [self parseSelectorWithParent:selector];
}

- (STSelector *)parseSelectorComponent {
	NSString* className = @"*";
	
	if (self.nextToken.type == STT_Ident) {
		className = self.nextToken.value;
		[self advanceToken];
	} else if (self.nextToken.type == STT_Star) {
		className = @"*";
		[self advanceToken];
	}
	
	NSMutableArray* attributes = [NSMutableArray new];
	NSMutableArray* pseudoClasses = [NSMutableArray new];
	
	while (self.nextToken.type == STT_LBracket || self.nextToken.type == STT_Colon) {
		switch (self.nextToken.type) {
			case STT_LBracket: {
				[self advanceToken];
				NSArray* attrs = [self parseAttributeSelectors];
				[self assertTokenTypeAndAdvance:STT_RBracket];
				[self advanceToken];
				[attributes addObjectsFromArray:attrs];
				break;
			}
			case STT_Colon: {
				[self advanceToken];
				STPseudoClass* klass = [self parsePseudoClass];
				[pseudoClasses addObject:klass];
				break;
			}
			default:
				assert(NO);
		}
	}
	
	NSString* identifier;
	if (self.nextToken.type == STT_Hash) {
		[self advanceToken];
		if (self.nextToken.type == STT_Ident || self.nextToken.type == STT_String) {
			identifier = self.nextToken.value;
			[self advanceToken];
		} else {
			abort();
		}
	}
	
	STSelector* selector = [[STSelector alloc] init];
	selector.className = className;
	selector.attributeSelectors = attributes;
	selector.pseudoClasses = pseudoClasses;
	selector.identifier = identifier;
	
	return selector;
}

- (STPseudoClass *)parsePseudoClass {
	if (self.nextToken.type != STT_Ident) {
		abort();
	}
	
	NSString* name = self.nextToken.value;
	[self advanceToken];
	
	STPseudoClassType type;
	
	if ([name isEqualToString:@"first-child"]) {
		return [STPseudoClass newPseudoClassWithType:STC_FirstChild index:0];
	} else if ([name isEqualToString:@"last-child"]) {
		return [STPseudoClass newPseudoClassWithType:STC_LastChild index:0];
	} else if ([name isEqualToString:@"nth-child"]) {
		type = STC_NthChild;
	} else if ([name isEqualToString:@"nth-of-type"]) {
		type = STC_NthOfType;
	} else if ([name isEqualToString:@"not"]) {
		type = STC_Not;
		[self assertTokenTypeAndAdvance:STT_LParen];
		STSelector* selector = [self parseSelectorWithParent:nil];
		[self assertTokenTypeAndAdvance:STT_Rparen];
		return [STPseudoClass newPseudoClassWithType:STC_Not selector:selector];
	} else {
		assert(NO);
	}
	
	[self assertTokenTypeAndAdvance:STT_LParen];
	[self assertTokenType:STT_Number];
	STPseudoClass* klass = [STPseudoClass newPseudoClassWithType:type index:[self.nextToken.value intValue]];
	[self advanceToken];
	[self assertTokenTypeAndAdvance:STT_Rparen];
	return klass;
}

- (STAttributeSelector *)parseAttributeSelector {
	if (self.nextToken.type != STT_Ident) {
		abort();
	}
	
	NSString* attributeName = self.nextToken.value;
	
	STAttributeType type = STA_Exist;
	
	[self advanceToken];
	
	switch (self.nextToken.type) {
		case STT_EQ:
			type = STA_Equal;
			break;
		case STT_HatEQ:
			type = STA_BeginsWith;
			break;
		case STT_StarEQ:
			type = STA_Contains;
			break;
		case STT_DollarEQ:
			type = STA_EndsWith;
			break;
		default:
			return [STAttributeSelector newExistAttributeSelectorWithName:attributeName];
			break;
	}
	
	[self advanceToken];
	
	if (self.nextToken.type == STT_String || self.nextToken.type == STT_Ident) {
		NSString* value = self.nextToken.value;
		[self advanceToken];
		return [STAttributeSelector newAttributeSelectorWithType:type name:attributeName value:value];
	}
	
	abort();
}

- (NSArray *)parseAttributeSelectors {
	NSMutableArray* result = [NSMutableArray new];
	
	while (self.nextToken.type == STT_Ident) {
		STAttributeSelector* selector = [self parseAttributeSelector];
		[result addObject:selector];
		
		if (self.nextToken.type == STT_Comma) {
			[self advanceToken];
		}
	}
	
	return result;
}

@end
