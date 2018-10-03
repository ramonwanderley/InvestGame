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
#import "FLAnimatedImage.h"
#import <PopupKit/PopupView.h>
@implementation GameViewController

NSMutableArray<Jogador*>  *jogadores;

int estado = 0;
int estadoTV = 0;
int jogadorVez = 0;
double valorInvestir = 0;
NSString *tipoInvestimento = @"Cripto";
Mercado* mercadoAcao;
Mercado* mercadoCripto;
Mercado* mercadoFixo;
PopupView* popupFeed;
NSMutableArray<Noticia*> *noticias;
NSInteger noticiaDaVez[2];
NSInteger noticiasPassadas[24];

- (void)setNeedsFocusUpdate {
    [_pularFeedbackBtn setNeedsFocusUpdate];
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}


//- (void)updateFocusIfNeeded {
//    <#code#>
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"wav"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.playerSound = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
    self.playerSound.numberOfLoops = -1;
    [self.playerSound play];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle]pathForResource:@"Jornalistas 720 canal1" ofType:@"gif"]]];
    
    _backgroundTV.animatedImage = image;
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    imageView.animatedImage = image;
//    imageView.frame = CGRectMake(523, 351, 960, 509);
//
//    [self.view addSubview:imageView];
    //    //criando Carteiras e jogadores.
    [self SetarNoticias];
    
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mudarCanal)];
    tapGestureRec.allowedPressTypes = @[@(UIPressTypePlayPause)];
    [self.view addGestureRecognizer:tapGestureRec];
    [self.investCollection hasUncommittedUpdates];
    
    // [protocolos] collection view da carteira do jogador (canal na tv)
    self.investCollection.delegate = self;
    self.investCollection.dataSource = self;
   
    
    // iniciando as carteiras dos jogadores com 1k cavacoins cada
    Carteira* carteiraInicio = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio2 = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio3 = [[Carteira alloc] initComSaldo:1000];
    Carteira* carteiraInicio4 = [[Carteira alloc] initComSaldo:1000];
    
    // iniciando os 4 jogadores com o nome escolhido, vaga na banda e 1k cavacoins
    Jogador* jogador1 = [[Jogador alloc] initComNome: _nomesJogadores[0] comPosicao:@"Vocalista" andCarteira: carteiraInicio];
    Jogador* jogador2 = [[Jogador alloc] initComNome: _nomesJogadores[1] comPosicao:@"Cavaco" andCarteira: carteiraInicio2];
    Jogador* jogador3 = [[Jogador alloc] initComNome: _nomesJogadores[2] comPosicao:@"Pandeiro" andCarteira: carteiraInicio3];
    Jogador* jogador4 = [[Jogador alloc] initComNome: _nomesJogadores[3] comPosicao:@"Percussão" andCarteira: carteiraInicio4];
    jogadores = [NSMutableArray arrayWithObjects: jogador1, jogador2, jogador3, jogador4, nil];
    
    // print de teste
    for(int i = 0; i < 4; i++) {
        NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", i,jogadores[i].nome, jogadores[i].posicao, jogadores[i].carteira.saldo);
    }
    
    //estabelecendo Mercados iniciais
    mercadoCripto = [[Mercado alloc] initMercadoComRisco:0.55 comOferta:0 eDemanda:0];
    mercadoAcao = [[Mercado alloc] initMercadoComRisco:0.25 comOferta:0 eDemanda:0];
    mercadoFixo  = [[Mercado alloc] initMercadocomTaxa:0.005];
    
    // canal da carteira
    _mercadoView.hidden = YES;
    _admView.hidden = YES;
    [self SetarTurno];
    
    
    //MARK: Aparência Progress Views
    
    // progress view GRANA
    // o insets é pra que a imagem se repita em vez de esticar toda
    UIImage *granaProgresso = [[UIImage imageNamed:@"moeda-raport"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    // UIEdgeInsetsMake(float top, float left, float botton, float right)
    [_granaBarra setProgressImage: granaProgresso];
    
    // pra setar a altura da progress view - de acordo com a da moeda (outras medidas colocadas no "olho")
    // CGRectMake(float x, float y, float width, float height)
    _granaBarra.frame = CGRectMake(140, 60, 1640, 47);
    // arredondou sozinha, não sei porque
    _granaBarra.layer.cornerRadius = 2;
    _granaBarra.clipsToBounds = YES;
    _granaBarra.layer.sublayers[1].cornerRadius = 2;
    _granaBarra.subviews[1].clipsToBounds = YES;

    
    // progress view TEMPO / TURNO
    _turnoBarra.frame = CGRectMake(140, 130, 1640, 20);
    
    // arredondando a borda do progress view
    _turnoBarra.layer.cornerRadius = 10; // metade da altura
    _turnoBarra.clipsToBounds = YES;
    // arredondando a borda da subview dela (tint?) também
    _turnoBarra.layer.sublayers[1].cornerRadius = 10;
    _turnoBarra.subviews[1].clipsToBounds = YES;
    


}   // fim do viewDidLoad()

-(void)viewWillAppear:(BOOL)animated{
//    PopupInvestir* contentView =  (PopupInvestir*)[[[NSBundle mainBundle] loadNibNamed:@"popupinvestir" owner:self options:nil] lastObject];  //[[UIView alloc] init];
//    contentView.backgroundColor = [UIColor orangeColor];
//    contentView.frame = CGRectMake(0.0, 0.0, 800.0, 600.0);
//
//    [contentView.botao addTarget:contentView action:@selector(chamarProximo:) forControlEvents:UIControlEventTouchUpInside];
////
////    PopupInvestir* popup = [PopupInvestir popupViewWithContentView:contentView];
////    PopupInvestir* popup = [[PopupInvestir alloc] init ];
//    [contentView show];
//    
    
}

// varia toda a tela para o novo jeito
// antes 291 em evidencia, e 180 fora do turno
// CGRectMake(float x, float y, float width, float height)
-(void)SetarIcons{
    if(estado%4 == 0){
        UIImage *imageFocus = [UIImage imageNamed:@"microfoneemevidencia"];
        _microfoneIcon.frame = CGRectMake(
                                          1537,
                                          _microfoneIcon.frame.origin.y, 250, 250);
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
                                       _violaoIcon.frame.origin.y, 250, 250);
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
                                        _tecladoIcon.frame.origin.y, 250, 250);
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
                                         _pandeiroIcon.frame.origin.y, 250, 250);
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
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"vocal" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.playerEfectsTurno = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
        //self.playerEfectsTurno.numberOfLoops = 1;
        self.playerEfectsTurno.volume = 1;
        [self.playerEfectsTurno play];
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = [noticias[noticiaDaVez[0]].titulo uppercaseString];
        // uppercase funciona no debug mas não na execução, sei la pq
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        _noticiaLabel.hidden = YES; // textão escondido, precisa mesmo dele?
        
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        if(estado != 0){
            [self atualizarMercado];
        }
        [self atualizarBarras];
    }
    else if(estado%4 == 1){
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"cavaquinho" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.playerEfectsTurno = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
        //self.playerEfectsTurno.numberOfLoops = 1;
        self.playerEfectsTurno.volume = 1;
        [self.playerEfectsTurno play];
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = [noticias[noticiaDaVez[0]].titulo uppercaseString];
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        _noticiaLabel.hidden = YES; // escondendo o textão
        [self atualizarBarras];
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        [self atualizarMercado];
        [self atualizarBarras];
    }
    else if(estado%4 == 2){
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"Teclado" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.playerEfectsTurno = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
        //self.playerEfectsTurno.numberOfLoops = 1;
         self.playerEfectsTurno.volume = 1;
        [self.playerEfectsTurno play];
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        
        _mancheteLabel.text = [noticias[noticiaDaVez[0]].titulo uppercaseString];
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        _noticiaLabel.hidden = YES; // escondendo o textão
    
        [self SetarIcons];
        estadoTV = 0;
        [self mudarCanal];
        [self atualizarMercado];
        [self atualizarBarras];
    }
    else{
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"Percussao" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.playerEfectsTurno = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
        //self.playerEfectsTurno.numberOfLoops = 1;
        self.playerEfectsTurno.volume = 1;
        [self.playerEfectsTurno play];
        
        _playerLabel.text = jogadores[estado%4].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = [noticias[noticiaDaVez[0]].titulo uppercaseString];
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        _noticiaLabel.hidden = YES; // escondendo o textão
        
        estadoTV = 0;
        [self SetarIcons];
        [self mudarCanal];
        [self atualizarMercado];
         [self atualizarBarras];
    }
    
}
-(void)atualizarMercado{
    //mercado fixo
    [mercadoFixo calcularValorHojeFixo];
    
    if([noticias[noticiaDaVez[0]].tipo  isEqual: @"Cripto"]){
        int valorNovoOferta = arc4random_uniform(noticias[noticiaDaVez[0]].ofertaMax - noticias[noticiaDaVez[0]].ofertaMin);
        
        [mercadoCripto mudarOferta: valorNovoOferta + noticias[noticiaDaVez[0]].ofertaMin];
        
        int valorNovoDemanda = arc4random_uniform(noticias[noticiaDaVez[0]].demandaMax - noticias[noticiaDaVez[0]].demandaMin);
        
        [mercadoCripto mudarDemanda: valorNovoDemanda + noticias[noticiaDaVez[0]].demandaMin];
    }
    else{
        int valorNovoOferta = arc4random_uniform(noticias[noticiaDaVez[0]].ofertaMax - noticias[noticiaDaVez[0]].ofertaMin);
        
        [mercadoAcao mudarOferta: valorNovoOferta + noticias[noticiaDaVez[0]].ofertaMin];
        
        int valorNovoDemanda = arc4random_uniform(noticias[noticiaDaVez[0]].demandaMax - noticias[noticiaDaVez[0]].demandaMin);
        
        [mercadoAcao mudarDemanda: valorNovoDemanda + noticias[noticiaDaVez[0]].demandaMin];
    }
    if([noticias[noticiaDaVez[1]].tipo  isEqual: @"Cripto"]){
        int valorNovoOferta2 = arc4random_uniform(noticias[noticiaDaVez[1]].ofertaMax - noticias[noticiaDaVez[1]].ofertaMin);
        
        [mercadoCripto mudarOferta: valorNovoOferta2 + noticias[noticiaDaVez[1]].ofertaMin];
        int valorNovoDemanda2 = arc4random_uniform(noticias[noticiaDaVez[1]].demandaMax - noticias[noticiaDaVez[1]].demandaMin);
        [mercadoCripto mudarDemanda: valorNovoDemanda2 + noticias[noticiaDaVez[1]].demandaMin];
        
    }
    else{
        int valorNovoOferta2 = arc4random_uniform(noticias[noticiaDaVez[1]].ofertaMax - noticias[noticiaDaVez[1]].ofertaMin);
        
        [mercadoAcao mudarOferta: valorNovoOferta2 + noticias[noticiaDaVez[1]].ofertaMin];
        int valorNovoDemanda2 = arc4random_uniform(noticias[noticiaDaVez[1]].demandaMax - noticias[noticiaDaVez[1]].demandaMin);
        [mercadoAcao mudarDemanda: valorNovoDemanda2 + noticias[noticiaDaVez[1]].demandaMin];
        
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
            r = arc4random_uniform(10);
            if(noticiasPassadas[r] == 0){
                noticiaDaVez[0] = r;
                noticiasPassadas[r] = 1;
                escolhido1 = YES;
            }
        }
        else if(escolhido1 == YES && escolhido2 == NO){
            r = arc4random_uniform(10);
            if(noticiasPassadas[r] == 0){
                noticiaDaVez[1] = r;
                noticiasPassadas[r] = 1;
                escolhido2 = YES;
            }
        }
        
    }
}

