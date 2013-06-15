//
//  ViewController.h
//  TaxiMeter
//
//  Created by Hieu on 6/14/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)callPolice:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *taxiPicker;
@property (strong, nonatomic) NSArray *taxiList;
@end
