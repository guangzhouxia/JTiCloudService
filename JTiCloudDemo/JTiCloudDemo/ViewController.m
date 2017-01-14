//
//  ViewController.m
//  JTiCloudDemo
//
//  Created by YS-160408B on 17/1/14.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "ViewController.h"
#import "JTiCloudService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(50.0, 100.0, 100.0, 40.0)];
    saveBtn.backgroundColor = [UIColor orangeColor];
    [saveBtn setTitle:@"save" forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *readBtn = [[UIButton alloc] initWithFrame:CGRectMake(50.0, 300.0, 100.0, 40.0)];
    readBtn.backgroundColor = [UIColor orangeColor];
    [readBtn setTitle:@"read" forState:UIControlStateNormal];
    [self.view addSubview:readBtn];
    [readBtn addTarget:self action:@selector(read) forControlEvents:UIControlEventTouchUpInside];
}

- (void)save {
    JTiCloudService *icloud = [[JTiCloudService alloc] init];
    
    NSString *string = @"save to icloud data";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [icloud save:data completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"state : %d, error:%@",success,error.description);
    }];
}

- (void)read {
    JTiCloudService *icloud = [[JTiCloudService alloc] init];
    
    NSError *error;
    
    NSData *data = [icloud readFromICloudWithError:&error];
    
    if (data == nil) {
        NSLog(@"data:%@ , error:%@",data,error);
        return;
    }
    
    NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"data:%@ , error:%@",dataString,error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
