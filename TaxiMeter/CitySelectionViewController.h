//
//  CitySelectionViewController.h
//  TaxiMeter
//
//  Created by Duc Hieu Pham on 6/25/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface CitySelectionViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)selectCity:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *cityList;
@property (strong, nonatomic) NSDictionary *cityURL;
@property (strong, nonatomic) NSArray *cityListArray;
@property (strong, nonatomic) NSString *urlToSend;
@end
