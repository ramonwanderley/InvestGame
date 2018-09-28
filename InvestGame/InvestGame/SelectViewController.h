//
//  SelectViewController.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import <AVFoundation/AvFoundation.h>
@interface SelectViewController : UIViewController
    @property (weak, nonatomic) IBOutlet UITextField *vocalistaField;
    @property (weak, nonatomic) IBOutlet UITextField *pandeiristaField;
    @property (weak, nonatomic) IBOutlet UITextField *cavacoField;
    @property (weak, nonatomic) IBOutlet UITextField *percussaoField;
    @property (nonatomic) AVAudioPlayer *playerSound;


@end
