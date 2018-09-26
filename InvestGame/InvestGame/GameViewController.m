//
//  GameViewController.m
//  InvestGame
//
//  Created by Ramon Wanderley on 18/09/2018.
//  Copyright © 2018 CorrenteDeBlocos. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Jogador.h"

#import "Investimento.h"
#import "mercado.h"
#import "popupInvestir.h"
#import "Noticia.h"
#import "cellInvest.h"
#include <stdlib.h>
@implementation GameViewController
NSMutableArray<Jogador*>  *jogadores;
int estado = 0;
int estadoTV = 0;
int jogadorVez = 0;
Mercado* mercadoAcao;
Mercado* mercadoCripto;
Mercado* mercadoFixo;
NSMutableArray<Noticia*> *noticias;
NSInteger noticiaDaVez[2];
NSInteger noticiasPassadas[24];


//- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
//{
//    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
//
//    if (self == context.nextFocusedView) {
//        [coordinator addCoordinatedAnimations:^{
//            context.nextFocusedView.backgroundColor = [UIColor colorWithRed:66.0f/255.0f
//                                                                      green:79.0f/255.0f
//                                                                       blue:91.0f/255.0f
//                                                                      alpha:1.0f] ;
//        } completion:^{
//            // completion
//        }];
//    } else if (self == context.previouslyFocusedView) {
//        [coordinator addCoordinatedAnimations:^{
//            context.nextFocusedView.backgroundColor = [UIColor colorWithRed:66.0f/255.0f
//                                                                      green:79.0f/255.0f
//                                                                       blue:91.0f/255.0f
//                                                                      alpha:1.0f] ;
//        } completion:^{
//            // completion
//        }];
//    }
//}

- (void)setNeedsFocusUpdate {
    
}

//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    return YES;
//}

//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    //criando Carteiras e jogadores.
    [self SetarNoticias];
    
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mudarCanal)];
    tapGestureRec.allowedPressTypes = @[@(UIPressTypePlayPause)];
    [self.view addGestureRecognizer:tapGestureRec];
    [self.investCollection hasUncommittedUpdates];
    self.investCollection.delegate = self;
    self.investCollection.dataSource = self;
    Carteira* carteiraInicio = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio2 = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio3 = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio4 = [[Carteira alloc] initComSaldo:1000];
    
    Jogador* jogador1 = [[Jogador alloc] initComNome: _nomesJogadores[0] comPosicao:@"Vocalista" andCarteira: carteiraInicio];
    Jogador* jogador2 = [[Jogador alloc] initComNome: _nomesJogadores[1] comPosicao:@"Cavaco" andCarteira: carteiraInicio2];
    Jogador* jogador3 = [[Jogador alloc] initComNome: _nomesJogadores[2] comPosicao:@"Pandeiro" andCarteira: carteiraInicio3];
    Jogador* jogador4 = [[Jogador alloc] initComNome: _nomesJogadores[3] comPosicao:@"Percussão" andCarteira: carteiraInicio4];
    jogadores = [NSMutableArray arrayWithObjects: jogador1, jogador2, jogador3, jogador4, nil];
    
    
    for(int i = 0; i < 4; i++) {
        NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", i,jogadores[i].nome, jogadores[i].posicao, jogadores[i].carteira.saldo);
    }
    
    //estabelecendo Mercados
    mercadoCripto = [[Mercado alloc] initMercadoComRisco:0.55 comOferta:0 eDemanda:0];
    mercadoAcao = [[Mercado alloc] initMercadoComRisco:0.25 comOferta:0 eDemanda:0];
    mercadoFixo  = [[Mercado alloc] initMercadocomTaxa:0.005];
    
    _admView.hidden = YES;
    [self SetarTurno];
    
}


