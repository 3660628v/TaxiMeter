//
//  CitySelectionViewController.m
//  TaxiMeter
//
//  Created by Duc Hieu Pham on 6/25/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "CitySelectionViewController.h"

@interface CitySelectionViewController ()

@end

@implementation CitySelectionViewController
@synthesize cityList, cityURL, cityListArray, urlToSend;

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
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityName" ofType:@"plist"];
    cityListArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
    path = [[NSBundle mainBundle]pathForResource:@"cityURLList" ofType:@"plist"];
    cityURL = [[NSDictionary alloc]initWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [cityListArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *name = [cityListArray objectAtIndex:row];
    return name;
}

- (IBAction)selectCity:(id)sender {
    
    NSLog(@"%@", urlToSend);
     
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToWebView"]) {
        int rowSelected = [cityList selectedRowInComponent:0];
        NSString *cityNameSelected = [cityListArray objectAtIndex:rowSelected];
        NSString *url = [cityURL objectForKey:cityNameSelected];
        urlToSend = url;
        WebViewController *wvc = (WebViewController *)segue.destinationViewController;
        [wvc setUrl:urlToSend];
    }
}

@end
