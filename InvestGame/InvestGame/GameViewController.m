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
    _mercadoView.hidden = YES;
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
        montante = montante + [jogadores[i].carteira TotalvalorMercadoCripto:mercadoCripto.valorHoje eValorMercadoAcao:mercadoAcao.valorHoje eFixo:mercadoFixo.valorHoje];
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
    noticias = [NSMutableArray arrayWithObjects: [[Noticia alloc]initNoticiacomTexto:@"De acordo com o autor da pesquisa, gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália" comTitulo:@"Criptomoedas consomem 1% da energia elétrica do mundo, diz estudo." comOfertaMax:5 comOfertaMin:1 comDemandaMax:5 eComDemandaMin:1 tipo:@"Cripto"] , [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                            Ex-craque do Real Madrid irá lançar a APC (Arquimedinho Soccer Coin), e a venda privada dos tokens já teve início." comTitulo: @"Arquimedinho Paulista vai lançar sua própria criptomoeda." comOfertaMax:100 comOfertaMin:50 comDemandaMax:300 eComDemandaMin:20 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Damian colocou à venda no início do mês um lote de 6k de criptos, enviando o preço para abaixo de CC 10.000. O mercado conseguiu se recuperar e voltar à faixa de CC 16.000 hoje, quando o investidor colocou mais um lote à venda, dessa vez de 8k de criptos." comTitulo:@"Portoriquenho derruba preço da bitcoin." comOfertaMax:65 comOfertaMin:50 comDemandaMax:20 eComDemandaMin:10 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"Depois de operar em alta nos últimos 6 dias, o mercado de criptomoedas adicionou CC 34 bilhões ao seu valor, a Criptocoin apresentou um pequeno recuo puxando várias outras moedas para baixo. Ela caiu 3%, enquanto outras moedas apresentaram quedas entre 5% a 10%. O volume de negociações da Criptocoin caiu para US$ 4 bilhões, após ter se mantido acima dos US$ 5,3 bilhões até 20 de agosto." comTitulo:@"" comOfertaMax:10 comOfertaMin:0 comDemandaMax:50 eComDemandaMin:12 tipo:@"Cripto"] , [[Noticia alloc]initNoticiacomTexto:@"O estado considera a criptocoin a partir de hoje como o equivalente a uma moeda legal para fins fiscais" comTitulo:@"Pernambuco legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:42 comOfertaMin:20 comDemandaMax:28 eComDemandaMin:25 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O continente considera a criptocoin a partir deste mês como o equivalente a uma moeda legal para fins fiscais quando usada como meio de pagamento" comTitulo:@"União Europeia legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:100 comOfertaMin:40 comDemandaMax:300 eComDemandaMin:20 tipo:@"Cripto"], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:100 eComDemandaMin:30 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"De acordo com um especialista, os cidadãos chineses ricos investiram seu dinheiro em bitcoin para se preparar para uma desvalorização maciça na moeda que, temia-se, poderia acabar com a economia da vida." comTitulo:@"Criptocoin tem subida de preço com a guerra cambial entre China e EUA." comOfertaMax:4 comOfertaMin:2 comDemandaMax:50 eComDemandaMin:20 tipo:@"Cripto"],[[Noticia alloc]initNoticiacomTexto:@"Semview venceu Fox em leilão pela aquisição do grupo de televisão, Ava, com proposta de CC 39 bilhões.a." comTitulo:@"Grupo Orange dispara na bolsa após oferta da Semview." comOfertaMax:10 comOfertaMin:5 comDemandaMax:100 eComDemandaMin:20 tipo:@"Ação"],[[Noticia alloc]initNoticiacomTexto:@"Empresa brasileira havia pedido registro do nome “Gay-me” no INPI em 2016. Um ano antes o “Gay-me” havia sido lançado nos EUA pela Mazes Games." comTitulo:@"Ações da Gayme caem 46% após derrota para a Mazes Games." comOfertaMax:100 comOfertaMin:30 comDemandaMax:2 eComDemandaMin:0 tipo:@"Ação"],
        [[Noticia alloc]initNoticiacomTexto:@"Ações da empresa fecharam o pregão de segunda-feira com alta de 14%, cotadas em CC 394. Com isso, o valor da gigante de aplicativos saltou para CC 994,5 trilhão e a empresa segue firme no caminho de ser a primeira da história a valer CC 1 quadrilhão." comTitulo:@"Ações da Orange batem novo recorde e empresa está próxima de ser a 1º a valer CC 1 quadrilhão." comOfertaMax:50 comOfertaMin:30 comDemandaMax:50 eComDemandaMin:30 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"Guerra comercial com a Ásia e críticas dos governos à Orange derrubam os mercados." comTitulo:@"Ações europeias estão a caminho de ter o pior início de trimestre desde a Segunda Guerra Mundial." comOfertaMax:40 comOfertaMin:10 comDemandaMax:50 eComDemandaMin:40 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"A Orange se tornou nesta quinta-feira (31) a primeira empresa com ações na Bolsa de Nova York (EUA) a ultrapassar a marca de CC 1 quadrilhão em valor de mercado. O feito foi atingido agora." comTitulo:@"1º a passar de CC 1 quadri nos EUA, Orange vale mais que a Bolsa americana." comOfertaMax:50 comOfertaMin:30 comDemandaMax:50 eComDemandaMin:30 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"Primeiro, você precisa abrir uma conta em uma corretora e transferir o dinheiro. Ao entrar ali, você terá acesso a diversas bolsas. Além de ações, o próprio home-broker, lhe permite investir em ETF ou títulos de renda fixa. Claro que irá depender da corretora em questão. Cada mercado, ten as ações negociadas em código (ticker), cada um representando a ação de uma determinada empresa. Esse código pode ser uma sigla, um número ou uma combinação de ambos. As ações da Orange, negociadas na ADasdaq, possuem o ticker WAMON e as ações da Gayme, negociadas na bolsa de Nova Iorque (NYSE) possuem o ticker RANDER. Já na bolsa de Hong Kong, os tickers são números, como por exemplo as ações da Orange Mobile, negociadas sob o código 1522. " comTitulo:@"Investir em ações no exterior é bem semelhante a investir no Brasil." comOfertaMax:41 comOfertaMin:40 comDemandaMax:41 eComDemandaMin:40 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"A Lira apresentou nesta terça-feira (17) uma corretora de valores para atrair pessoas que querem investir em ações, mas ainda não sabem como fazer isso. A fintech, que recebeu investimentos de R$ 46 milhões, oferece uma interface simplificada para operar na bolsa e um modelo de negócios em que o cliente só paga se lucrar com a operação." comTitulo:@"Lira é uma corretora para quem ainda não sabe investir em ações." comOfertaMax:21 comOfertaMin:20 comDemandaMax:21 eComDemandaMin:20 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"Taxas de crescimento da Orange (em milhões): Vendas em 2016 - 170,910.00; Vendas em 2017 - 233,715.00; Vendas em 2018 - 229,234.00. Growth rates: 7.62." comTitulo:@"" comOfertaMax:40 comOfertaMin:30 comDemandaMax:43 eComDemandaMin:40 tipo:@"Ação"], [[Noticia alloc]initNoticiacomTexto:@"Os valores dos rendimentos serão dos investimentos no Tesouro Direto, conforme as taxas do Banco Central. Esse valor poderá ser repassado pelo Yesbank aos clientes em uma taxa de 1000% do CDI (Certificado de Deposito Interbancário). A novidade é que os valores da conta poderão ser aplicados no Tesouro Direto, com rendimentos diários, em taxas pelo CDI ." comTitulo:@"Yesbank cria conta para clientes aplicarem no Tesouro Direto" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Não é preciso depender do resultado da próxima eleição para faturar. Títulos indexados na inflação pagam bem, mesmo com a Selic em 6,5% ao ano. Às vésperas da eleição, o vai e vem do dólar e da Bolsa assusta. A paga não compensa o risco de investir em aplicações como os multimercados, que até pouco tempo atrás eram alvo dos investidores. Agora, é bom colocar o pé no freio e voltar para o velho e bom Tesouro Direto ou para CDBs e LCIs, segundo especialistas da FGV." comTitulo:@"Perto de eleições, investir em Tesouro Direto volta a ser atrativo." comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Isenção foi usada por corretoras independentes para atrair clientes que mantinha investimento em bancos." comTitulo:@"Banco Parnamirim adota benefício de XP a clientes e zera taxa do Tesouro Direto" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Turbulência nos mercados mundiais derrubaram o preço e elevou a rentabilidade dos papeis do Tesouro, levando o governo à uma interrupção temporária das negociações.O caos do mercado não afeta só o dólar e Bolsa, mas também as taxas dos títulos públicos. O Tesouro Direto, programa do governo de compra e venda de títulos, foi suspenso na manhã desta quarta-feira. De acordo com o órgão, a suspensão, iniciada às 10h50, deve ir até as 16h30 e ocorre devido à volatilidade nas taxas de juros públicos. Incialmente, a negociação ficaria suspensa até as 18h." comTitulo:@"Com volatilidade, Tesouro Direto cancela as negociações de títulos públicos." comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Segundo dados do Tesouro Nacional, desde agosto de 2018, os investidores têm mais resgatado do que aplicado em títulos na plataforma Tesouro Direto. Três razões explicam esse movimento dos investidores. Entretanto, o que parece ser algo ruim, na verdade é uma oportunidade que está sendo desperdiçada." comTitulo:@"" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Conheça o Tesouro Direto: ""O Tesouro Direto é um Programa do Tesouro Nacional desenvolvido em parceria com a BM&F Bovespa para venda de títulos públicos federais para pessoas físicas, por meio da internet." comTitulo:@"" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Conheça os Títulos Públicos: Os títulos públicos são ativos de renda fixa, ou seja, seu rendimento pode ser dimensionado no momento do investimento, ao contrário dos ativos de renda variável (como ações), cujo retorno não pode ser estimado no instante da aplicação. Dada a menor volatilidade dos ativos de renda fixa frente aos ativos de renda variável, este tipo de investimento é considerado mais conservador, ou seja, de menor risco. Ao comprar um título público, você empresta dinheiro para o governo brasileiro em troca do direito de receber no futuro uma remuneração por este empréstimo, ou seja, você receberá o que emprestou mais os juros sobre esse empréstimo. Dessa maneira, com o Tesouro Direto, você não somente se beneficia de uma alternativa de aplicação financeira segura e rentável, como também ajuda o país a promover seus investimentos em saúde, educação, infraestrutura, entre outros, indispensáveis ao desenvolvimento do Brasil." comTitulo:@"" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"], [[Noticia alloc]initNoticiacomTexto:@"Conheça a Renda Fixa: Renda fixa é um termo que se refere a qualquer tipo de investimento que possui regras de remuneração definidas no momento da aplicação no título.[1] Essas regras estipulam o prazo e a forma que a remuneração será calculada e paga ao investidor.Nesse tipo de investimento, o investidor concede um empréstimo, usualmente em dinheiro, a uma entidade em troca do pagamento de juros. Dessa forma a entidade, geralmente uma instituição financeira, emite um documento onde ela se compromete a devolver o dinheiro emprestado acrescido de juros após um período preestabelecido." comTitulo:@"" comOfertaMax:0 comOfertaMin:0 comDemandaMax:0 eComDemandaMin:0 tipo:@"Fixo"],        nil];
    
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
        _mercadoView.hidden = YES;
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
        estadoTV = estadoTV + 1;
    }
    else if(estadoTV == 3){
        _mercadoView.hidden = NO;
        _admView.hidden = YES;
        estadoTV = 0;
         NSString *valorCriptoTexto =  [NSString stringWithFormat:@"%0.2lf",mercadoCripto.valorHoje];
            NSString *valorAcaoTexto =  [NSString stringWithFormat:@"%0.2lf",mercadoAcao.valorHoje];
        _valorAcao.text = valorAcaoTexto;
        _valorCripto.text = valorCriptoTexto;
        if( mercadoCripto.oferta > mercadoCripto.demanda){
            _tendenciaCripto.text = @"Baixa";
            _tendenciaCripto.textColor = UIColor.redColor;
        }
        else{
            _tendenciaCripto.text = @"Alta";
            _tendenciaCripto.textColor = UIColor.greenColor;
        }
        if( mercadoAcao.oferta > mercadoAcao.demanda){
            _tendenciaAcao.text = @"Baixa";
            _tendenciaAcao.textColor = UIColor.redColor;
        }
        else{
            _tendenciaAcao.text = @"Alta";
            _tendenciaAcao.textColor = UIColor.greenColor;
        }
        float inicioDoCalculoCripto = mercadoCripto.valorHoje - mercadoCripto.valorOntem;
        inicioDoCalculoCripto = inicioDoCalculoCripto/mercadoCripto.valorOntem;
        NSString *variacaoCriptoTexto =  [NSString stringWithFormat:@"%0.2lf %%",inicioDoCalculoCripto];
        _variacaoCripto.text = variacaoCriptoTexto;
        float inicioDoCalculoAcao = mercadoAcao.valorHoje - mercadoAcao.valorOntem;
        inicioDoCalculoCripto = inicioDoCalculoCripto/mercadoAcao.valorOntem;
        NSString *variacaoAcaoTexto =  [NSString stringWithFormat:@"%0.2lf %%",inicioDoCalculoAcao];
        _variacaoACAO.text = variacaoAcaoTexto;
        
        NSString *variacaoFixoTexto =  [NSString stringWithFormat:@"%0.3lf %%", mercadoFixo.taxa];
        NSString *valorFixoTexto =  [NSString stringWithFormat:@"%0.3lf", mercadoFixo.valorHoje];
        _valorFixo.text = valorFixoTexto;
        _variacaoFixo.text = variacaoFixoTexto;
        
        
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
