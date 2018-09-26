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

#import "investimento.h"
#import "mercado.h"
#import "popupInvestir.h"
#import "Noticia.h"

#include <stdlib.h>
@implementation GameViewController
NSMutableArray<Jogador*>  *jogadores;
int estado = 0;
int estadoTV = 0;
int jogadorVez = 0;
Mercado* mercadoAcao;
Mercado* mercadoCripto;
NSMutableArray<Noticia*> *noticias;
NSInteger noticiaDaVez[2];
NSInteger noticiasPassadas[7];


- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    
    if (self == context.nextFocusedView) {
        [coordinator addCoordinatedAnimations:^{
            context.nextFocusedView.backgroundColor = [UIColor colorWithRed:66.0f/255.0f
                                                                      green:79.0f/255.0f
                                                                       blue:91.0f/255.0f
                                                                      alpha:1.0f] ;
        } completion:^{
            // completion
        }];
    } else if (self == context.previouslyFocusedView) {
        [coordinator addCoordinatedAnimations:^{
            context.nextFocusedView.backgroundColor = [UIColor colorWithRed:66.0f/255.0f
                                                                      green:79.0f/255.0f
                                                                       blue:91.0f/255.0f
                                                                      alpha:1.0f] ;
        } completion:^{
            // completion
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // inicio do sprite kit (importado no .h)
    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
//    
//    // Set the scale mode to scale to fit the window
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    SKView *skView = (SKView *)self.view;
//    
//    // Present the scene
//    [skView presentScene:scene];
//    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    
//    //criando Carteiras e jogadores.
    [self SetarNoticias];
    Carteira* carteiraInicio = [[Carteira alloc] initComSaldo:1000];
    
    Jogador* jogador1 = [[Jogador alloc] initComNome: _nomesJogadores[0] comPosicao:@"Vocalista" andCarteira: carteiraInicio];
     Jogador* jogador2 = [[Jogador alloc] initComNome: _nomesJogadores[1] comPosicao:@"Cavaco" andCarteira: carteiraInicio];
     Jogador* jogador3 = [[Jogador alloc] initComNome: _nomesJogadores[2] comPosicao:@"Pandeiro" andCarteira: carteiraInicio];
     Jogador* jogador4 = [[Jogador alloc] initComNome: _nomesJogadores[3] comPosicao:@"Percussão" andCarteira: carteiraInicio];
   jogadores = [NSMutableArray arrayWithObjects: jogador1, jogador2, jogador3, jogador4, nil];

    
    for(int i = 0; i < 4; i++) {
        NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", i,jogadores[i].nome, jogadores[i].posicao, jogadores[i].carteira.saldo);
    }
    
    //estabelecendo Mercados
    mercadoCripto = [[Mercado alloc] initMercadoComRisco:0.55 comOferta:500 eDemanda:500];
    mercadoAcao = [[Mercado alloc] initMercadoComRisco:0.25 comOferta:1000 eDemanda:1000];
    
    
    
    _noticiaLabel.text = @"Criptomoedas consomem 1% da energia elétrica do mundo, diz estudo. De acordo com o autor da pesquisa, gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália";
    [self SetarTurno];
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:recognizer];
}
//- (void)swipeRight:(UISwipeGestureRecognizer *)sender
//{
//    NSLog(@"It works");
//}

//varia toda a tela para o novo jeito
-(void)SetarTurno {
    if(estado == 0 ){
        _playerLabel.text = jogadores[0].nome;
        [self SetarNoticiasDaVez];
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        [self atualizarBarras];
    }
    else if(estado == 1){
        
    }
    else if(estado == 2){
        
    }
    
}
-(void)SetarNoticiasDaVez{
    BOOL escolhido1 = NO;
    BOOL escolhido2 = NO;
    int r;
    while(!(escolhido1 && escolhido2)){
        if(escolhido1 == NO){
            r = arc4random_uniform(6);
            if(noticiasPassadas[r] == 0){
                noticiaDaVez[0] = r;
                noticiasPassadas[r] = 1;
                escolhido1 = YES;
            }
        }
        else if(escolhido1 == YES && escolhido2 == NO){
            r = arc4random_uniform(6);
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
        montante = montante + jogadores[i].carteira.Total;
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
    for (NSInteger i = 0; i < 40; i++)
        noticiasPassadas[i] = 0;
    noticias = [NSMutableArray arrayWithObjects: [[Noticia alloc]initNoticiacomTexto:@"De acordo com o autor da pesquisa, gasto energético para produzir moedas virtuais poderão afetar metas climáticas. Consumo atual já é equivalente a um país como Itália" comTitulo:@"Criptomoedas consomem 1% da energia elétrica do mundo, diz estudo." comOfertaMax:450 comOfertaMin:400 comDemandaMax:300 eComDemandaMin:270], [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                            Ex-craque do Real Madrid irá lançar a APC (Arquimedinho Soccer Coin), e a venda privada dos tokens já teve início." comTitulo: @"Arquimedinho Paulista vai lançar sua própria criptomoeda." comOfertaMax:-400 comOfertaMin:-350 comDemandaMax:270 eComDemandaMin:250], [[Noticia alloc]initNoticiacomTexto:@"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Damian colocou à venda no início do mês um lote de 6k de criptos, enviando o preço para abaixo de CC 10.000. O mercado conseguiu se recuperar e voltar à faixa de CC 16.000 hoje, quando o investidor colocou mais um lote à venda, dessa vez de 8k de criptos." comTitulo:@"Portoriquenho derruba preço da bitcoin." comOfertaMax:400 comOfertaMin:350 comDemandaMax:270 eComDemandaMin:250],[[Noticia alloc]initNoticiacomTexto:@"Depois de operar em alta nos últimos 6 dias, o mercado de criptomoedas adicionou CC 34 bilhões ao seu valor, a Criptocoin apresentou um pequeno recuo puxando várias outras moedas para baixo. Ela caiu 3%, enquanto outras moedas apresentaram quedas entre 5% a 10%. O volume de negociações da Criptocoin caiu para US$ 4 bilhões, após ter se mantido acima dos US$ 5,3 bilhões até 20 de agosto." comTitulo:@"" comOfertaMax:450 comOfertaMin:400 comDemandaMax:250 eComDemandaMin:12] , [[Noticia alloc]initNoticiacomTexto:@"O estado considera a criptocoin a partir de hoje como o equivalente a uma moeda legal para fins fiscais" comTitulo:@"Pernambuco legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:420 comOfertaMin:400 comDemandaMax:280 eComDemandaMin:250], [[Noticia alloc]initNoticiacomTexto:@"O continente considera a criptocoin a partir deste mês como o equivalente a uma moeda legal para fins fiscais quando usada como meio de pagamento" comTitulo:@"União Europeia legaliza criptomoedas e reconhece a criptocoin como meio de pagamento" comOfertaMax:420 comOfertaMin:40 comDemandaMax:30000 eComDemandaMin:300], [[Noticia alloc]initNoticiacomTexto:@"O grupo suíço de gestão de investimentos começou a mostrar interesse pelo mercado de criptomoedas. A Orange, a maior e mais importante empresa de gestão de ações do mundo, formou um escritório com objetivo de procurar integrar criptomoedas em seus negócios" comTitulo:@"Preço da Criptocoin sobe após interesse da Orange pelas criptomoedas" comOfertaMax:400 comOfertaMin:100 comDemandaMax:900 eComDemandaMin:300],  nil];
    
}

- (IBAction)buttonOne:(id)sender {
    int valor = estado % 4;
    int quantidadeDeAtivo = 100/mercadoCripto.valorHoje;
    
    [jogadores[valor].carteira comprarInvestimento: [[Investimento alloc]initComTipo:@"Cripto" comValor: 100 eQuantidade:quantidadeDeAtivo]];
    
     NSLog(@"jogador%d nome:%@ posicao:%@ saldo: %lf", valor,jogadores[valor].nome, jogadores[valor].posicao, jogadores[valor].carteira.saldo);
//    PopupInvestir *child =[[PopupInvestir alloc] init];
//    [self addChildViewController:child];
//    child.view.frame = self.view.frame;
//    [self.view addSubview:child.view];
//    child.view.alpha = 0;
//    [child didMoveToParentViewController:self];
//    [UIView animateWithDuration:0.25 delay:0.0  options: UIViewAnimationOptionCurveEaseIn animations:^{
//        child.view.alpha = 1;
//    } completion:nil];
//   PopupInvestir *child =[[PopupInvestir alloc] init];
//    child.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
//    child.modalPresentationStyle = 17;
//    [self presentViewController:child animated:YES completion:nil];
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)proximo:(id)sender {
    if(estadoTV < 1 ){
        _mancheteLabel.text = noticias[noticiaDaVez[1]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[1]].texto;
        estadoTV = estadoTV + 1;
    }
    else if(estadoTV == 1){
        _mancheteLabel.text = noticias[noticiaDaVez[0]].titulo;
        _noticiaLabel.text = noticias[noticiaDaVez[0]].texto;
        estadoTV = 0;
    }
}
@end
