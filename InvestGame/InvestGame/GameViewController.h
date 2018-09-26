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

@interface GameViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDataSource>
    @property NSMutableArray <NSString*> * nomesJogadores;
@property (weak, nonatomic) IBOutlet UILabel *noticiaLabel;
- (IBAction)buttonOne:(id)sender;
- (IBAction)proximo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *mancheteLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *granaBarra;
@property (weak, nonatomic) IBOutlet UIProgressView *turnoBarra;
@property (weak, nonatomic) IBOutlet UIButton *proximoCanal;
@property (weak, nonatomic) IBOutlet UIImageView *microfoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *violaoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pandeiroIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tecladoIcon;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size ;
@property (weak, nonatomic) IBOutlet UIView *admView;
@property (strong, nonatomic) IBOutlet UICollectionView *investCollection;
-(void)SetarTurno;
-(void)mudarCanl;
-(void)SetarNoticias;
-(void)atualizarBarras;
-(void)SetarNoticiasDaVez;
-(void)SetarIcons;
//- (void)swipeRight:(UISwipeGestureRecognizer *)sender;
@end
