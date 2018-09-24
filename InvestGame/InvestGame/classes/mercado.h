//
//  mercado.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Investimento.h"
@interface Mercado:NSObject {
}
    @property double risco;
    @property int  oferta;
    @property int demanda;
    @property double mudancaDia;
    @property double valorHoje;
-(instancetype)initMercadoComRisco:(double)risco comOferta:(int)oferta eDemanda:(int)demanda;
    - (void)mudarOferta:(int) quantidade;
    - (void)mudarDemanda: (int) quantidade;
    - (void)calcularValorHoje;
@end
