//
//  ViewController.m
//  TWCommonMoudleDemo
//
//  Created by luomeng on 2017/6/28.
//  Copyright © 2017年 XRY. All rights reserved.
//

#import "ViewController.h"
#import "TW_WebPage.h"


@interface ViewController ()

@end

@implementation ViewController
- (IBAction)_test:(id)sender {
    
    [self alertMessageWithSelectable:@"nihao" completion:^{
        
        TW_WebPage *page = [[TW_WebPage alloc] init];
        page.webUrl = @"https://www.baidu.com";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:page];
        [self presentViewController:nav animated:YES completion:nil];
        NSLog(@"hao");
    } cancel:^{
        
         NSLog(@"buhao");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
