//
//  AboutViewController.m
//  TaxiMeter
//
//  Created by Hieu on 8/25/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize authorPhoto;
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
    NSString * myFile = [[NSBundle mainBundle]pathForResource:@"Hieu" ofType:@"jpg"];
    [authorPhoto setImage:[[UIImage alloc]initWithContentsOfFile:myFile]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