//varia toda a tela para o novo jeito
-(void)SetarIcons{
    if(estado%4 == 0){
        UIImage *imageFocus = [UIImage imageNamed:@"microfoneemevidencia"];
        _microfoneIcon.frame = CGRectMake(
                                          1537,
                                          _microfoneIcon.frame.origin.y, 291, 291);
        _microfoneIcon.image = imageFocus;
        UIImage *imageDiFocus = [UIImage imageNamed:@"pandeirodeselecionado"];
        _pandeiroIcon.frame = CGRectMake(
                                         1674,
                                         _pandeiroIcon.frame.origin.y, 180, 180);
        _pandeiroIcon.image = imageDiFocus;
        _violaoIcon.layer.zPosition = _microfoneIcon.layer.zPosition;
        _pandeiroIcon.layer.zPosition = _microfoneIcon.layer.zPosition;
        _microfoneIcon.layer.zPosition = MAXFLOAT;
        
    }
    else if(estado%4 == 1){
        UIImage *imageFocus = [UIImage imageNamed:@"violaoemevidencia"];
        _violaoIcon.frame = CGRectMake(
                                       1537,
                                       _violaoIcon.frame.origin.y, 291, 291);
        _violaoIcon.image = imageFocus;
        UIImage *imageDiFocus = [UIImage imageNamed:@"microfonedeselecionado"];
        _microfoneIcon.frame = CGRectMake(
                                          1674,
                                          _microfoneIcon.frame.origin.y, 180, 180);
        _microfoneIcon.image = imageDiFocus;
        _microfoneIcon.layer.zPosition = _violaoIcon.layer.zPosition;
        _violaoIcon.layer.zPosition = MAXFLOAT;
        
    }
    else if(estado%4 == 2){
        UIImage *imageFocus = [UIImage imageNamed:@"tecladoemevidencia"];
        _tecladoIcon.frame = CGRectMake(
                                        1537,
                                        _tecladoIcon.frame.origin.y, 291, 291);
        _tecladoIcon.image = imageFocus;
        UIImage *imageDiFocus = [UIImage imageNamed:@"violaodeselecionado"];
        _violaoIcon.frame = CGRectMake(
                                       1674,
                                       _violaoIcon.frame.origin.y, 180, 180);
        _violaoIcon.image = imageDiFocus;
        _violaoIcon.layer.zPosition = _tecladoIcon.layer.zPosition;
        _tecladoIcon.layer.zPosition = MAXFLOAT;
    }
    else{
        UIImage *imageFocus = [UIImage imageNamed:@"pandeiroemevidencia"];
        _pandeiroIcon.frame = CGRectMake(
                                         1537,
                                         _pandeiroIcon.frame.origin.y, 291, 291);
        _pandeiroIcon.image = imageFocus;
        UIImage *imageDiFocus = [UIImage imageNamed:@"tecladodeselecionado"];
        _tecladoIcon.frame = CGRectMake(
                                        1674,
                                        _tecladoIcon.frame.origin.y, 180, 180);
        _tecladoIcon.image = imageDiFocus;
        _tecladoIcon.layer.zPosition =  _pandeiroIcon.layer.zPosition;
        _pandeiroIcon.layer.zPosition = MAXFLOAT;
    }
}
-(void)SetarTurno {
    if(estado%4 == 0 ){
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        [self atualizarBarras];
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        if(estado != 0){
            [self atualizarMercado];
        }
    }
    else if(estado%4 == 1){
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        [self atualizarBarras];
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        [self atualizarMercado];
    }
    else if(estado%4 == 2){
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        [self atualizarBarras];
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        [self atualizarMercado];
    }
    else{
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        [self atualizarBarras];
        estadoTV = 0;
        [self SetarIcons];
        [self mudarCanal];
        [self atualizarMercado];
    }
    
}
-(void)atualizarMercado{
    //mercado fixo
    [mercadoFixo calcularValorHojeFixo];
    
    if([noticias[noticiaDaVez[0]].tipo  isEqual: @"Cripto"]){
        int valorNovoOferta = arc4random_uniform(noticias[noticiaDaVez[0]].ofertaMax - noticias[noticiaDaVez[0]].ofertaMin);
        
        [mercadoCripto mudarOferta: valorNovoOferta + noticias[noticiaDaVez[0]].ofertaMin];
        
        int valorNovoDemanda = arc4random_uniform(noticias[noticiaDaVez[0]].demandaMax - noticias[noticiaDaVez[0]].demandaMin);
        
        [mercadoCripto mudarOferta: valorNovoDemanda + noticias[noticiaDaVez[0]].demandaMin];
    }
    else{
        int valorNovoOferta = arc4random_uniform(noticias[noticiaDaVez[0]].ofertaMax - noticias[noticiaDaVez[0]].ofertaMin);
        
        [mercadoAcao mudarOferta: valorNovoOferta + noticias[noticiaDaVez[0]].ofertaMin];
        
        int valorNovoDemanda = arc4random_uniform(noticias[noticiaDaVez[0]].demandaMax - noticias[noticiaDaVez[0]].demandaMin);
        
        [mercadoAcao mudarOferta: valorNovoDemanda + noticias[noticiaDaVez[0]].demandaMin];
    }
    if([noticias[noticiaDaVez[1]].tipo  isEqual: @"Cripto"]){
        int valorNovoOferta2 = arc4random_uniform(noticias[noticiaDaVez[1]].ofertaMax - noticias[noticiaDaVez[1]].ofertaMin);
        
        [mercadoCripto mudarOferta: valorNovoOferta2 + noticias[noticiaDaVez[1]].ofertaMin];
        int valorNovoDemanda2 = arc4random_uniform(noticias[noticiaDaVez[1]].demandaMax - noticias[noticiaDaVez[1]].demandaMin);
        [mercadoCripto mudarOferta: valorNovoDemanda2 + noticias[noticiaDaVez[1]].demandaMin];
        
    }
    else{
        int valorNovoOferta2 = arc4random_uniform(noticias[noticiaDaVez[1]].ofertaMax - noticias[noticiaDaVez[1]].ofertaMin);
        
        [mercadoAcao mudarOferta: valorNovoOferta2 + noticias[noticiaDaVez[1]].ofertaMin];
        int valorNovoDemanda2 = arc4random_uniform(noticias[noticiaDaVez[1]].demandaMax - noticias[noticiaDaVez[1]].demandaMin);
        [mercadoAcao mudarOferta: valorNovoDemanda2 + noticias[noticiaDaVez[1]].demandaMin];
        
    }
    [mercadoAcao calcularValorHoje];
    [mercadoCripto calcularValorHoje];
    
}

