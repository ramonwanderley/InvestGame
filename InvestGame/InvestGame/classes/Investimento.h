//
//  Investimento.h
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Investimento:NSObject
    @property  int dataDeAquisicao;
    @property double valorDeInicio;
    @property NSMutableArray *historicoVendas;
    @property int  quantidade;
    @property BOOL variavel;

- (void)vender:(int) quantidade;
- (void)adquirir:(int) quantidade;
@end
