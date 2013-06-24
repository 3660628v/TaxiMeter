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
#import "MapStruct.h"

@interface ManualEntryViewController : UIViewController<CLLocationManagerDelegate>
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
@property (nonatomic) int distance;


//Some helper method
+(NSString *)generateURLGeoLocationWithAddress:(NSString *)address;
+(NSString *)generateURLDistanceEnquiryFromLat:(float)fromLat fromLng:(float)fromLng toLat:(float)toLat toLng:(float)toLng;
-(void)checkDistance;
+(NSString *)getDistanceInKmWithData:(NSData *)data error:(NSError *)error;
+(int)getDistanceinMeterWithData:(NSData *)data error:(NSError *)error;
-(void)showAlertWithString:(NSString *)message;
-(int)calFarewithDistance:(int)distance;
@end