-(void)SetarNoticiasDaVez{
    BOOL escolhido1 = NO;
    BOOL escolhido2 = NO;
    int r;
    while(!(escolhido1 && escolhido2)){
        if(escolhido1 == NO){
            r = arc4random_uniform(23);
            if(noticiasPassadas[r] == 0){
                noticiaDaVez[0] = r;
                noticiasPassadas[r] = 1;
                escolhido1 = YES;
            }
        }
        else if(escolhido1 == YES && escolhido2 == NO){
            r = arc4random_uniform(23);
            if(noticiasPassadas[r] == 0){
                noticiaDaVez[1] = r;
                noticiasPassadas[r] = 1;
                escolhido2 = YES;
            }
        }
        
    }
}
-(void)atualizarBarras{
    float montante = 0;
    for(int i = 0; i < 4; i++){
        montante = montante + [jogadores[i].carteira TotalvalorMercado:mercadoCripto.valorHoje];
    }
    _granaBarra.progress = montante/10000;
    _turnoBarra.progress = estado/12;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)SetarNoticias{
    for (NSInteger i = 0; i < 24; i++)
        noticiasPassadas[i] = 0;
    noticias = [NSMutableArray arrayWithObjects: [[Noticia alloc]initNoticiacomTexto:@"De acordo com o autor da pesquisa, gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália" comTitulo:@"Criptomoedas consomem 1% da energia elétrica do mundo, diz estudo." comOfertaMax:5 comOfertaMin:1 comDemandaMax:5 eComDemandaMin:1 tipo:@"Cripto"] , [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                            Ex-craque do Real Madrid irá lançar a APC (Arquimedinho Soccer Coin), e a venda privada dos tokens já teve início." comTitulo: @"Arquimedinho Paulista vai lançar sua própria criptomoeda." comOfertaMax:100 comOfertaMin:50 comDemandaMax:300 eComDemandaMin:20 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Damian colocou à venda no início do mês um lote de 6k de criptos, enviando o preço para abaixo de CC 10.000. O mercado conseguiu se recuperar e voltar à faixa de CC 16.000 hoje, quando o investidor colocou mais um lote à venda, dessa vez de 8k de criptos." comTitulo:@"Portoriquenho derruba preço da bitcoin." comOfertaMax:510 comOfertaMin:500 comDemandaMax:20 eComDemandaMin:10 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"Depois de operar em alta nos últimos 6 dias, o mercado de criptomoedas adicionou CC 34 bilhões ao seu valor, a Criptocoin apresentou um pequeno recuo puxando várias outras moedas para baixo. Ela caiu 3%, enquanto outras moedas apresentaram quedas entre 5% a 10%. O volume de negociações da Criptocoin caiu para US$ 4 bilhões, após ter se mantido acima dos US$ 5,3 bilhões até 20 de agosto." comTitulo:@"" comOfertaMax:10 comOfertaMin:0 comDemandaMax:50 eComDemandaMin:12 tipo:@"Cripto"] , [[Noticia alloc]initNoticiacomTexto:@"O estado considera a criptocoin a partir de hoje como o equivalente a uma moeda legal para fins fiscais" comTitulo:@"Pernambuco legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:420 comOfertaMin:400 comDemandaMax:280 eComDemandaMin:250 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O continente considera a criptocoin a partir deste mês como o equivalente a uma moeda legal para fins fiscais quando usada como meio de pagamento" comTitulo:@"União Europeia legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:420 comOfertaMin:40 comDemandaMax:30000 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300 tipo:@"Cripto"],   nil];
    
}

- (IBAction)buttonOne:(id)sender {
    
    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
    
    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoCripto.valorHoje];
    
    NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
    estado = estado + 1;
    
    [self SetarTurno];
    
}

-(void)mudarCanal{
    if(estadoTV == 0 ){
        _admView.hidden = YES;
        _buttonOne.hidden = NO;
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        estadoTV = estadoTV + 1;
    }
    else if(estadoTV == 1){
        _mancheteLabel.text = noticias[noticiaDaVez[1]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[1]].texto;
        estadoTV = estadoTV + 1;
        
    }
    else if(estadoTV == 2){
        _admView.hidden = NO;
        _buttonOne.hidden = YES;
        [self.investCollection reloadData];
        estadoTV = 0;
    }
}
- (IBAction)proximo:(id)sender {
    
 
}

- (IBAction)butAcao:(id)sender {
}
- (BOOL)collectionView:(UICollectionView *)collectionView
canFocusItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
};

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
     static NSString *cellIdentifier = @"modelCell";
     cellInvest *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *tipo = jogadores[estado%4].carteira.investimentos[indexPath.row].tipo;
    int quantidade = jogadores[estado%4].carteira.investimentos[indexPath.row].quantidade;
    float valor;
    if(jogadores[estado%4].carteira.investimentos[indexPath.row].tipo == @"Cripto" ){
        valor = jogadores[estado%4].carteira.investimentos[indexPath.row].quantidade * mercadoCripto.valorHoje;
    }
    else if(jogadores[estado%4].carteira.investimentos[indexPath.row].tipo == @"Ação"){
        valor = jogadores[estado%4].carteira.investimentos[indexPath.row].quantidade * mercadoAcao.valorHoje;
    }
    else{
        valor = jogadores[estado%4].carteira.investimentos[indexPath.row].quantidade * mercadoFixo.valorHoje;
    }
    NSString *quantidadeTexto =  [NSString stringWithFormat:@"%d",quantidade];
    NSString *valorTexto = [NSString stringWithFormat:@"%f",valor];
    cell.tipoLabel.text = tipo;
    cell.quantidadeLabel.text = quantidadeTexto;
    cell.valorAtivoLabel.text = valorTexto;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"chegueiii %lu", (unsigned long)jogadores[0].carteira.investimentos.count);
    return jogadores[estado%4].carteira.investimentos.count;
   
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)tableView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    //this gives you the indexpath of the focused cell
    NSIndexPath *nextIndexPath = [context nextFocusedIndexPath];
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}

- (IBAction)buyCripto:(id)sender {
    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
    
    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoCripto.valorHoje];
    
    NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
    estado = estado + 1;
    
    [self SetarTurno];
}
- (IBAction)passar:(id)sender {
    estado = estado + 1;
    [self SetarTurno];
}

- (IBAction)buyFixo:(id)sender {
    int quantidadeDeAtivo = 100/mercadoFixo.valorHoje;
    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Fixo" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoFixo.valorHoje];
    
    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
  NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
    estado = estado + 1;
    [self SetarTurno];
}

- (IBAction)buyAcao:(id)sender {
    int quantidadeDeAtivo = 100/mercadoAcao.valorHoje;
    
    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Ação" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoAcao.valorHoje];
    
    NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
    estado = estado + 1;
    
    [self SetarTurno];
}

- (IBAction)retirar:(id)sender {
    estadoTV = 2;
    [self mudarCanal];
}

@end