-(void)atualizarFeedback{
    _popupFeedback.frame = CGRectMake(0.0, 0.0, _popupFeedback.frame.size.width, _popupFeedback.frame.size.height);
    _playerPopupLabel.text = jogadores[estado%4].nome;
    _mancheteLabelPopup1.text = noticias[noticiaDaVez[0]].titulo;
    _mancheteLabelPopup2.text = noticias[noticiaDaVez[1]].titulo;
    if(noticias[noticiaDaVez[0]].feedback != nil){
        _feedbackLabelPopup1.text = [noticias[noticiaDaVez[0]].feedback uppercaseString];
    }
    if(noticias[noticiaDaVez[1]].feedback != nil){
        _feedbackLabelPopup2.text = [noticias[noticiaDaVez[1]].feedback uppercaseString];
    }
    if(estado%4 == 0){
        UIImage *imageFocus = [UIImage imageNamed:@"microfonedeselecionado"];
        _imageJogador.image = imageFocus;
        
    }
    else if(estado%4 == 1){
        UIImage *imageFocus = [UIImage imageNamed:@"violaodeselecionado"];
        _imageJogador.image = imageFocus;
    }
    else if(estado%4 == 2){
        UIImage *imageFocus = [UIImage imageNamed:@"tecladodeselecionado"];
        _imageJogador.image = imageFocus;
    }
    else{
        UIImage *imageFocus = [UIImage imageNamed:@"pandeirodeselecionado"];
        _imageJogador.image = imageFocus;
    }
   
    popupFeed = [PopupView popupViewWithContentView:_popupFeedback];
    _pularFeedbackBtn.enabled = YES;
    [_pularFeedbackBtn setNeedsFocusUpdate];
    [popupFeed show];
    [self preferredFocusedView];
    
    }
