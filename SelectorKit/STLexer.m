//
//  STLexer.m
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STLexer.h"

#define TestLiteral(literal, type) if ([self startsWithLiteral:literal]) return [STToken newTokenWithType:type]

@implementation STToken

@synthesize type;
@synthesize value;

+ (STToken *)newTokenWithType:(STTokenType)type {
	return [self newTokenWithType:type value:nil];
}

+ (STToken *)newTokenWithType:(STTokenType)type value:(NSString *)value {
	STToken* token = [[STToken alloc] init];
	token.type = type;
	token.value = value;
	return token;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
		
	STToken* tok = (STToken*)object;
	return tok.type == self.type && (tok.value == self.value || [tok.value isEqual:self.value]);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<STToken type=%d, value=%@>", self.type, self.value];
}

@end

@interface STLexer ()

- (BOOL)startsWithRegex:(NSString*)regex;
- (BOOL)startsWithLiteral:(NSString*)literal;

- (void)skipSpaces;

@end

@implementation STLexer {
	NSMutableString* string_;
	NSString* matchToken_;
	
	NSMutableDictionary* literalMap_;
}

- (id)initWithString:(NSString *)string {
	self = [self init];
	
	string_ = [string mutableCopy];
	
	[literalMap_ setValue:[NSNumber numberWithInt:STT_Hash] forKey:@"#"];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LBracket] forKey:@"["];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_RBracket] forKey:@"]"];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_VBar] forKey:@"|"];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LParen] forKey:@"("];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_Rparen] forKey:@")"];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LBracket] forKey:@"["];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LBracket] forKey:@"["];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LBracket] forKey:@"["];
	[literalMap_ setValue:[NSNumber numberWithInt:STT_LBracket] forKey:@"["];
	
	return self;
}

- (STToken *)nextToken {
	[self skipSpaces];
	
	if (self.eof) {
		return nil;
	}
	
	if ([self startsWithRegex:@"[A-Za-z][A-Za-z0-9-_]*"]) {
		if ([matchToken_ isEqualToString:@"true"]) {
			return [STToken newTokenWithType:STT_True];
		}
		if ([matchToken_ isEqualToString:@"false"]) {
			return [STToken newTokenWithType:STT_False];
		}
		if ([matchToken_ isEqualToString:@"not"]) {
			return [STToken newTokenWithType:STT_Not];
		}
		return [STToken newTokenWithType:STT_Ident value:matchToken_];
	}
	
	if ([self startsWithRegex:@"\"[^\"]*\""]) {
		return [STToken newTokenWithType:STT_String value:[matchToken_ stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
	}
	
	if ([self startsWithRegex:@"\'[^\']*\'"]) {
		return [STToken newTokenWithType:STT_String value:[matchToken_ stringByReplacingOccurrencesOfString:@"'" withString:@""]];
	}
	
	if ([self startsWithRegex:@"[0-9]+"]) {
		return [STToken newTokenWithType:STT_Number	value:matchToken_];
	}
	
	TestLiteral(@"#", STT_Hash);
	TestLiteral(@"[", STT_LBracket);
	TestLiteral(@"]", STT_RBracket);
	TestLiteral(@"^=", STT_HatEQ);
	TestLiteral(@"*=", STT_StarEQ);
	TestLiteral(@"$=", STT_DollarEQ);
	TestLiteral(@"=", STT_EQ);
	TestLiteral(@"*", STT_Star);
	TestLiteral(@".", STT_Dot);
	TestLiteral(@",", STT_Comma);
	TestLiteral(@":", STT_Colon);
	TestLiteral(@"+", STT_Plus);
	TestLiteral(@"~", STT_Tilda);
	TestLiteral(@"(", STT_LParen);
	TestLiteral(@")", STT_Rparen);
	TestLiteral(@">", STT_GT);
	TestLiteral(@"|", STT_VBar);
	
	return nil;
}

- (BOOL)eof {
	return [string_ length] == 0;
}

- (void)skipSpaces {
	if (self.eof) return;
	
	NSRange range = [string_ rangeOfString:@" +" options:NSRegularExpressionSearch | NSAnchoredSearch];
	if (range.location == NSNotFound) return;

	[string_ replaceCharactersInRange:range withString:@""];
}

- (BOOL)startsWithRegex:(NSString *)regex {
	matchToken_ = nil;
	
	NSRange range = [string_ rangeOfString:regex options:NSRegularExpressionSearch | NSAnchoredSearch];
	if (range.location == NSNotFound) {
		return NO;
	}
	
	matchToken_ = [string_ substringWithRange:range];
	[string_ deleteCharactersInRange:range];
	
	return YES;
}

- (BOOL)startsWithLiteral:(NSString *)literal {
	matchToken_ = nil;
	
	if (![string_ hasPrefix:literal]) {
		return NO;
	}
	
	matchToken_ = literal;
	[string_ deleteCharactersInRange:NSMakeRange(0, [literal length])];
	
	return YES;
}

@end
