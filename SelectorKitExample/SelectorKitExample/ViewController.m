//
//  ViewController.m
//  SelectorKitExample
//
//  Created by 宗太郎 松本 on 12/05/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize selectorTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.selectorTextField.delegate = self;
}

- (void)viewDidUnload
{
	[self setSelectorTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self flashViewsSelected];
	return YES;
}

#pragma mark -

- (void)flashViewsSelected {
	STLexer* lexer = [[STLexer alloc] initWithString:self.selectorTextField.text];
	STParser* parser = [STParser newParserWithLexer:lexer];
	STSelector* selector = [parser parseSelectorWithParent:nil];
	
	NSLog(@"selector = %@", selector);
	
	NSArray* views = [SKViewSelector selectViewsWithSelector:selector fromView:self.view];
	
	for (UIView* view in views) {
		UIView* filter = [[UIView alloc] initWithFrame:view.frame];
		filter.backgroundColor = [UIColor blueColor];
		filter.alpha = 0.6;
		
		[view.superview insertSubview:filter aboveSubview:view];
		
		[UIView animateWithDuration:1 animations:^{
			filter.alpha = 0;
		} completion:^(BOOL c) {
			[filter removeFromSuperview];
		}];
	}
}

#pragma mark - Action

- (IBAction)setSelectorButtonTap:(UIButton *)sender {
	self.selectorTextField.text = sender.titleLabel.text;
	[self flashViewsSelected];
}

@end
