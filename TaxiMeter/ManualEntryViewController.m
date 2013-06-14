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
@synthesize addressTo, responseData, latitude, longitude, getCoord, getDistance, manager, myCurrentLocation;

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
    // Dispose of any resources that can be recreated.
}

- (IBAction)calcFare:(id)sender {
//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    NSString *address = [[NSString alloc]init];
    address = [addressTo text];
    NSString *encodedAddress = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) address,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
   NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", encodedAddress];
//    NSString *url = @"http://maps.googleapis.com/maps/api/geocode/json?address=Reunification%20Palace&sensor=true";
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    getCoord = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
//    [self checkDistance];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"hahahahahahahaha");

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
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&myError];
        
        // show all values
        NSArray *temp2 = [res objectForKey:@"results"];
        NSDictionary *temp3 = temp2[0];
        NSDictionary *temp4 = [temp3 objectForKey:@"geometry"];
        NSDictionary *temp5 = [temp4 objectForKey:@"location"];
        NSNumber *lat = [temp5 objectForKey:@"lat"];
        NSNumber *lng = [temp5 objectForKey:@"lng"];
        self.latitude = lat;
        self.longitude = lng;
        NSLog(@"%@, %@", lat, lng);
        [self checkDistance];
    }
    
    if (connection == getDistance) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&myError];
//        NSLog(@"%@", res);
        NSArray *temp1 = [res objectForKey:@"rows"];
        NSDictionary *temp2 = temp1[0];
        NSArray *temp3 = [temp2 objectForKey:@"elements"];
        NSDictionary *temp4 = temp3[0];
        NSDictionary *temp5 = [temp4 objectForKey:@"distance"];
        NSString *distance = [temp5 objectForKey:@"text"];
        NSLog(@"%@", distance);
    }
}

-(void)checkDistance{
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%@,%@&sensor=true",myCurrentLocation.coordinate.latitude, myCurrentLocation.coordinate.longitude, self.latitude, self.longitude];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    getDistance = [[NSURLConnection alloc]initWithRequest:request delegate:self];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    myCurrentLocation = [locations lastObject];
}


@end
