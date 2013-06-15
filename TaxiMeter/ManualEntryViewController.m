//
//  ManualEntryViewController.m
//  TaxiMeter
//
//  Created by Hieu on 6/14/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "ManualEntryViewController.h"

@interface ManualEntryViewController ()

@end

@implementation ManualEntryViewController
@synthesize addressTo, responseData, latitude, longitude, getCoord, getDistance, manager, myCurrentLocation, distance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    responseData = [[NSMutableData alloc]init];
    manager = [[CLLocationManager alloc]init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.delegate = self;
    manager.distanceFilter = 5.0f;
    [manager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)calcFare:(id)sender {
    NSString *address = [[NSString alloc]init];
    address = [addressTo text];
    NSString *url = [[self class] generateURLGeoLocationWithAddress:address];
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    getCoord = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [addressTo resignFirstResponder];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    // convert to JSON
    NSError *myError = nil;
    if (connection == getCoord) {
        Coord2D res = [[self class]getCoordJSONParserWithData:self.responseData error:myError];
        self.latitude = [NSNumber numberWithFloat:res.lattitude];
        self.longitude = [NSNumber numberWithFloat:res.longitude];
        NSLog(@"%@, %@", self.latitude, self.longitude);
        [self checkDistance];
    }
    
    if (connection == getDistance) {
        NSString *distance1 = [[self class]getDistanceInKmWithData:self.responseData error:myError];
        distance = [[self class]getDistanceinMeterWithData:self.responseData error:myError];
        NSLog(@"%@ %i", distance1, distance);
    }
}

-(void)checkDistance{
    NSString *url = [[self class]generateURLDistanceEnquiryFromLat:myCurrentLocation.coordinate.latitude fromLng:myCurrentLocation.coordinate.longitude toLat:self.latitude.floatValue toLng:self.longitude.floatValue];
    //Create a HTTP request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //send the request
    getDistance = [[NSURLConnection alloc]initWithRequest:request delegate:self];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    myCurrentLocation = [locations lastObject];
}

+(NSString *)generateURLGeoLocationWithAddress:(NSString *)address{
    NSString *encodedAddress = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) address,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", encodedAddress];
    return url;
}

+(NSString *)generateURLDistanceEnquiryFromLat:(float)fromLat fromLng:(float)fromLng toLat:(float)toLat toLng:(float)toLng{
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&sensor=true",fromLat, fromLng, toLat, toLng];
    return url;
}

+(Coord2D)getCoordJSONParserWithData:(NSData *)data error:(NSError *)error{
    Coord2D ret;
    NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *tempArray = [temp objectForKey:@"results"];
    temp = tempArray[0];
    temp = [temp objectForKey:@"geometry"];
    temp = [temp objectForKey:@"location"];
    ret.lattitude = [[temp objectForKey:@"lat"]floatValue];
    ret.longitude = [[temp objectForKey:@"lng"]floatValue];
    return ret;
}

+(NSString *)getDistanceInKmWithData:(NSData *)data error:(NSError *)error{
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *tempArray = [tempDic objectForKey:@"rows"];
    tempDic = tempArray[0];
    tempArray = [tempDic objectForKey:@"elements"];
    tempDic = tempArray[0];
    tempDic = [tempDic objectForKey:@"distance"];
    NSString * distance = [tempDic objectForKey:@"text"];
    return distance;
}

+(int)getDistanceinMeterWithData:(NSData *)data error:(NSError *)error{
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *tempArray = [tempDic objectForKey:@"rows"];
    tempDic = tempArray[0];
    tempArray = [tempDic objectForKey:@"elements"];
    tempDic = tempArray[0];
    tempDic = [tempDic objectForKey:@"distance"];
    int distance = [[tempDic objectForKey:@"value"]intValue];
    return distance;
}

@end
