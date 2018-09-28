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
@property NSString *titulo;
@property NSString *tipo;
@property NSString *feedback;
-(instancetype)initNoticiacomTexto:(NSString*)texto comTitulo:(NSString*)titulo comOfertaMax:(int)ofertaMax comOfertaMin:(int)ofertaMin comDemandaMax:(int)demandaMax eComDemandaMin:(int)demandaMin tipo:(NSString*)tipo eFeedback:(NSString*)feedback;
-(instancetype)initNoticiacomTexto:(NSString*)texto comTitulo:(NSString*)titulo comOfertaMax:(int)ofertaMax comOfertaMin:(int)ofertaMin comDemandaMax:(int)demandaMax eComDemandaMin:(int)demandaMin tipo:(NSString*)tipo;


@end
