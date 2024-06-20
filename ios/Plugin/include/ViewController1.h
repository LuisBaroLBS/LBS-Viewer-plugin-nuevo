//
//  ViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 02/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Cordova/CDVViewController.h>
#import <sqlite3.h>
#import <Capacitor/CAPPlugin.h>
#import <Capacitor/CAPBridgedPlugin.h>
#import <WebKit/WebKit.h>
#import <Capacitor/Capacitor.h>
#import <Capacitor/CAPInstanceConfiguration.h>



//@interface ViewController : CDVViewController{
@interface ViewController : UIViewController <UIGestureRecognizerDelegate, WKNavigationDelegate>{
     NSString *idLibro;
     NSString *idApp;
     NSString *idTokenLBS;
     NSString *colorRayado;
     NSString *ImagenID;
    
    
    //tipoPanel 1=Player,0=PanelProfesor
    //global variable goes here
    int MainOpen,RayarActivo,SubrayarActivo,BorrarActivo,TapActivo,ColoresRayarActivo,ColorSubRayarActivo,FavoritosActivo,CamaraActivo,EjerciciosActivo,BorrarRayarActivo,PanelOpen,PresionarBotonPanel,PlayerOpen,PresionarBotonPlayer,tipoPanel;
    
    IBOutlet UILabel     *LblTest;
    IBOutlet UIButton    *FabMain;
    IBOutlet UIButton    *FabSeparador;
    IBOutlet UIButton    *FabFavoritos;
    IBOutlet UIButton    *FabIndice;
    IBOutlet UIButton    *FabNotas;
    IBOutlet UIButton    *FabRayar;
    IBOutlet UIButton    *FabSubrayar;
    IBOutlet UIButton    *FabUndo;
    IBOutlet UIButton    *FabLimpiar;
    IBOutlet UIButton    *FabCerrarRayar;
    IBOutlet UIButton    *FabBorrar;
    IBOutlet UIButton    *FabCerrarSubrayar;
    IBOutlet UIButton    *FabCerrarLibro;
    IBOutlet UIImageView *ImgCerrarLibro;
    
    /***Colores Rayado**/
    IBOutlet UIButton    *FabColorRayar;
    IBOutlet UIButton    *FabColorRayarBlack;
    IBOutlet UIButton    *FabColorRayarRed;
    IBOutlet UIButton    *FabColorRayarYellow;
    IBOutlet UIButton    *FabColorRayarGreen;
    IBOutlet UIButton    *FabColorRayarPurple;
    IBOutlet UIButton    *FabColorRayarBlue;
    /******************/
    
    /***Colores Rayar Nuevos**/
    IBOutlet UIButton    *FabColorRayarRosa;
    IBOutlet UIButton    *FabColorRayarCafe;
    IBOutlet UIButton    *FabColorRayarNaranja;
    /******************/
    
    /***Colores Subryado**/
    IBOutlet UIButton    *FabColorSubRayar;
    IBOutlet UIButton    *FabColorSubRayarYellow;
    IBOutlet UIButton    *FabColorSubRayarBlue;
    IBOutlet UIButton    *FabColorSubRayarPink;
    /*********************/
    
    /***Indicador #Pagina***/
    IBOutlet UIButton    *FabNumPagina;
    /***********************/
    
    /*****Camara********/
    IBOutlet UIButton    *FabCamara;
    IBOutlet UIButton    *FabAlbum;
    IBOutlet UIButton    *FabToolCamara;
    IBOutlet UIButton    *FabCerrarCamara;
    /******************/
    
    /****Ejercicios***/
    IBOutlet UIButton    *FabEjercicios;
    /*****************/
    
    IBOutlet UIButton *FabTamanoLienzo;
    IBOutlet UIButton *FabCandando;
    IBOutlet UIButton *FabCandadoEscribir;
}

