//
//  ViewController.m
//  SRPickerViewDemo
//
//  Created by ryan on 2019/3/14.
//  Copyright © 2019 ryan. All rights reserved.
//

#import "ViewController.h"
#import "SRPicker/SRPickerView.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 120, 50);
    [btn setTitle:@"点击弹出" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(caondy) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 240, 240, 44)];
    self.label1.font = [UIFont systemFontOfSize:15];
    self.label1.textColor = [UIColor blackColor];
    self.label1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label1];
}


- (void)caondy{
    
    SupportPickerData *data1 = [[SupportPickerData alloc] init];
    data1.name = @"wsc";
    data1.uploadId = @"1";
    
    SupportPickerData *data2 = [[SupportPickerData alloc] init];
    data2.name = @"sr";
    data2.uploadId = @"2";
    
    SupportPickerData *data3 = [[SupportPickerData alloc] init];
    data3.name = @"zwj";
    data3.uploadId = @"3";
    
    SupportPickerData *data4 = [[SupportPickerData alloc] init];
    data4.name = @"ndy";
    data4.uploadId = @"4";
    
    SupportPickerData *data5 = [[SupportPickerData alloc] init];
    data5.name = @"dlrb";
    data5.uploadId = @"5";
    
    SupportPickerData *data6 = [[SupportPickerData alloc] init];
    data6.name = @"hhc";
    data6.uploadId = @"6";
    
    __weak typeof(self) weakSelf = self;
    [SRPickerView showPickerViewInView:self.view withOriString:self.label1.text withDataArray:@[data1,data2,data3,data4,data5,data6] completion:^(NSString *selectString, NSString *selectId) {
        weakSelf.label1.text = selectString;
    }];
}

@end
