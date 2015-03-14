//
//  ViewController.h
//  InrixPrime
//
//  Created by Anatoly Macarov on 3/12/15.
//  Copyright (c) 2015 Inrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *outputView;

- (IBAction)reset:(id)sender;

@end

