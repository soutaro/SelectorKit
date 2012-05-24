//
//  SelectorKitTests.m
//  SelectorKitTests
//
//  Created by 宗太郎 松本 on 12/05/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectorKitTests.h"
#import "STLexer.h"

@implementation SelectorKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLexer
{
	NSString* source = @"UIButton#close-button[isHidden=false]> :()123not.,*=^=$=true false truely falsey\"hello'world\"'good'";
	
	STLexer* lexer = [[STLexer alloc] initWithString:source];
	
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Ident value:@"UIButton"], @"UIButton", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Hash],@"#", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Ident value:@"close-button"], @"close-button", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_LBracket], @"[", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Ident value:@"isHidden"], @"isHidden", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_EQ], @"=", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_False], @"false",nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_RBracket], @"]", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_GT], @">", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Space], @" ", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Colon], @":", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_LParen], @"(", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Rparen], @")", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Number value:@"123"], @"123", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Not], @"not", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Dot], @".", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Comma], @",", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_StarEQ], @"*=", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_HatEQ], @"^=", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_DollarEQ], @"$=", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_True], @"true", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Space], @" ", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_False], @"false", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Space], @" ", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Ident value:@"truely"], @"truely", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Space], @" ", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_Ident value:@"falsey"], @"falsey", nil);
	
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_String value:@"hello'world"], @"hello'world", nil);
	STAssertEqualObjects([lexer nextToken], [STToken newTokenWithType:STT_String value:@"good"], @"good", nil);
	
	STAssertEquals([lexer eof], YES, nil);
}

@end