//@property(strong,nonatomic) WKWebView *webView;
//@property(strong,nonatomic) CDVViewController *viewController;
//@property (retain, nonatomic) CDVViewController *viewController;
@property (strong, nonatomic) CAPBridgeViewController *CapViewController;
//@property (strong, nonatomic,assign) NSString *productURL;
@property (nonatomic, readwrite,assign) NSString *App;
@property (nonatomic, readwrite,assign) NSString *TokenLBS;
@property (nonatomic, readwrite,assign) NSString *productURL;
@property (nonatomic, readwrite,assign) NSString *LibroId;
@property (nonatomic, readwrite,assign) NSString *HojaActual;
@property (nonatomic, readwrite,assign) NSInteger TotalPaginas;
@property (nonatomic, readwrite,assign) NSString *DatosNota;
@property (nonatomic, readwrite,strong) NSArray *Indice;
@property (nonatomic, readwrite,strong) NSArray *ImagenesGaleria;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *db;

@property (weak, nonatomic) IBOutlet UISlider *Slider;
- (IBAction)endTouch:(id)sender;

- (IBAction)sliderChanged:(id)sender;

-(IBAction)Click:(id)sender;

-(IBAction)ClickSeparador:(id)sender;

-(IBAction)ClickFavoritos:(id)sender;

-(IBAction)ClickIndice:(id)sender;

-(IBAction)ClickNotas:(id)sender;

-(IBAction)ClickRayar:(id)sender;

-(IBAction)ClickUndo:(id)sender;

-(IBAction)ClickLimpiar:(id)sender;

-(IBAction)ClickCerrarRayar:(id)sender;

-(IBAction)ClickSubrayar:(id)sender;

-(IBAction)ClickBorrar:(id)sender;

-(IBAction)ClickCerrarSubrayar:(id)sender;

-(IBAction)ClickCerrarLibro:(id)sender;

-(IBAction)ClickPaginasLibro:(id)sender;

- (IBAction)ClickCandado:(id)sender;

- (IBAction)ClickCandadoEscribir:(id)sender;

- (void)ActivarTap;

- (void)mostrarBotonPanelMaestro: estado;

- (void)CambioHoja;

-(void)AbrirNota;

-(void)AbrirIndice;

- (void) saveData : insertSQL;

- (void) dibujarEscribir : Ejercicio;

- (void) TomarFoto : IdImagen;

- (void) EliminarFoto : IdImagen;

- (void) cambiarCandado : estado;

- (void) openPlayer;

-(void)AbrirGaleria;

-(void)FabsHandlerOpen;

-(void)FabsHandlerClose:tipoCerrar;

-(void)setIsTeacherBook:isTeacherBookVar;

- (void)pageDidLoad;

/***Colores Rayado**/
-(IBAction)ClickColorRayar:(id)sender;
-(IBAction)ClickColorRayarBlack:(id)sender;
-(IBAction)ClickColorRayarRed:(id)sender;
-(IBAction)ClickColorRayarYellow:(id)sender;
-(IBAction)ClickColorRayarGreen:(id)sender;
-(IBAction)ClickColorRayarPurple:(id)sender;
-(IBAction)ClickColorRayarBlue:(id)sender;
/**************/

/***Colores Rayado Nuevo**/
-(IBAction)ClickColorRayarRosa:(id)sender;
-(IBAction)ClickColorRayarCafe:(id)sender;
-(IBAction)ClickColorRayarNaranja:(id)sender;
/**************/


/***Colores SubRayado**/
-(IBAction)ClickColorSubRayar:(id)sender;
-(IBAction)ClickColorSubRayarYellow:(id)sender;
-(IBAction)ClickColorSubRayarBlue:(id)sender;
-(IBAction)ClickColorSubRayarPink:(id)sender;
/**************/

/*****Camara********/
-(IBAction)ClickCamara:(id)sender;
-(IBAction)ClickAlbum:(id)sender;
-(IBAction)ClickToolCamara:(id)sender;
-(IBAction)ClickCerrarCamara:(id)sender;
/******************/

/****Ejercicios***/
-(IBAction)ClickEjercicios:(id)sender;
/*****************/

/****Tamaño lienzo****/
- (IBAction)ClickTamanoLienzo:(id)sender;
@end


