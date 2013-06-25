//
//  WebViewController.h
//  TaxiMeter
//
//  Created by Duc Hieu Pham on 6/25/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIActivityIndicatorView *animate;
@end
