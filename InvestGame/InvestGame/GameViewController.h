//
//  GameViewController.h
//  InvestGame
//
//  Created by Ramon Wanderley on 18/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameViewController : UIViewController
    @property NSMutableArray <NSString*> * nomesJogadores;
@property (weak, nonatomic) IBOutlet UILabel *noticiaLabel;
- (IBAction)buttonOne:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
-(void)SetarTurno;
@end