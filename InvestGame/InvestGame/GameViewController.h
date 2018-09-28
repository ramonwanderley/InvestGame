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
#import "FLAnimatedImageView.h"

@interface GameViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDataSource>

// contém os nomes que os jogadores digitarem na tela anterior (SelectViewControler)
@property (weak, nonatomic) IBOutlet UISegmentedControl *valorInvestido; //
@property NSMutableArray <NSString*> * nomesJogadores;

// canais da TV (funcionando como popups)
@property (strong, nonatomic) IBOutlet UIView *canalNoticiasAzulView; // 1 noticias
@property (strong, nonatomic) IBOutlet UIView *canalNoticiasVerdeView; // 2 noticias
@property (strong, nonatomic) IBOutlet UIView *admView; // 3 carteira
@property (strong, nonatomic) IBOutlet UIView *mercadoView; // 4 mercado
@property (strong, nonatomic) IBOutlet UIView *investView; // 5 investir (especial)

// canal noticias 1 azul- Outlets
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *backgroundTV;
@property (weak, nonatomic) IBOutlet UILabel *mancheteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticiaLabel;

// canal noticias 2 verde - Outlets
//

// canal carteira 3 - Outlets
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *investCollection;

// canal mercado 4 - Outlets
   // valor
@property (weak, nonatomic) IBOutlet UILabel *valorFixo;
@property (weak, nonatomic) IBOutlet UILabel *valorCripto;
@property (weak, nonatomic) IBOutlet UILabel *valorAcao;
   // variação
@property (weak, nonatomic) IBOutlet UILabel *variacaoFixo;
@property (weak, nonatomic) IBOutlet UILabel *variacaoACAO;
@property (weak, nonatomic) IBOutlet UILabel *variacaoCripto;
   // tendencia label
@property (weak, nonatomic) IBOutlet UILabel *tendenciaAcao;
@property (weak, nonatomic) IBOutlet UILabel *tendenciaCripto;
   // tendência - setas
@property (weak, nonatomic) IBOutlet UIImageView *tendenciaAcaoSeta;
@property (weak, nonatomic) IBOutlet UIImageView *tendenciaCryptoSeta;


// canal investir 5 - Outlets e Actions
@property (weak, nonatomic) IBOutlet UILabel *valorDoinvestimento;
- (IBAction)investir:(id)sender;
- (IBAction)cancelarInvest:(id)sender;


// icones dos jogadores (turnos)
@property (weak, nonatomic) IBOutlet UIImageView *microfoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *violaoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pandeiroIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tecladoIcon;

// progress views
@property (weak, nonatomic) IBOutlet UIProgressView *granaBarra;
@property (weak, nonatomic) IBOutlet UIProgressView *turnoBarra;

// escolhas da rodada
- (IBAction)buyFixo:(id)sender;
- (IBAction)buyAcao:(id)sender;
- (IBAction)buyCripto:(id)sender;
//
- (IBAction)retirar:(id)sender;
- (IBAction)passar:(id)sender;

// pop up feedback
- (IBAction)proximo:(id)sender;

// tamanho da TV
@property (weak, nonatomic) IBOutlet UIView *tamanhoDaTVref;

//
//
// NAO SEI (coloca na categoria delas plz)
@property (weak, nonatomic) IBOutlet UILabel *quantidadeLabel; // da collection view da carteira ou da tela de investir?
- (IBAction)quantidadeInvestida:(id)sender; // onde ta esse botao? nunca ta vi
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size ;
//
//

// funções criadas - turno e canais
-(void)SetarTurno;
-(void)SetarNoticias;
-(void)atualizarBarras;
-(void)SetarNoticiasDaVez;
-(void)SetarIcons;
-(void)mudarCanl;

//- (void)swipeRight:(UISwipeGestureRecognizer *)sender;

@end
