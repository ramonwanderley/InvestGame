//
//  Noticia.h
//  InvestGame
//
//  Created by Ramon Wanderley on 24/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface Noticia: NSObject
@property NSString *texto;
@property int  ofertaMax;
@property int  ofertaMin;
@property int demandaMax;
@property int demandaMin;


-(instancetype)initNoticiacomTexto:(NSString*)texto comOfertaMax:(int)ofertaMax comOfertaMin:(int)ofertaMin comDemandaMax:(int)demandaMax eComDemandaMin:(int)demandaMin;


@end
