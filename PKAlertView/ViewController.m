//
//  ViewController.m
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "PKAlertView.h"
#import <FXBlurView/FXBlurView.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.titleLabel.text = @"click";
    [self.button addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Show Alert" forState:UIControlStateNormal];
    
    self.button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    
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
    NSLog(@"= %@",self.view);

//    FXBlurView *testBlurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 500, 200)];
//    [self.view addSubview:testBlurView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert
{
    PKAlertView *alertView = [[PKAlertView alloc] initWithTitle:[[NSMutableAttributedString alloc] initWithString:@"Title"]
                                                    description:[[NSMutableAttributedString alloc] initWithString:@"Super description"]
                                              cancelButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"cancel"]
                                              actionButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"OK"]
                                           withCancelCompletion:^{
        
                                        } withActionCompletion:^{
                                            
                                        }];
    
//    alertView.tintColor = [UIColor blackColor];
//    alertView.backgroundBlurColorView.backgroundColor = [UIColor blackColor];
//    alertView.backgroundBlurColorView.alpha = 0.8;
//    alertView.descriptionLabel.text = @"werokerp okwepro kwepork wepokr pek wepork wepor kwpoekr pwoekr powekr powekr powekr pwoekr powekr powekr powekr poewkrp owekrp okwerpo kwerpok wepork wpeokr pwoekr pweokr pweokr pweokrp wkerpok wepork wpeokr powekr powekr wokr pwoekr pwoekrp owkeeopwkr ";
    [alertView show];
    NSLog(@"test");
    NSLog(@"%@",alertView);
}

@end
