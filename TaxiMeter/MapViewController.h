//
//  MapViewController.h
//  TaxiMeter
//
//  Created by Hieu on 6/14/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *myCurrentLocation;
@end
