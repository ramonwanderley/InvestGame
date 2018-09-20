//
//  Carteira.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carteira.h"
#import "Investimento.h"
@implementation Carteira {
    double saldo;
    double valorTotal;
    NSMutableArray<Investimento*> *investimentos;
}
-(void)comprarInvestimento:(Investimento *) novoInvestimento{
    if(self.saldo >= novoInvestimento.valorDeInicio){
        [self.investimentos addObject:(novoInvestimento)];
        self.saldo = self.saldo - novoInvestimento.valorDeInicio;
        NSLog(@"%lf", self.saldo);
    }
   
    
    }


@end
