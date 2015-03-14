//
//  ViewController.m
//  InrixPrime
//
//  Created by Anatoly Macarov on 3/12/15.
//  Copyright (c) 2015 Inrix. All rights reserved.
//

#import "ViewController.h"

static dispatch_queue_t _queue = nil;
typedef void (^FinishBlock) (void);

@interface ViewController ()
@property (nonatomic) BOOL isReseted;
@property (nonatomic, strong) FinishBlock finishHandler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _queue = dispatch_queue_create("com.inrix.prime", NULL);
    
    [self printPrimeNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)reset:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    self.isReseted = YES;
    self.finishHandler = ^(){
        weakSelf.isReseted = NO;
        weakSelf.outputView.text = @"Prime numbers:";
        [weakSelf printPrimeNumber];
    };
}

- (void)printPrimeNumber
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        
        long long i = 1;
        NSMutableArray *arrOfPrimes = [NSMutableArray new];
        while (!weakSelf.isReseted) {
            i++;
            BOOL isPrime = YES;
            for (NSNumber *prime in arrOfPrimes)
            {
                if (i % [prime longLongValue] == 0) {
                    isPrime = NO;
                    break;
                }
            }
            if (isPrime) {
                [arrOfPrimes addObject:[NSNumber numberWithLongLong:i]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf outputText:[NSString stringWithFormat:@"%lli", i]];
                });
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(weakSelf.finishHandler)
            {
                weakSelf.finishHandler();
            }
        });
        
    });
    
}

- (void)outputText:(NSString *)txt
{
    self.outputView.text = [NSString stringWithFormat:@"%@ %@,", self.outputView.text, txt];

    NSRange range = NSMakeRange(self.outputView.text.length - 1, 1);
    [self.outputView scrollRangeToVisible:range];
}

@end