-(UIView*)preferredFocusedView{
    return _popupFeedback;
}

-(void)atualizarBarras{
    float montante = 0;
    for(int i = 0; i < 4; i++){
        montante = montante + [jogadores[i].carteira TotalvalorMercadoCripto:mercadoCripto.valorHoje eValorMercadoAcao:mercadoAcao.valorHoje eFixo:mercadoFixo.valorHoje];
    }
    _granaBarra.progress = montante/25000;
    _turnoBarra.progress = estado/12;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)SetarNoticias{
    for (NSInteger i = 0; i < 10; i++)
        noticiasPassadas[i] = 0;
    noticias = [NSMutableArray arrayWithObjects:
                [[Noticia alloc]initNoticiacomTexto:@"Gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália" comTitulo:@"Criptomoedas já consomem 1% da energia do mundo!" comOfertaMax:4 comOfertaMin:1 comDemandaMax:1 eComDemandaMin:0 tipo:@"Cripto" eFeedback:@"essa notícia demonstra barreiras na utilização das criptomoedas, dificultando a aceitação"] ,
                [[Noticia alloc]initNoticiacomTexto:@"Ex-craque do Real Madrid irá lançar a ARC (Arquimedes Real Coin) e já iniciou as pré-vendas" comTitulo: @"Arquimedes Paulista vai lançar sua própria criptomoeda!" comOfertaMax:5 comOfertaMin:1 comDemandaMax:10 eComDemandaMin:4 tipo:@"Cripto" eFeedback:@"gera uma maior popularização das criptomoedas e com isso uma maior aceitação"],
                [[Noticia alloc]initNoticiacomTexto:@"Damian colocou à venda 6 mil criptomoedas, abaixando seu valor intensamente" comTitulo:@"Milionário vende todo seu lote" comOfertaMax:65 comOfertaMin:50 comDemandaMax:20 eComDemandaMin:10 tipo:@"Cripto" eFeedback:@"isso gera um aumento da oferta e por isso a queda de preço é iminente"],
                [[Noticia alloc]initNoticiacomTexto:@"Valor total das moedas no mercado subiu em 34 bilhões em 6 dias" comTitulo:@"Marketcap da criptocoin em alta essa semana!" comOfertaMax:15 comOfertaMin:5 comDemandaMax:5 eComDemandaMin:1 tipo:@"Cripto" eFeedback:@"isso gera uma maior valorização da criptomoeda e o crescimento do ativo"] ,
                [[Noticia alloc]initNoticiacomTexto:@"A empresa de comércio eletrônico passa a aceitar criptomoedas a partir de hoje" comTitulo:@"Mercado Aberto reconhece criptomedas como meio de pagamento!" comOfertaMax:12 comOfertaMin:2 comDemandaMax:28 eComDemandaMin:25 tipo:@"Cripto" eFeedback:@"isso gera maior uso da criptomoeda e também maior aceitação"],
                [[Noticia alloc]initNoticiacomTexto:@"O continente considera criptomoedas a partir deste mês como o equivalente a uma moeda legal para fins fiscais quando usada como meio de pagamento" comTitulo:@"União Europeia legaliza criptomedas!" comOfertaMax:30 comOfertaMin:20 comDemandaMax:50 eComDemandaMin:30 tipo:@"Cripto" eFeedback:@"gera enorme visibilidade e aceitação da criptomoeda"],
                [[Noticia alloc]initNoticiacomTexto:@"Ações americanas estão perto de terem o pior início de trimestre da história." comTitulo:@"Guerra comercial com a Ásia e críticas dos governos à Orange derrubam os mercados!" comOfertaMax:80 comOfertaMin:40 comDemandaMax:4 eComDemandaMin:0 tipo:@"Ação" eFeedback:@"mau resultado das ações desestimula os investidores e traz má publicidade para a empresa"],
                [[Noticia alloc]initNoticiacomTexto:@"A Orange se tornou nesta quinta-feira a primeira empresa com ações na Bolsa de Nova York a ultrapassar a marca de CC 1 quadrilhão em valor de mercado." comTitulo:@"Orange vale mais que a Bolsa americana" comOfertaMax:20 comOfertaMin:2 comDemandaMax:100 eComDemandaMin:30 tipo:@"Ação" eFeedback:@"recorde em valor de mercado anima os investidores a comprarem mais ações"],
                [[Noticia alloc]initNoticiacomTexto:@"Os ataques de hackers triplicaram nos últimos meses. Esse aumento representou mais 5 milhões de novas tentativas em roubar criptocoins." comTitulo:@"Diversos ataques à criptocoins nos últimos 4 meses" comOfertaMax:100 comOfertaMin:80 comDemandaMax:0 eComDemandaMin:0 tipo:@"Cripto" eFeedback:@"insegurança gera muito receio e diminui o número de investimentos digitais"],
                 [[Noticia alloc]initNoticiacomTexto:@"Empresa brasileira havia pedido registro do nome “Orange” no Instituto de Registros em 2017. Um ano antes o “Orange” havia sido lançado nos EUA pela Orange." comTitulo:@"Orange sofre processo por direitos autorais" comOfertaMax:70 comOfertaMin:30 comDemandaMax:0 eComDemandaMin:0 tipo:@"Ação" eFeedback:@"repercussão negativa desanima os investidores"],

                [[Noticia alloc]initNoticiacomTexto:@"Orange venceu Shone em leilão pela aquisição do grupo de televisão, Semview, com proposta de CC 39 bilhões." comTitulo:@"Grupo americano dispara na bolsa após oferta pela Semview" comOfertaMax:5 comOfertaMin:2 comDemandaMax:50 eComDemandaMin:20 tipo:@"Ação" eFeedback:@"o crescimento da empresa aumenta a força das ações"]
                ,nil];
    
}

