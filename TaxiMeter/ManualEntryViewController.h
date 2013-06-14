//
//  ManualEntryViewController.h
//  TaxiMeter
//
//  Created by Hieu on 6/14/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
//#import "JSONKit.h"
@interface ManualEntryViewController : UIViewController
- (IBAction)calcFare:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *addressTo;
@property (strong, nonatomic) NSMutableData * responseData;
+(NSDictionary*) parseJson:(NSString*) jsonString;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSURLConnection *getCoord;
@property (strong, nonatomic) NSURLConnection *getDistance;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *myCurrentLocation;

-(void)checkDistance;
@end
