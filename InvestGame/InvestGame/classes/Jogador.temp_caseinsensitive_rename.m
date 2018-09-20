//
//  jogador.m
//  InvestGame
//
//  Created by Ramon Wanderley on 20/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import "jogador.m"
#import <Foundation/Foundation.h>
@implementation Jogador : NSObject {
    NSString *nome;
}


    -(id)  initWithNome:(NSString *)nome{
        self = [super init];
        if(self){
            self->nome = nome;
        }
        return self;
    }
   
//    -(id)init{
//        self = [super init];
//        nome = @"Tashow";
//        papel = @"Papel";
//    }

@end
