//
//  StartViewController.m
//  InvestGame
//
//  Created by Camila Simões on 27/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartViewController.h"
#import "SelectViewController.h"
#import <AVFoundation/AvFoundation.h>
@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"wav"];

    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.playerSound = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
    self.playerSound.numberOfLoops = -1;
    [self.playerSound play];
    
}


- (IBAction)startGameButton:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"chamaTelaJogadores"]) {
        [self.playerSound stop];
        SelectViewController *selectVC = segue.destinationViewController;
    }
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Make sure your segue name in storyboard is the same as this line
//    if ([[segue identifier] isEqualToString:@"chamaJogo"]) {
//        // Get reference to the destination view controller
//        GameViewController *vc = segue.destinationViewController;
//
//        // Pass any objects to the view controller here, like...
//        // [vc setMyObjectHere:@"hola"];
//        // passa o nome de todos pra próxima tela
//        vc.nomesJogadores=@[_vocalistaField.text, _pandeiristaField.text, _cavacoField.text , _percussaoField.text];
//    }
//    // daqui vai pra proxima cena (game view controler)
//}

@end
