//
//  jogador.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Carteira.h"

@interface Jogador : NSObject
@property  NSString* nome;
@property  NSString* posicao;
@property Carteira *carteira;
-(instancetype)initComNome:(NSString *)nome comPosicao:(NSString*)posicao andCarteira:(Carteira *)carteira;
@end



