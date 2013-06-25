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
@synthesize addressTo, responseData, latitude, longitude, getCoord, getDistance, manager, myCurrentLocation, distance, addressFrom, getCurrentCoord, fromLatt, fromLngg;
@synthesize getCoordWithManual;
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
    latitude = [[NSNumber alloc]initWithFloat:-1001];
    longitude = [[NSNumber alloc]initWithFloat:-1001];
    fromLatt = [[NSNumber alloc]initWithFloat:-1001];
    fromLngg = [[NSNumber alloc]initWithFloat:-1001];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)calcFare:(id)sender {
    NSString *address = [[NSString alloc]init];
    address = [addressTo text];
    NSString *_addressFrom = [NSString stringWithString:[addressFrom text]];
    if ([address length] == 0) {
        [self showAlertWithString:@"Where are you going?"];
        return;
    }
    if ([_addressFrom length] == 0) {
        NSString *url = [[self class] generateURLGeoLocationWithAddress:address];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        getCoord = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
    else{
        NSString *url = [[self class]generateURLGeoLocationWithAddress:_addressFrom];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        getCurrentCoord = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
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
        NSLog(@"**************getCoord");
        Coord2D res = [[self class]getCoordJSONParserWithData:self.responseData error:myError];
        if (res.lattitude == -1000) {
            return;
        }
        self.latitude = [NSNumber numberWithFloat:res.lattitude];
        self.longitude = [NSNumber numberWithFloat:res.longitude];
        NSLog(@"%@, %@", self.latitude, self.longitude);
        [self checkDistanceWithManualfromAddress:NO];
    }
    
    else if (connection == getDistance) {
        NSLog(@"**************getDistance");
        NSString *distance1 = [[self class]getDistanceInKmWithData:self.responseData error:myError];
        if (distance1 ==  nil) {
            return;
        }
        self.distance = [[self class]getDistanceinMeterWithData:self.responseData error:myError];
        NSLog(@"%@ %i", distance1, self.distance);
        int fare = [self calFarewithDistance:self.distance];

        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Fare" message:[NSString stringWithFormat:@"You are expected to pay about %d VND", fare] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlert show];

    }
    else if (connection == getCurrentCoord){
        NSLog(@"**************getCurrentCoord");

        Coord2D res = [[self class]getCoordJSONParserWithData:self.responseData error:myError];
        if (res.lattitude == -1000) {
            fromLatt = [NSNumber numberWithFloat:-1000];
            fromLngg = [NSNumber numberWithFloat:-1000];
            return;
        }
        self.fromLatt = [NSNumber numberWithFloat:res.lattitude];
        self.fromLngg = [NSNumber numberWithFloat:res.longitude];
        //NSLog(@"%@, %@", self.latitude, self.longitude);
        NSString * url = [[self class] generateURLGeoLocationWithAddress:[addressTo text]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        getCoordWithManual = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
    else if (connection == getCoordWithManual){
        NSLog(@"**************getCoordWithManual");

        Coord2D res = [[self class]getCoordJSONParserWithData:self.responseData error:myError];
        if (res.lattitude == -1000) {
            return;
        }
        self.latitude = [NSNumber numberWithFloat:res.lattitude];
        self.longitude = [NSNumber numberWithFloat:res.longitude];
        NSLog(@"%@, %@", self.latitude, self.longitude);
        [self checkDistanceWithManualfromAddress:YES];

    }
}

-(void)checkDistanceWithManualfromAddress:(BOOL)manual{
    if (!manual) {
        NSString *url;
        url = [[self class]generateURLDistanceEnquiryFromLat:myCurrentLocation.coordinate.latitude fromLng:myCurrentLocation.coordinate.longitude toLat:self.latitude.floatValue toLng:self.longitude.floatValue];
        //Create a HTTP request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //send the request
        getDistance = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
    else{
        NSString *url;
        url = [[self class]generateURLDistanceEnquiryFromLat:fromLatt.floatValue fromLng:fromLngg.floatValue toLat:self.latitude.floatValue toLng:self.longitude.floatValue];
        //Create a HTTP request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //send the request
        getDistance = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    myCurrentLocation = [locations lastObject];
}

+(NSString *)generateURLGeoLocationWithAddress:(NSString *)address{
    NSString *encodedAddress = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) address,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", encodedAddress];
    NSLog(@"%@", url);
    return url;
}

+(NSString *)generateURLDistanceEnquiryFromLat:(float)fromLat fromLng:(float)fromLng toLat:(float)toLat toLng:(float)toLng{
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&sensor=true",fromLat, fromLng, toLat, toLng];
    NSLog(@"%@", url);

    return url;
}

+(Coord2D)getCoordJSONParserWithData:(NSData *)data error:(NSError *)error{
    Coord2D ret;
    NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *status = [temp objectForKey:@"status"];
    if ([status isEqualToString:@"ZERO_RESULTS"]) {
        ret.lattitude = -1000;
        ret.longitude = -1000;
        return ret;
    }
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
    NSString *status = [tempDic objectForKey:@"status"];
    if ([status isEqualToString:@"OK"]) {
        NSArray *tempArray = [tempDic objectForKey:@"rows"];
        tempDic = tempArray[0];
        tempArray = [tempDic objectForKey:@"elements"];
        tempDic = tempArray[0];
        tempDic = [tempDic objectForKey:@"distance"];
        NSString * distance = [tempDic objectForKey:@"text"];
        return distance;
    }
    else{
        return nil;
    }
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

-(void)showAlertWithString:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(int)calFarewithDistance:(int)_distance{
    float ret1 = 0;
    float ret2 = 0;
    float ret3 = 0;
    if(_distance < 1000){
        ret1 = 12000;
    }
    else{
        if(_distance < 30000){
            ret1 = 12000.0;
            ret2 = (((float)_distance - 1000.0)/1000.0) * 17000.0;
        }
        else{
            ret1 = 12000;
            ret2 = 17000 * 29;
            ret3 = (((float)_distance - 30000.0)/1000.0) * 14000.0;
        }
    }
    return (int)(ret1 + ret2 + ret3);
}

@end
