//
//  ViewController.m
//  FTSchedulePicker
//
//  Created by Fabio Takahara on 03/03/16.
//  Copyright © 2016 Fabio Takahara. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *pickerObjectsArray = @[].mutableCopy;
    
    for (int i = 0; i < 5; i++) {
        
        FTSchedulePickerObject *pickerObject = [[FTSchedulePickerObject alloc]init];
        pickerObject.pickerTime = [NSDate date];
        pickerObject.enable = NO;
        [pickerObjectsArray addObject:pickerObject];
    }
    
    FTSchedulePickerView *schedulePickerView = [[FTSchedulePickerView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 50) andObjects:pickerObjectsArray];
    schedulePickerView.customDelegate = self;
    [self.view addSubview:schedulePickerView];
}

#pragma mark - FTSChedulePickerView Delegate

- (void)getPickerViewArray:(NSMutableArray*)pickerViewArray {
    
    for (FTSchedulePickerObject *pickerObject in pickerViewArray) {
        
        NSLog(@"horário %@", pickerObject.pickerTime);
        NSLog(@"disponível %i", pickerObject.enable);

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
