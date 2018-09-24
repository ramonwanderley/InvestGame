//
//  Noticia.m
//  InvestGame
//
//  Created by Ramon Wanderley on 24/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Noticia.h"
@implementation Noticia:NSObject


-(instancetype)initNoticiacomTexto:(NSString*)texto comOfertaMax:(int)ofertaMax comOfertaMin:(int)ofertaMin comDemandaMax:(int)demandaMax eComDemandaMin:(int)demandaMin{
    self = [super init];
    if(self){
        self.texto = texto;
        self.ofertaMax = ofertaMax;
        self.ofertaMin = ofertaMin;
        self.demandaMax = demandaMax;
        self.demandaMin = demandaMin;
    }
    return self;
}
@end