// vai usar ainda?
- (IBAction)buttonOne:(id)sender {
    
    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
    
    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoCripto.valorHoje];
    
    NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
    estado = estado + 1;
    
    [self SetarTurno];
    
}



// MARK: mudar canal (funcão) declaração
-(void)mudarCanal{
//    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"mp3static" ofType:@"mp3"];
//    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
//    self.playerEfectsTurno.volume = 0.5;
//    self.playerEfectsTurno = [[AVAudioPlayer alloc ] initWithContentsOfURL:soundFileURL error:nil];
//    //self.playerEfectsTurno.numberOfLoops = 1;
//    [self.playerEfectsTurno play];
//    
    // canal noticias azul
    if(estadoTV == 0 ){
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle]pathForResource:@"Jornalistas 720 canal1" ofType:@"gif"]]];
        
        _backgroundTV.animatedImage = image;
        [self formatar:_mercadoView hidden:YES];  // esconde 5
        [self formatar:_canalNoticiasAzulView hidden:NO];  // mostra 1
//        _investView.hidden = YES;
//        _mercadoView.hidden = YES;
//        _buttonOne.hidden = YES; // escondido enquando nao precisa
        _mancheteLabel.text = [noticias[noticiaDaVez[0]].titulo uppercaseString];
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        estadoTV = estadoTV + 1;
    }
    
    // canal noticias verde
    else if(estadoTV == 1){
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle]pathForResource:@"Jornalistas 720 canal2" ofType:@"gif"]]];
        
        _backgroundTV.animatedImage = image;
        //[self formatar:_canalNoticiasAzulView hidden:YES]; // esconde 1
        //[self formatar:_canalNoticiasVerdeView hidden:NO]; // mostra 2
