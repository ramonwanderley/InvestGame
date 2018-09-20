//
//  SelectViewController.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectViewController.h"
#import "GameViewController.h"
@implementation SelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _vocalistaField.text = @"Bruno";
    _pandeiristaField.text = @"Cris";
    _cavacoField.text = @"Sérgio";
    _percussaoField.text = @"Ana";
    
}
//- (IBAction)iniciaGame:(id)sender {
//    [self performSegueWithIdentifier:@"chamaJogo" sender:sender];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"chamaJogo"])
    {
        // Get reference to the destination view controller
        GameViewController *vc = segue.destinationViewController;
        
        // Pass any objects to the view controller here, like...
//        [vc setMyObjectHere:@"hola"];
        vc.nomesJogadores=@[_vocalistaField.text, _pandeiristaField.text, _cavacoField.text , _percussaoField.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end


