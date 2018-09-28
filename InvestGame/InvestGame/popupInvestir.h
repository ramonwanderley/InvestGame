//
//  popupInvestir.h
//  InvestGame
//
//  Created by Ramon Wanderley on 24/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <PopupKit/PopupView.h>
@interface PopupInvestir: PopupView

@property (nonatomic, weak) IBOutlet  UIButton* botao;
//-(instancetype)initWithCreator:();
- (IBAction)chamarProximo:(id)sender;

@end
