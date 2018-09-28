//
//  StartViewController.h
//  InvestGame
//
//  Created by Camila Simões on 27/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AvFoundation.h>
#import <AVFoundation/AvFoundation.h>
@interface StartViewController : UIViewController

- (IBAction)startGameButton:(id)sender;
  @property (nonatomic) AVAudioPlayer *playerSound;

@end
