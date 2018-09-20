//
//  jogador.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Carteira.h"

@interface Jogador : NSObject
@property (assign) NSString *nome;
@property (assign) NSString *posicao;
@property Carteira *carteira;
-(instancetype)initWithNome:(NSString *)nome comPosicao:(NSString*)posicao andCarteira:(Carteira *)carteira;
@end