//        _investView.hidden = YES;
        _mancheteLabel.text = [noticias[noticiaDaVez[1]].titulo uppercaseString];
        _noticiaLabel.text = noticias[noticiaDaVez[1]].texto;
        estadoTV = estadoTV + 1;
        
    }
    
    // canal carteira
    else if(estadoTV == 2){
        [self formatar:_canalNoticiasVerdeView hidden:YES]; // esconde 2
        [self formatar:_admView hidden:NO]; // mostra 3
//        _investView.hidden = YES;
//        _admView.hidden = NO;
//        _buttonOne.hidden = YES;
        _cavacoinLabel.text =[NSString stringWithFormat:@"%0.2lf",jogadores[estado%4].carteira.saldo];
        double valorParaExibir = 0;
        for (int i = 0; i < [jogadores[estado%4].carteira.investimentos count]; i++){
            if(jogadores[estado%4].carteira.investimentos[i].tipo == @"Cripto"){
               valorParaExibir = valorParaExibir + jogadores[estado%4].carteira.investimentos[i].quantidade * mercadoCripto.valorHoje;
            }
            else if(jogadores[estado%4].carteira.investimentos[i].tipo == @"Ação"){
                valorParaExibir = valorParaExibir + jogadores[estado%4].carteira.investimentos[i].quantidade * mercadoAcao.valorHoje;
            }
            else{
               valorParaExibir = valorParaExibir + jogadores[estado%4].carteira.investimentos[i].quantidade * mercadoFixo.valorHoje;
            }
            
        }
        _cavacoinInvestidoLabel.text =[NSString stringWithFormat:@"%0.2lf",valorParaExibir];
        [self.investCollection reloadData];
        estadoTV = estadoTV + 1;
    }
    
    // canal mercado
    else if(estadoTV == 3){
        [self formatar:_admView hidden:YES]; // esconde 3
        [self formatar:_mercadoView hidden:NO]; // mostra
//        _investView.hidden = YES;
//        _mercadoView.hidden = NO;
//        _admView.hidden = YES;
        estadoTV = 0;
         NSString *valorCriptoTexto =  [NSString stringWithFormat:@"%0.2lf",mercadoCripto.valorHoje];
            NSString *valorAcaoTexto =  [NSString stringWithFormat:@"%0.2lf",mercadoAcao.valorHoje];
        _valorAcao.text = valorAcaoTexto;
        _valorCripto.text = valorCriptoTexto;
        
        // tendência de alta e queda (setinhas)
        // criptocoin
        if( mercadoCripto.oferta > mercadoCripto.demanda){
//            _tendenciaCripto.text = @"Baixa";
//            _tendenciaCripto.textColor = UIColor.redColor;
            _tendenciaCryptoSeta.image = [UIImage imageNamed:@"em-queda"]; //
        } else{
//            _tendenciaCripto.text = @"Alta";
//            _tendenciaCripto.textColor = UIColor.greenColor;
            _tendenciaCryptoSeta.image = [UIImage imageNamed:@"em-alta"]; //
        }
        
        // açoes orange
        if( mercadoAcao.oferta > mercadoAcao.demanda){
//            _tendenciaAcao.text = @"Baixa";
//            _tendenciaAcao.textColor = UIColor.redColor;
            _tendenciaAcaoSeta.image = [UIImage imageNamed:@"em-queda"]; //
            
        } else{
//            _tendenciaAcao.text = @"Alta";
//            _tendenciaAcao.textColor = UIColor.greenColor;
            _tendenciaAcaoSeta.image = [UIImage imageNamed:@"em-alta"]; //
        }
        
        float inicioDoCalculoCripto = mercadoCripto.valorHoje - mercadoCripto.valorOntem;
        inicioDoCalculoCripto = (inicioDoCalculoCripto/mercadoCripto.valorOntem) * 100;
        if(mercadoCripto.valorOntem == 0){
            inicioDoCalculoCripto = (inicioDoCalculoCripto/mercadoCripto.valorOntem) * 100;
            
        }
        
        NSString *variacaoCriptoTexto = [NSString stringWithFormat:@"%0.2lf %%",inicioDoCalculoCripto];
        _variacaoCripto.text = variacaoCriptoTexto;
        float inicioDoCalculoAcao = mercadoAcao.valorHoje - mercadoAcao.valorOntem;
        inicioDoCalculoAcao = (inicioDoCalculoAcao/mercadoAcao.valorOntem) * 100;
        NSString *variacaoAcaoTexto = [NSString stringWithFormat:@"%0.2lf %%",inicioDoCalculoAcao];
        _variacaoACAO.text = variacaoAcaoTexto;
        
        NSString *variacaoFixoTexto = [NSString stringWithFormat:@"%0.3lf %%", mercadoFixo.taxa * 100];
        NSString *valorFixoTexto = [NSString stringWithFormat:@"%0.3lf", mercadoFixo.valorHoje];
        _valorFixo.text = valorFixoTexto;
        _variacaoFixo.text = variacaoFixoTexto;
        
    }
    
    // canal especial: INVEST!
    else if(estadoTV == 4){
        [_valorInvestido setNeedsFocusUpdate];
        // mostra esse canal por cima do que tiver vindo antes
        // quando ele for escondido pelos botoes invest ou cancelar, aparece o que ja tava embaixo
        [self formatar:_investView hidden:NO];
//        _mercadoView.hidden = YES;
//        _admView.hidden = YES;
//        _investView.hidden = NO;
        estadoTV = 0;
        
    }
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
    if([jogadores[estado%4].carteira.investimentos[indexPath.row].tipo  isEqual: @"Cripto"] ){
        valor = jogadores[estado%4].carteira.investimentos[indexPath.row].quantidade * mercadoCripto.valorHoje;
    }
    else if([jogadores[estado%4].carteira.investimentos[indexPath.row].tipo  isEqual: @"Ação"]){
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
    tipoInvestimento = @"Cripto";
    estadoTV = 4;
    [self mudarCanal];
//    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
//     tipoInvestimento = @"Cripto";
//    [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo] eValorMercado:mercadoCripto.valorHoje];
//
//    NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
//    NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
//    estado = estado + 1;
//
//    [self SetarTurno];
}
- (IBAction)passar:(id)sender {
    estado = estado + 1;
    [self SetarTurno];
    estadoTV = 0;
    [self mudarCanal];
}

