//
//  ViewController.h
//  SelectorKitExample
//
//  Created by 宗太郎 松本 on 12/05/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *selectorTextField;

- (IBAction)setSelectorButtonTap:(UIButton *)sender;

- (void)flashViewsSelected;

@end
