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

@implementation GameViewController

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
    NSMutableArray<Jogador*>  *jogadores = [NSMutableArray arrayWithObjects: jogador1, jogador2, jogador3, jogador4, nil];
    
    for(int i = 0; i < 4; i++) {
        NSLog(@"%lf", carteiraInicio.saldo);
    
        NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", i,jogadores[i].nome, jogadores[i].posicao, jogadores[i].carteira.saldo);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
