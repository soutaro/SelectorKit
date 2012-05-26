//
//  STLexer.h
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	/** Identifier **/
	STT_Ident,
	/** | **/
	STT_VBar,
	/** [ **/
	STT_LBracket,
	/** ] **/
	STT_RBracket,
	/** "abc" or 'abc' **/
	STT_String,
	/** = **/
	STT_EQ,
	/** ^= **/
	STT_HatEQ,
	/** $= **/
	STT_DollarEQ,
	/** *= **/
	STT_StarEQ,
	/** # **/
	STT_Hash,
	/** * **/
	STT_Star,
	/** . **/
	STT_Dot,
	/** , **/
	STT_Comma,
	/** ~ **/
	STT_Tilda,
	/** + **/
	STT_Plus,
	/** ( **/
	STT_LParen,
	/** ) **/
	STT_Rparen,
	/** 123 **/
	STT_Number,
	/** : **/
	STT_Colon,
	/** not **/
	STT_Not,
	/** true **/
	STT_True,
	/** false **/
	STT_False,
	/** > **/
	STT_GT,
	/** nil **/
	STT_Nil,
	/** <: **/
	STT_LtColon,
} STTokenType;

@interface STToken : NSObject

+ (STToken*)newTokenWithType:(STTokenType)type;
+ (STToken*)newTokenWithType:(STTokenType)type value:(NSString*)value;

@property (nonatomic) STTokenType type;
@property (nonatomic, strong) NSString* value;

@end

@interface STLexer : NSObject

- (id)initWithString:(NSString*)string;

- (STToken*)nextToken;
- (BOOL)eof;

@end
