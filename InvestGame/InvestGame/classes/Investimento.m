//
//  Investimento.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Investimento.h"

@implementation Investimento {
    double valorDeInicio;
    BOOL variavel;
    NSString* tipo;
    int quantidade;
}

-(instancetype)initComTipo:(NSString*)tipo comValor:(double)valor eQuantidade:(int)quantidade {
    self = [super init];
    if(self) {
        self.tipo = tipo;
        self.valorDeInicio = valor;
        self.quantidade = quantidade;
    }
    return self;
}


@end

