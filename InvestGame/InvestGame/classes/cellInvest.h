//
//  cellInvest.h
//  InvestGame
//
//  Created by Ramon Wanderley on 26/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface cellInvest: UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tipoLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantidadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valorAtivoLabel;
- (IBAction)vender:(id)sender;

@end
