//
//  ViewController.m
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <FXBlurView/FXBlurView.h>
#import "PKAlertView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.button addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Show Alert" forState:UIControlStateNormal];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.button];

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert
{
 
    PKAlertView *alertView = [[PKAlertView alloc]  initWithType:PKAlertViewTextField
                                                           title:[[NSMutableAttributedString alloc] initWithString:@"Bonjour"]
                                                     description:[[NSMutableAttributedString alloc] initWithString:@"Comment allez-vous ?"]
                                               cancelButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"Cancel"]
                                               actionButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"OK"]
                                            withCancelCompletion:^{
                                                
                                            } withActionCompletion:^(NSString *textFieldString) {

                                            }];
    
//    [[PKAlertView appearance] setBlurColor:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
//    [[PKAlertView appearance] setTitleAttributes:@{ NSForegroundColorAttributeName: [UIColor redColor] }];
//    
//    
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"login_password_confirm_title", nil)];
//    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,title.length)];
//    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20] range:NSMakeRange(0,title.length)];
//    
//    
//    PKAlertView *alertView = [[PKAlertView alloc]  initWithType:PKAlertViewPlain
//                                                          title:title
//                                                    description:[[NSMutableAttributedString alloc] initWithString:@"Comment allez-vous ?"]
//                                              actionButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"OK"]
//                                            withActionCompletion:^(NSString *textFieldString) {
//                                               
//                                           }];


    [alertView show];

}

@end
