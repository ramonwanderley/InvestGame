//
//  GameViewController.m
//  InvestGame
//
//  Created by Ramon Wanderley on 18/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Jogador.h"

#import "investimento.h"
#import "mercado.h"
#import "popupInvestir.h"

@implementation GameViewController
NSMutableArray<Jogador*>  *jogadores;
int estado = 0;
int jogadorVez = 0;
Mercado* mercadoAcao;
Mercado* mercadoCripto;

//NSMutableArray<Investimento*> *investimentosDisponiveis = [NSMutableArray arrayWithObjects: [[Investimento alloc]initComTipo: comValor:<#(double)#> eQuantidade:<#(int)#> ] ,nil];
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // inicio do sprite kit (importado no .h)
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    //criando Carteiras e jogadores.
    Carteira* carteiraInicio = [[Carteira alloc] initComSaldo:1000];
    
    Jogador* jogador1 = [[Jogador alloc] initComNome: _nomesJogadores[0] comPosicao:@"Vocalista" andCarteira: carteiraInicio];
     Jogador* jogador2 = [[Jogador alloc] initComNome: _nomesJogadores[1] comPosicao:@"Cavaco" andCarteira: carteiraInicio];
     Jogador* jogador3 = [[Jogador alloc] initComNome: _nomesJogadores[2] comPosicao:@"Pandeiro" andCarteira: carteiraInicio];
     Jogador* jogador4 = [[Jogador alloc] initComNome: _nomesJogadores[3] comPosicao:@"Percussão" andCarteira: carteiraInicio];
   jogadores = [NSMutableArray arrayWithObjects: jogador1, jogador2, jogador3, jogador4, nil];

    
    for(int i = 0; i < 4; i++) {
        NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", i,jogadores[i].nome, jogadores[i].posicao, jogadores[i].carteira.saldo);
    }
    
    //estabelecendo Mercados
    mercadoCripto = [[Mercado alloc] initMercadoComRisco:0.55 comOferta:500 eDemanda:500];
    mercadoAcao = [[Mercado alloc] initMercadoComRisco:0.25 comOferta:1000 eDemanda:1000];
    
    
    _noticiaLabel.text = @"Criptomoedas consomem 1% da energia elétrica do mundo, diz estudo. De acordo com o autor da pesquisa, gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália";
    [self SetarTurno];
}

//varia toda a tela para o novo jeito
-(void)SetarTurno {
    if(estado == 0 ){
        _playerLabel.text = jogadores[0].nome;
        
    }
    else if(estado == 1){
        
    }
    else if(estado == 2){
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)buttonOne:(id)sender {
    int valor = estado % 4;
    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
    
    [jogadores[valor].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo]];
    
     NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", valor,jogadores[valor].nome, jogadores[valor].posicao, jogadores[valor].carteira.saldo);
//    PopupInvestir *child =[[PopupInvestir alloc] init];
//    [self addChildViewController:child];
//    child.view.frame = self.view.frame;
//    [self.view addSubview:child.view];
//    child.view.alpha = 0;
//    [child didMoveToParentViewController:self];
//    [UIView animateWithDuration:0.25 delay:0.0  options: UIViewAnimationOptionCurveEaseIn animations:^{
//        child.view.alpha = 1;
//    } completion:nil];
//   PopupInvestir *child =[[PopupInvestir alloc] init];
//    child.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
//    child.modalPresentationStyle = 17;
//    [self presentViewController:child animated:YES completion:nil];
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
