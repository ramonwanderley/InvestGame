//
//  jogador.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Carteira.h"
#import "Jogador.h"
#import <Foundation/Foundation.h>
@implementation Jogador : NSObject


-(instancetype)initComNome:(NSString *)nome comPosicao:(NSString *)posicao andCarteira:(Carteira *)carteira{
        self = [super init];
        if(self){
            self.nome = nome;
            self.carteira = carteira;
            self.posicao = posicao;
        }
        return self;
    }

   
//    -(id)init{
//        self = [super init];
//        nome = @"Tashow";
//        papel = @"Papel";
//    }

@end
