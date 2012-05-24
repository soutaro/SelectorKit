//
//  STParser.h
//  SelectorKit
//
//  Created by 宗太郎 松本 on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STLexer.h"
#import "STSelector.h"

@interface STParser : NSObject

+ (STParser*)newParserWithLexer:(STLexer*)lexer;

- (STSelector*)parseSelectorWithParent:(STSelector*)parent;

- (STSelector*)parseSelectorComponent;

- (STPseudoClass*)parsePseudoClass;

- (STAttributeSelector*)parseAttributeSelector;
- (NSArray*)parseAttributeSelectors;

@end