- (IBAction)buyFixo:(id)sender {
    tipoInvestimento = @"Fixo";
    estadoTV = 4;
    [self mudarCanal];

}

- (IBAction)buyAcao:(id)sender {
    tipoInvestimento = @"Ação";
    estadoTV = 4;
    [self mudarCanal];

}

- (IBAction)retirar:(id)sender {
    estadoTV = 2;
    [self mudarCanal];
}

- (IBAction)quantidadeInvestida:(id)sender {
    NSString *title = [_valorInvestido titleForSegmentAtIndex:_valorInvestido.selectedSegmentIndex];
    _quantidadeLabel.text = title;
    if([tipoInvestimento  isEqual: @"Cripto"]){
        _valorDoinvestimento.text = [NSString stringWithFormat:@"%0.2lf",[title intValue] * mercadoCripto.valorHoje];
        
    }
    else if ([tipoInvestimento  isEqual: @"Ação"]){
        _valorDoinvestimento.text = [NSString stringWithFormat:@"%0.2lf",[title intValue] * mercadoAcao.valorHoje];
    }
    else{
        _valorDoinvestimento.text = [NSString stringWithFormat:@"%0.2lf",[title intValue] * mercadoFixo.valorHoje];
    }
    
}


- (IBAction)investir:(id)sender {
    if(popupFeed.isShowing == NO ){
          NSString *valorTexto = [_valorInvestido titleForSegmentAtIndex:_valorInvestido.selectedSegmentIndex];
           _quantidadeLabel.text = valorTexto;
        if([tipoInvestimento  isEqual: @"Cripto"]){
            _valorDoinvestimento.text = [NSString stringWithFormat:@"%lf",[valorTexto intValue] * mercadoCripto.valorHoje];
            [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:[valorTexto intValue]] eValorMercado:mercadoCripto.valorHoje];
        }
        else if([tipoInvestimento  isEqual:  @"Ação"]){
            _valorDoinvestimento.text = [NSString stringWithFormat:@"%lf",[valorTexto intValue] * mercadoAcao.valorHoje];
            [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Ação" comValor: 100 eQuantidade:[valorTexto intValue]] eValorMercado:mercadoAcao.valorHoje];
        }
        else{
             _valorDoinvestimento.text = [NSString stringWithFormat:@"%lf",[valorTexto intValue] * mercadoFixo.valorHoje];
            [jogadores[estado%4].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Fixo" comValor: 100 eQuantidade:[valorTexto intValue]] eValorMercado:mercadoFixo.valorHoje];
        }
        NSLog(@"Compra nome:%@ posicao:%@ saldo: %lf",jogadores[estado%4].nome, jogadores[estado%4].posicao, jogadores[estado%4].carteira.saldo);
        NSLog(@"%d",jogadores[estado%4].carteira.investimentos[jogadores[estado%4].carteira.investimentos.count -1].quantidade);
        estadoTV = 0;
        
        [self atualizarFeedback];
        
    }
    else{
        estado = estado + 1;
        [popupFeed dismiss:YES];
        [self SetarTurno];
    }
}

- (IBAction)cancelarInvest:(id)sender {
    estadoTV = 0;
    [self mudarCanal];
}






////MARK: Formatar Canais de TV (popups externos) (func)
- (void) formatar:(UIView *)canalDeTV hidden:(BOOL)hidden{
    
    CGFloat cornerRadius = 2.0;
    canalDeTV.center = _tamanhoDaTVref.center;
    
    [self.view  addSubview: canalDeTV];
    canalDeTV.layer.cornerRadius = cornerRadius;
    
    if (hidden) {
        canalDeTV.hidden = YES;
    } else {
        canalDeTV.hidden = NO;
    }
}






- (IBAction)pularFeedback:(id)sender {
    [popupFeed dismiss:YES];
    [self SetarTurno];
}
@end
