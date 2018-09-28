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
#import <AVFoundation/AvFoundation.h>
@implementation SelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // default pros nomes
    _vocalistaField.text = @"Bruno";
    _pandeiristaField.text = @"Cris";
    _cavacoField.text = @"Sérgio";
    _percussaoField.text = @"Ana";
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"wav"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.playerSound = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
    self.playerSound.numberOfLoops = -1;
    [self.playerSound play];
}
\

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"chamaJogo"]) {
        // Get reference to the destination view controller
        GameViewController *vc = segue.destinationViewController;
        [self.playerSound stop];
        // Pass any objects to the view controller here, like...
        // [vc setMyObjectHere:@"hola"];
        // passa o nome de todos pra próxima tela
        vc.nomesJogadores=@[_vocalistaField.text, _pandeiristaField.text, _cavacoField.text , _percussaoField.text];
    }
    // daqui vai pra proxima cena (game view controler)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end


