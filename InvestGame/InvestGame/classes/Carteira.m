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

@implementation Carteira

-(instancetype) initComSaldo:(double)saldo{
    self = [super init];
    if(self) {
        self.saldo = saldo;
        self.investimentos = [NSMutableArray arrayWithObjects: nil];
    }
    return self;
}

-(void) comprarInvestimento:(Investimento *) novoInvestimento eValorMercado:(float)valorMercado{
   
    if (self.saldo >= novoInvestimento.quantidade * valorMercado) {
        [self.investimentos addObject:(novoInvestimento)];
        self.saldo = self.saldo -  novoInvestimento.quantidade * valorMercado;
       // NSLog(@"%lf", self.investimentos[0].valorDeInicio);  // %lf - tipo de dado float
    
    }
    else{
         NSLog(@"saldo insuficiente!");
    }
    
}
-(float)TotalvalorMercadoCripto:(float) valorMercadoCripto eValorMercadoAcao:(float) valorMercadoAcao eFixo:(float) valorMercadoFixo {
    float montante = 0;
    montante = self.saldo;
    for(int i = 0; i < self.investimentos.count ; i++ ){
        montante = montante + self.investimentos[i].quantidade*valorMercado;
        
    }
    return montante;
}


@end
