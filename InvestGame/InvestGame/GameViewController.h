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

// contém os nomes que os jogadores digitarem na tela anterior (SelectViewControler)
@property NSMutableArray <NSString*> * nomesJogadores;

@property (weak, nonatomic) IBOutlet UILabel *noticiaLabel;
- (IBAction)buttonOne:(id)sender;
- (IBAction)proximo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
- (IBAction)passar:(id)sender;
- (IBAction)buyFixo:(id)sender;
- (IBAction)buyAcao:(id)sender;
- (IBAction)retirar:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
- (IBAction)buyCripto:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mancheteLabel;

// progress views
@property (weak, nonatomic) IBOutlet UIProgressView *granaBarra;
@property (weak, nonatomic) IBOutlet UIProgressView *turnoBarra;

// icones dos jogadores (turnos)
@property (weak, nonatomic) IBOutlet UIImageView *microfoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *violaoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pandeiroIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tecladoIcon;
@property (weak, nonatomic) IBOutlet UILabel *valorFixo;
@property (weak, nonatomic) IBOutlet UILabel *variacaoFixo;


- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size ;

// tela da TV
@property (weak, nonatomic) IBOutlet UIView *admView;
@property (weak, nonatomic) IBOutlet UILabel *valorCripto;
@property (weak, nonatomic) IBOutlet UILabel *variacaoCripto;
@property (weak, nonatomic) IBOutlet UILabel *tendenciaCripto;
@property (weak, nonatomic) IBOutlet UILabel *valorAcao;
@property (weak, nonatomic) IBOutlet UILabel *variacaoACAO;
@property (weak, nonatomic) IBOutlet UILabel *tendenciaAcao;
@property (weak, nonatomic) IBOutlet UIView *mercadoView;

// collection view da carteira do jogador (canal na tv)
@property (strong, nonatomic) IBOutlet UICollectionView *investCollection;

-(void)SetarTurno;
-(void)mudarCanl;
-(void)SetarNoticias;
-(void)atualizarBarras;
-(void)SetarNoticiasDaVez;
-(void)SetarIcons;
//- (void)swipeRight:(UISwipeGestureRecognizer *)sender;
@end
