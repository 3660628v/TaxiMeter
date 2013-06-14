//
//  MapViewController.m
//  TaxiMeter
//
//  Created by Hieu on 6/14/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize manager, myCurrentLocation,mapView ;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    myCurrentLocation = [locations lastObject];
    mapView.mapType = MKMapTypeSatellite;
    mapView.region = MKCoordinateRegionMake(myCurrentLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f));
	mapView.showsUserLocation = YES;
	mapView.zoomEnabled = YES;
}


@end
