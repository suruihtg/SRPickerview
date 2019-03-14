//
//  SRPickerView.h
//  TupianKankan
//
//  Created by ryan on 2019/3/13.
//  Copyright © 2019 HAMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupportPickerData.h"

@interface SRPickerView : UIView

+ (void)showPickerViewInView:(UIView *)showView
               withOriString:(NSString *)oriString
               withDataArray:(NSArray <SupportPickerData *> *)dataArray
                  completion:(void(^)(NSString *selectString, NSString *selectId))completion;


+ (void)dismissPicker;

@end
