//
//  Carteira.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Investimento.h"
#import <Foundation/Foundation.h>
@interface Carteira:NSObject
    @property NSMutableArray<Investimento *>* investimentos;
    @property double saldo;
    @property double valorTotal;
-(void)comprarInvestimento:(Investimento *) novoInvestimento;
@end
