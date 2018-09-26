//
//  Noticia.m
//  InvestGame
//
//  Created by Ramon Wanderley on 24/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "Noticia.h"
@implementation Noticia:NSObject


-(instancetype)initNoticiacomTexto:(NSString*)texto comTitulo:(NSString*)titulo comOfertaMax:(int)ofertaMax comOfertaMin:(int)ofertaMin comDemandaMax:(int)demandaMax eComDemandaMin:(int)demandaMin tipo:(NSString*)tipo{
    self = [super init];
    if(self){
        self.titulo = titulo;
        self.texto = texto;
        self.ofertaMax = ofertaMax;
        self.ofertaMin = ofertaMin;
        self.demandaMax = demandaMax;
        self.demandaMin = demandaMin;
        self.tipo = tipo;
    }
    return self;
}
@end
