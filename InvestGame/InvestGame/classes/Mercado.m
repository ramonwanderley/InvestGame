//
//  mercado.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
<<<<<<< HEAD:InvestGame/InvestGame/classes/mercado.m
#import "mercado.h"
@implementation Mercado:NSObject
-(instancetype)initMercadoComRisco:(double)risco comOferta:(int)oferta eDemanda:(int)demanda{
        self = [super init];
        if(self){
            self.risco = risco;
            self.oferta = oferta;
            self.demanda = demanda;
            self.valorHoje = 1;
        }
        return self;
    }


    -(void)mudarOferta:(int) quantidade{
        self.oferta = self.oferta + quantidade;
    }
    -(void)mudarDemanda:(int) quantidade{
        self.demanda = self.demanda + quantidade;
    }
    -(void)calcularValorHoje{
        self.valorHoje = self.valorHoje + (self.demanda - self.oferta)/100;
    }
=======
#import "Investimento.h"
@implementation Mercado : NSObject
    

>>>>>>> afa5e40618a89c45c4d38b1f532f043746042cae:InvestGame/InvestGame/classes/Mercado.m

@end
