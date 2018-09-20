//
//  SelectViewController.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectViewController.H"
@implementation SelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _vocalistaField.text = @"Bruno";
    _pandeiristaField.text = @"Cris";
    _cavacoField.text = @"Sérgio";
    _percussaoField.text = @"Ana";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end


