//
//  mercado.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Mercado.h"
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

-(instancetype)initMercadocomTaxa:(float) taxa{
    self = [super init];
    if(self){
        self.taxa = taxa;
        self.valorHoje = 1;
    }
    return self;
}


    -(void)calcularValorHojeFixo{
        self.valorHoje = self.valorHoje + self.valorHoje* self.taxa;
    }

    -(void)mudarOferta:(int) quantidade{
        self.oferta = self.oferta + quantidade;
    }
    -(void)mudarDemanda:(int) quantidade{
        self.demanda = self.demanda + quantidade;
    }
    -(void)calcularValorHoje{
        self.valorHoje = self.valorHoje + self.valorHoje *(self.demanda - self.oferta)/100;
    }

@end
