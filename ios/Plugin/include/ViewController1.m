//
//  ViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 02/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "ViewController1.h"
#import "NotificationViewController.h"
#import "IndiceViewController.h"
#import "GaleriaViewController.h"
#import "PaginasViewController.h"
#import <WebKit/WebKit.h>
#import <Cordova/CDVViewController.h>
#import <sqlite3.h>
#import <Capacitor/Capacitor.h>
#import <Capacitor/Capacitor-Swift.h>
#import <Capacitor/CAPBridgedPlugin.h>
#import <Capacitor/CAPBridgedJSTypes.h>

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface ViewController () 

@end

@implementation ViewController
UITapGestureRecognizer *tap;
NSString *FotoEjercicio;
NSNumber *isTeacherBookBtnsNativos = 0;

-(void)CambioHoja{
    [FabNumPagina setTitle:_HojaActual forState:UIControlStateNormal];
    //[self dibujarEscribir:_HojaActual];
}
-(void)ActivarTap{
    tap.enabled=true;
    TapActivo=0;
    FavoritosActivo=0;
}
-(void)mostrarBotonPanelMaestro : estado {
    if([estado isEqualToString:@""])
    {
        [FabCandando setImage:[UIImage imageNamed:@"CandadoCerrado.png"] forState:UIControlStateNormal];
        tipoPanel = 0;
    } else {
        [FabCandando setImage:[UIImage imageNamed:@"headphones.png"] forState:UIControlStateNormal];
        tipoPanel = 1;
    }
    
    FabCandando.hidden=false;
}
-(void)ValidarBotones : Opcion{
    if(![Opcion isEqualToString:@"Rayar"] && RayarActivo==1)
    {
        [FabCerrarRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    if(![Opcion isEqualToString:@"Subrayar"] && SubrayarActivo==1)
    {
        [FabCerrarSubrayar sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    if(![Opcion isEqualToString:@"CamaraTools"] && CamaraActivo==1)
    {
        [FabCerrarCamara sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    if(![Opcion isEqualToString:@"Favoritos"] && FavoritosActivo==1)
    {
        [self FavoritosDesactivar];
    }
}
-(void)FavoritosDesactivar{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    
    tap.enabled= tap.isEnabled==true ? false : true;
    if(FavoritosActivo==0)
    {
        //tap.enabled=false;
        FavoritosActivo=1;
        [uiWebView evaluateJavaScript:@"document.getElementById('left').style.visibility=null" completionHandler:nil];
    }
    else
    {
        //tap.enabled=true;
        FavoritosActivo=0;
        [uiWebView evaluateJavaScript:@"document.getElementById('left').style.visibility='hidden'" completionHandler:nil];
    }
    
    
    [uiWebView evaluateJavaScript:@"document.getElementById('btnListaSeperadores').click()" completionHandler:nil];
    //[FabMain sendActionsForControlEvents: UIControlEventTouchUpInside];
    NSLog(@"url = %@", @"BtnFavoritos");
}
-(IBAction)Click:(id)sender{
    
    NSLog(@"url = %@", @"BtnMain");
    
    if(MainOpen==0)
    {
        /*
         Si es libro de teacher y el sender(no es nulo) no abre el toast
         */
        if([isTeacherBookBtnsNativos intValue] == 1 ) {
            if(sender != NULL) {
            WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;

            [uiWebView evaluateJavaScript:@"Visor.toastHandler('show', 'Este libro es de solo lectura.', 400); setTimeout(function(){ Visor.toastHandler('hide',' ', 400); }, 3000);" completionHandler:nil];
            }
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        FabMain.transform = CGAffineTransformMakeRotation(2.33);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.4 animations:^{
            /*for (UIButton *button in self.view.subviews) {
             button.hidden=false;
             }*/
            
            FabSeparador.hidden=false;
            FabFavoritos.hidden=false;
            FabIndice.hidden=false;
            FabNotas.hidden=false;
            FabRayar.hidden=false;
            FabSubrayar.hidden=false;
            FabToolCamara.hidden=false;
            
            FabSeparador.frame = CGRectOffset(FabSeparador.frame, 0, -55);
            FabFavoritos.frame = CGRectOffset(FabFavoritos.frame, 0, -110);
            FabIndice.frame = CGRectOffset(FabIndice.frame, 0, -165);
            FabNotas.frame = CGRectOffset(FabNotas.frame, 0, -220);
            FabRayar.frame = CGRectOffset(FabRayar.frame, 0, -275);
            FabSubrayar.frame = CGRectOffset(FabSubrayar.frame, 0, -330);
            /******Camara****/
            FabToolCamara.frame = CGRectOffset(FabToolCamara.frame,0, -385);
            /************************/
            
            FabNumPagina.frame=CGRectOffset(FabNumPagina.frame, 0, -385);
            FabCerrarLibro.frame= CGRectOffset(FabCerrarLibro.frame, 0, -385);
        }];
        
        MainOpen=1;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        FabMain.transform = CGAffineTransformMakeRotation(0);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.4 animations:^{
            FabSeparador.frame = CGRectOffset(FabSeparador.frame, 0, 55);
            FabFavoritos.frame = CGRectOffset(FabFavoritos.frame, 0, 110);
            FabIndice.frame = CGRectOffset(FabIndice.frame, 0, 165);
            FabNotas.frame = CGRectOffset(FabNotas.frame, 0, 220);
            FabRayar.frame = CGRectOffset(FabRayar.frame, 0, 275);
            FabSubrayar.frame = CGRectOffset(FabSubrayar.frame, 0, 330);
            /******Camara****/
            FabToolCamara.frame    = CGRectOffset(FabToolCamara.frame,0, 385);
            /************************/
            
            FabNumPagina.frame=CGRectOffset(FabNumPagina.frame, 0, 385);
            FabCerrarLibro.frame= CGRectOffset(FabCerrarLibro.frame, 0, 385);
        }completion:^(BOOL finished) {
            //code for completion
            FabSeparador.hidden=true;
            FabFavoritos.hidden=true;
            FabIndice.hidden=true;
            FabNotas.hidden=true;
            FabRayar.hidden=true;
            FabSubrayar.hidden=true;
            FabToolCamara.hidden=true;
        }];
        MainOpen=0;
        
    }
    
}

-(IBAction)ClickSeparador:(id)sender{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    [self ValidarBotones:@"Separador"];
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSString *script = [NSString stringWithFormat:@"Visor.dibujarSeparador(%@)", _HojaActual];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    
    NSLog(@"url = %@", @"BtnSeparador");
}
-(IBAction)ClickFavoritos:(id)sender{
    
    [self ValidarBotones:@"Favoritos"];
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    
    //[uiWebView evaluateJavaScript:@"document.getElementById('btnListaSeperadores').click()" completionHandler:nil];
    NSString *script = [NSString stringWithFormat:@"Visor.mostrarNotasYFavoritosList()"];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    [FabMain sendActionsForControlEvents: UIControlEventTouchUpInside];
    NSLog(@"url = %@", @"BtnFavoritos");
}
-(IBAction)ClickIndice:(id)sender{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
      [self ValidarBotones:@"Indice"];
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //[uiWebView evaluateJavaScript:@"document.getElementById('btnIndice').click()" completionHandler:nil];
    [uiWebView evaluateJavaScript:@"Visor.mostrarIndiceTitulos()" completionHandler:nil];
    NSLog(@"url = %@", @"BtnFavoritos");
}
-(IBAction)ClickPaginasLibro:(id)sender{
    if(SubrayarActivo==1 || RayarActivo==1) return;
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //Desactiva el pinch zoom
    NSString *script= @"Visor.mostrarIndicePaginas();";
    [uiWebView evaluateJavaScript:script completionHandler:nil];
}
-(IBAction)ClickNotas:(id)sender{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    [self ValidarBotones:@"Notas"];
       NSLog(@"url = %@", @"BtnNotas");
    
    tap.enabled= tap.isEnabled==true ? false : true;

    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //Desactiva el pinch zoom
    NSString *script=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=no')";
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    
    //NSString *scriptJs=@"Visor.ActivarNotaDinamica();";
    NSString *scriptJs=@"Visor.mostrarNotaV2();";
    [uiWebView evaluateJavaScript:scriptJs completionHandler:nil];
    /*
    // Create a UIView to contain the toast message
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 90)];
    toastView.backgroundColor = [UIColor blackColor];
    toastView.alpha = 0.7;
    toastView.layer.cornerRadius = 10;

    // Calculate the position to display the toast at the top
    CGFloat toastX = (self.view.frame.size.width - toastView.frame.size.width) / 2;
    CGFloat toastY = 40;
    toastView.frame = CGRectMake(toastX, toastY, toastView.frame.size.width, toastView.frame.size.height);

    // Create a UILabel to display the toast message
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, toastView.frame.size.width, toastView.frame.size.height)];
    toastLabel.text = @"Presiona en la parte de la pantalla donde quieres colocar la nota";
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.numberOfLines = 0; // Set to 0 for multiple lines
    [toastView addSubview:toastLabel];

    // Add the toast view to the main view
    [self.view addSubview:toastView];

    // Animate the toast view fading in and out
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toastView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];

     */
    
    
    //[uiWebView evaluateJavaScript:@"document.getElementById('btnNota').click()" completionHandler:nil];

}
-(IBAction)ClickRayar:(id)sender{
    NSLog(@"RayarActivo = %i", RayarActivo);
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    //if(SubrayarActivo==1) return;
    [self ValidarBotones:@"Rayar"];
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    
    [FabTamanoLienzo setTitle: @"1.0" forState:UIControlStateNormal];
    self.Slider.value=1.0;
    
    NSString *script = [NSString stringWithFormat:@"Visor.handleTamanoLienzo(%.1f)",_Slider.value];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    
    if(RayarActivo==0)
    {
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['-webkit-overflow-scrolling']='auto';" completionHandler:nil];
        
        //[uiWebView evaluateJavaScript:@"document.getElementById('BtnColor').style['background-color']='black';" completionHandler:nil];
        //Bloquea la hoja actual de trabajo
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['touch-action']  = 'none';" completionHandler:nil];
        
        [FabRayar setImage:[UIImage imageNamed:@"rayar_activo.png"] forState:UIControlStateNormal];
        
        FabTamanoLienzo.hidden =false;
        FabColorRayar.hidden =false;
        FabUndo.hidden       =false;
        FabLimpiar.hidden    =false;
        FabCerrarRayar.hidden=false;
        
        NSInteger inicio;
        NSInteger fin;
        
        NSInteger PaginaActual=[_HojaActual integerValue];
        if(PaginaActual>=1 && PaginaActual < _TotalPaginas){
            inicio = PaginaActual == 1 ? PaginaActual : PaginaActual-1;
            fin   = PaginaActual == 1 ?  PaginaActual + 1 : PaginaActual+1;
        }
        else{
            inicio = PaginaActual -1;
            fin    = PaginaActual;
        }
        
        if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
        {
            for (NSInteger i = inicio; i <= fin; i++)
            {
         
                NSString *querySQL = [NSString stringWithFormat:
                                      @"SELECT DATA FROM RAYADO WHERE LIBROID=\"%@\" AND HOJA=\"%ld\"",
                                      _LibroId,(long)i];
            
                const char *query_stmt = [querySQL UTF8String];
            
                if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *data = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 0)];
                        NSString *script = [NSString stringWithFormat:@"Visor.ActivarRayado('%@',%ld)",data,(long)i];
                        [uiWebView evaluateJavaScript:script completionHandler:nil];
                    }
                    else
                    {
                        //dibujarRayado
                        NSString *script = [NSString stringWithFormat:@"Visor.dibujarRayado(%ld,null)",(long)i];
                        [uiWebView evaluateJavaScript:script completionHandler:nil];
                    }
                    sqlite3_finalize(statement);
                }
            }
        }
        sqlite3_close(_db);
        
        [FabMain sendActionsForControlEvents: UIControlEventTouchUpInside];
        RayarActivo=1;
    }
    else{
        
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['-webkit-overflow-scrolling']=null;" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"Visor.DesactivarRayado();" completionHandler:nil];
        [FabRayar setImage:[UIImage imageNamed:@"rayar.png"] forState:UIControlStateNormal];
        
        FabColorRayar.hidden =true;
        FabUndo.hidden       =true;
        FabLimpiar.hidden    =true;
        FabCerrarRayar.hidden=true;
        FabTamanoLienzo.hidden=true;
        
        FabColorRayar.backgroundColor=[UIColor blackColor];
        colorRayado=@"black";
        [FabUndo  setImage:[UIImage imageNamed:@"BorradorBlanco.png"] forState:UIControlStateNormal];
        
        self.Slider.hidden=true;
        
        RayarActivo=0;
    }
    
    //[uiWebView evaluateJavaScript:@"document.getElementById('btnMarcar').click()" completionHandler:nil];
    NSLog(@"url = %@", @"BtnFavoritos");
}
/****Herramientas Rayar******/
-(IBAction)ClickUndo:(id)sender{
    NSLog(@"Undo = %i", RayarActivo);
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSLog(@"url = %@", @"BtnFavoritos");
    
    if(BorrarRayarActivo==0)
    {
        [FabUndo  setImage:[UIImage imageNamed:@"BorradorNegro.png"] forState:UIControlStateNormal];
        
        [uiWebView evaluateJavaScript:@"Visor.handleUndo()" completionHandler:nil];
        BorrarRayarActivo=1;
    }
    else
    {
        [FabUndo  setImage:[UIImage imageNamed:@"BorradorBlanco.png"] forState:UIControlStateNormal];
        
        NSString *script = [NSString stringWithFormat:@"Visor.handleColorRayado('%@')",colorRayado];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
        
        NSString *script2 = [NSString stringWithFormat:@"Visor.handleTamanoLienzo(%.1f)",_Slider.value];
        [uiWebView evaluateJavaScript:script2 completionHandler:nil];
        BorrarRayarActivo=0;
    }
}
-(IBAction)ClickLimpiar:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //[uiWebView evaluateJavaScript:@"document.getElementById('BtnClear').click()" completionHandler:nil];
    [uiWebView evaluateJavaScript:@"Visor.handleClear()" completionHandler:nil];
    NSLog(@"url = %@", @"BtnFavoritos");
}
-(IBAction)ClickCerrarRayar:(id)sender{
    FabColorRayar.backgroundColor=[UIColor blackColor];
    
    if(FabColorRayarBlack.isHidden==false)
        [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
    [FabRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/*****************************/
-(IBAction)ClickSubrayar:(id)sender{
    //if(RayarActivo==1) return;
    [self ValidarBotones:@"Subrayar"];

    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    
    if(SubrayarActivo==0)
    {
        //uiWebView.scrollView.scrollEnabled=false;
        //uiWebView.scrollView.pinchGestureRecognizer.enabled=false;
        //uiWebView = false
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['-webkit-overflow-scrolling']='auto';" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"document.ontouchmove = function(e){ e.preventDefault(); }" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['-webkit-overflow-scrolling']='auto';" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"document.ontouchmove = function(e){ e.preventDefault(); }" completionHandler:nil];

        [FabMain sendActionsForControlEvents: UIControlEventTouchUpInside];
        [FabSubrayar setImage:[UIImage imageNamed:@"subrayar_activo.png"] forState:UIControlStateNormal];
        
        FabBorrar.hidden=false;
        FabCerrarSubrayar.hidden=false;
        FabColorSubRayar.hidden =false;
        
        NSInteger inicio;
        NSInteger fin;
        
        NSInteger PaginaActual=[_HojaActual integerValue];
        if(PaginaActual>=1 && PaginaActual < _TotalPaginas){
            inicio = PaginaActual == 1 ? PaginaActual : PaginaActual-1;
            fin   = PaginaActual == 1 ?  PaginaActual + 1 : PaginaActual+1;
        }
        else{
            inicio = PaginaActual -1;
            fin    = PaginaActual;
        }
        
   
        for (NSInteger i = inicio; i <= fin; i++)
        {
    
            //dibujarSubrayado
            NSString *script = [NSString stringWithFormat:@"Visor.ActivarSubrayado(%ld)",(long)i];
            [uiWebView evaluateJavaScript:script completionHandler:nil];
       
        }
   
        
        SubrayarActivo=1;
    }
    else
    {
       //uiWebView.scrollView.scrollEnabled=true;
        
        [uiWebView evaluateJavaScript:@"document.getElementById('idrviewer').style['-webkit-overflow-scrolling']=null;" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"document.ontouchmove = function(e){ return true; }" completionHandler:nil];
        [uiWebView evaluateJavaScript:@"Visor.DesactivarSubrayado();" completionHandler:nil];
        [FabSubrayar setImage:[UIImage imageNamed:@"subrayar.png"] forState:UIControlStateNormal];
        
        FabBorrar.hidden=true;
        FabCerrarSubrayar.hidden=true;
        FabColorSubRayar.hidden =true;
        
        SubrayarActivo=0;
    }
    
    //[uiWebView evaluateJavaScript:@"document.getElementById('btnSubrayar').click()" completionHandler:nil];
    NSLog(@"url = %@", @"BtnFavoritos");
}
/****Herramientas Subrayar******/
-(IBAction)ClickBorrar:(id)sender{
    if(ColorSubRayarActivo==1)
    {
        [FabColorSubRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    if(BorrarActivo==0)
    {
        [FabBorrar  setImage:[UIImage imageNamed:@"borrar_activo.png"] forState:UIControlStateNormal];
        
        BorrarActivo=1;
    }
    else
    {
        [FabBorrar  setImage:[UIImage imageNamed:@"borrar.png"] forState:UIControlStateNormal];
        BorrarActivo=0;
    }
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //[uiWebView evaluateJavaScript:@"document.getElementById('BtnBorrarSubrayado').click()" completionHandler:nil];
    [uiWebView evaluateJavaScript:@"Visor.handleBorrarSubrayado()" completionHandler:nil];
    NSLog(@"url = %@", @"BtnFavoritos");
}
-(IBAction)ClickCerrarSubrayar:(id)sender{
    BorrarActivo=0;
    [FabBorrar  setImage:[UIImage imageNamed:@"borrar.png"] forState:UIControlStateNormal];
    
    FabColorSubRayar.backgroundColor=[UIColor yellowColor];
    
    if(FabColorSubRayarYellow.isHidden==false)
        [FabColorSubRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    [FabSubrayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/*****************************/
-(IBAction)ClickCerrarLibro:(id)sender{
    NSLog(@"Cerrar Libro");
    @try {
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}
/*********Colores SubRayar*************/
-(IBAction)ClickColorSubRayar:(id)sender{
    NSLog(@"Color SubRayar");
    if(BorrarActivo==1){
        [FabBorrar sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    if(ColorSubRayarActivo==0)
    {
        FabColorSubRayarYellow.hidden=false;
        FabColorSubRayarBlue.hidden  =false;
        FabColorSubRayarPink.hidden  =false;
        
        ColorSubRayarActivo=1;
    }
    else
    {
        FabColorSubRayarYellow.hidden=true;
        FabColorSubRayarBlue.hidden  =true;
        FabColorSubRayarPink.hidden  =true;
        
        ColorSubRayarActivo=0;
    }
}
-(IBAction)ClickColorSubRayarYellow:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorSubRayado('yellow')" completionHandler:nil];
    
    FabColorSubRayar.backgroundColor=[UIColor yellowColor];
    [FabColorSubRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorSubRayarBlue:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorSubRayado('#27fff0')" completionHandler:nil];
    
    FabColorSubRayar.backgroundColor=[UIColor cyanColor];
    [FabColorSubRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorSubRayarPink:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorSubRayado('#ff277b')" completionHandler:nil];
    
    FabColorSubRayar.backgroundColor=[UIColor magentaColor];
    [FabColorSubRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/*************************************/
/*********Colores Rayar*************/
-(IBAction)ClickColorRayar:(id)sender{
    NSLog(@"Color Rayar");
    //[self dismissViewControllerAnimated:YES completion:nil];
    if(ColoresRayarActivo==0)
    {
        FabColorRayarBlack.hidden  =false;
        FabColorRayarRed.hidden    =false;
        FabColorRayarYellow.hidden =false;
        FabColorRayarGreen.hidden  =false;
        FabColorRayarPurple.hidden =false;
        FabColorRayarBlue.hidden   =false;
        
        /***Nuevo colores rayar*******/
        FabColorRayarRosa.hidden  =false;
        FabColorRayarCafe.hidden =false;
        FabColorRayarNaranja.hidden   =false;
        /****************************/
        
        ColoresRayarActivo=1;
    }
    else
    {
        FabColorRayarBlack.hidden  =true;
        FabColorRayarRed.hidden    =true;
        FabColorRayarYellow.hidden =true;
        FabColorRayarGreen.hidden  =true;
        FabColorRayarPurple.hidden =true;
        FabColorRayarBlue.hidden   =true;
        
        /***Nuevo colores rayar*******/
        FabColorRayarRosa.hidden  =true;
        FabColorRayarCafe.hidden =true;
        FabColorRayarNaranja.hidden   =true;
        /****************************/
        
        ColoresRayarActivo=0;
    }
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    
    NSString *script = [NSString stringWithFormat:@"Visor.handleTamanoLienzo(%.1f)",_Slider.value];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
}
-(IBAction)ClickColorRayarBlack:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('black')" completionHandler:nil];
    colorRayado=@"black";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor blackColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarRed:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('red')" completionHandler:nil];
    colorRayado=@"red";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor redColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarYellow:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('yellow')" completionHandler:nil];
    colorRayado=@"yellow";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor yellowColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarGreen:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('green')" completionHandler:nil];
    colorRayado=@"green";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor greenColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarPurple:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('purple')" completionHandler:nil];
    colorRayado=@"purple";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor purpleColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarBlue:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('blue')" completionHandler:nil];
    colorRayado=@"blue";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor blueColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/*********Nuevo colores******/
-(IBAction)ClickColorRayarRosa:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('magenta')" completionHandler:nil];
    colorRayado=@"magenta";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor magentaColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarCafe:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('brown')" completionHandler:nil];
    colorRayado=@"brown";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor brownColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
-(IBAction)ClickColorRayarNaranja:(id)sender{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleColorRayado('orange')" completionHandler:nil];
    colorRayado=@"orange";
    
    if(BorrarRayarActivo==1)
        [FabUndo sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    FabColorRayar.backgroundColor=[UIColor orangeColor];
    [FabColorRayar sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/****************************/
/****************************/
/*****Camara********/
-(IBAction)ClickCamara:(id)sender{
    
    NSLog(@"Camara");
    
    FotoEjercicio=@"";
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.editing=true;
    picker.allowsEditing=true;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    [self presentViewController:picker animated:YES
                     completion:^ {
                         NSLog(@"Camara lista");
                     }];
   
}
/*-(IBAction)ClickCamara:(id)sender{
    [self ValidarBotones:@"CamaraTools"];
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    NSLog(@"Tool Camara");
    
    if(CamaraActivo==0)
    {
        FabCamara.hidden =false;
        FabAlbum.hidden       =false;
        FabCerrarCamara.hidden    =false;
        
        CamaraActivo=1;
    }
    else{
        FabCamara.hidden =true;
        FabAlbum.hidden       =true;
        FabCerrarCamara.hidden    =true;
        
        CamaraActivo=0;
    }
}*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //obtaining saving path
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if([FotoEjercicio length]!=0)
    {
        NSString *NombreArchivo=FotoEjercicio;
        NombreArchivo=[NombreArchivo stringByAppendingString:@".png"];
    
        //NSString *imagePath =self.productURL;
        NSRange range = [self.productURL rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *baseURL = [self.productURL substringToIndex:range.location];
        baseURL = [baseURL stringByAppendingString:@"/"];
        NSString *imagePath =[baseURL stringByReplacingOccurrencesOfString:@"capacitor://localhost/_capacitor_file_" withString:@"file://"];
        imagePath=[imagePath stringByAppendingPathComponent:@"assets"];
        imagePath=[imagePath stringByAppendingPathComponent:@"img"];
        imagePath=[imagePath stringByAppendingPathComponent:NombreArchivo];
        
        NSString *finalPath = [imagePath substringWithRange:NSMakeRange(5, imagePath.length -5 )];
        
        //extracting image from the picker and saving it
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
            NSData *webData = UIImagePNGRepresentation(editedImage);
            [webData writeToFile:finalPath atomically:YES];
        }
    
        
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        NSString *script = [NSString stringWithFormat:@"Visor.mostrarFoto('%@')",FotoEjercicio];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
        
        FotoEjercicio=@"";
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        return;
    }

    NSDateFormatter *FormatoNombreArchivo=[[NSDateFormatter alloc] init];
    [FormatoNombreArchivo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *NombreArchivo=[FormatoNombreArchivo stringFromDate:[NSDate date]];
    NombreArchivo=[NombreArchivo stringByAppendingString:@".png"];
    
    NSRange range = [self.productURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *baseURL = [self.productURL substringToIndex:range.location];
    baseURL = [baseURL stringByAppendingString:@"/"];
    
  
    //NSString *imagePath =self.productURL;
    NSString *imagePath =[baseURL stringByReplacingOccurrencesOfString:@"capacitor://localhost/_capacitor_file_" withString:@"file://"];

    imagePath=[imagePath stringByAppendingPathComponent:_HojaActual];
    imagePath=[imagePath stringByAppendingPathComponent:NombreArchivo];
    
    NSString *finalPath = [imagePath substringWithRange:NSMakeRange(5, imagePath.length -5 )];
    
    NSLog(@"imagePath = %@", finalPath);
    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *webData = UIImagePNGRepresentation(editedImage);
        [webData writeToFile:finalPath atomically:YES];
    }
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;

    /*NSString *script=[NSString stringWithFormat:@"Visor.handleGuardarImagen('%@')",NombreArchivo];
    [uiWebView evaluateJavaScript:script completionHandler:nil];*/
    
    
    const char *dbpath = [_databasePath UTF8String];
    //[self findContact];
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
            NSString *sql;
            sql = [NSString stringWithFormat:
                   @"INSERT INTO IMAGENES (LIBROID,HOJA,PATH) VALUES (\"%@\", \"%@\", \"%@\")",
                   _LibroId,_HojaActual,NombreArchivo];
    
            [self saveData:sql];
            sqlite3_close(_db);
        
            NSString *script = [NSString stringWithFormat:@"Visor.dibujarFoto(%@)",_HojaActual];
            [uiWebView evaluateJavaScript:script completionHandler:nil];
            [picker dismissViewControllerAnimated:YES completion:NULL];
            return;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(IBAction)ClickAlbum:(id)sender{
    NSLog(@"Album");
    
    /*WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    [uiWebView evaluateJavaScript:@"Visor.handleLstImagenes()" completionHandler:nil];*/
    //tap.enabled= tap.isEnabled==true ? false : true;
    
    NSLog(@"url = %@", @"BtnNotas");
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    GaleriaViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GaleriaViewController"];
    //controller.PathLibro= _productURL;
    //NSString *newPath = [self.productURL stringByReplacingOccurrencesOfString:@"ionic://localhost/_app_file_" withString:@"file://"];
    
    NSRange range = [self.productURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *baseURL = [self.productURL substringToIndex:range.location];
    baseURL = [baseURL stringByAppendingString:@"/"];
    controller.PathLibro= [baseURL stringByReplacingOccurrencesOfString:@"capacitor://localhost/_capacitor_file_" withString:@"file://"];;
    controller.HojaActual=_HojaActual;
    controller.webView=uiWebView;
    controller.databasePath=_databasePath;
    controller.LibroId=_LibroId;
    controller.db=_db;
    
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];

}
-(IBAction)ClickToolCamara:(id)sender{
    [self ValidarBotones:@"CamaraTools"];
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    NSLog(@"Tool Camara");
    
    if(CamaraActivo==0)
    {
        FabCamara.hidden =false;
        FabAlbum.hidden       =false;
        FabCerrarCamara.hidden    =false;
        
        CamaraActivo=1;
    }
    else{
        FabCamara.hidden =true;
        FabAlbum.hidden       =true;
        FabCerrarCamara.hidden    =true;
        
        CamaraActivo=0;
    }
}
-(IBAction)ClickCerrarCamara:(id)sender{
    NSLog(@"Cerrar Camara");
    
    [FabToolCamara sendActionsForControlEvents: UIControlEventTouchUpInside];
}
/******************/
/*****************/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    _HojaActual=@"1";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Press Me" forState:UIControlStateNormal];
    [button sizeToFit];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Set a new (x,y) point for the button's center
    //button.center = CGPointMake(320/2, 1000);
    button.center = CGPointMake(50, screenHeight - 50);

    FabMain.center     = CGPointMake(50, screenHeight - 50);
    FabSeparador.center= CGPointMake(50, screenHeight - 50);
    FabFavoritos.center= CGPointMake(50, screenHeight - 50);
    FabIndice.center   = CGPointMake(50, screenHeight - 50);
    FabNotas.center    = CGPointMake(50, screenHeight - 50);
    FabRayar.center    = CGPointMake(50, screenHeight - 50);
    FabSubrayar.center = CGPointMake(50, screenHeight - 50);
    /******Camara****/
    FabToolCamara.center       = CGPointMake(50, screenHeight - 50);
    FabCamara.center           = CGPointMake(screenWidth - 50, screenHeight/2);
    FabAlbum.center            = CGPointMake(screenWidth - 50, (screenHeight/2)+55);
    FabCerrarCamara.center     = CGPointMake(screenWidth - 50, (screenHeight/2)+110);
    /************************/
    
    
    FabUndo.center            = CGPointMake(screenWidth - 50, (screenHeight/2)+55);
    FabLimpiar.center         = CGPointMake(screenWidth - 50, (screenHeight/2)+110);
    FabCerrarRayar.center     = CGPointMake(screenWidth - 50, (screenHeight/2)+165);
    
    FabBorrar.center            = CGPointMake(screenWidth - 50, (screenHeight/2)+55);
    FabCerrarSubrayar.center    = CGPointMake(screenWidth - 50, (screenHeight/2)+110);
    
    /******Ejercicios*****/
    
    
    FabCandando.center         = CGPointMake(screenWidth - 50, screenHeight - 50);
    //FabCandadoEscribir.center  = CGPointMake(screenWidth - 50, screenHeight - 160);
    /*********************/
    
    FabCerrarLibro.center=CGPointMake(50,screenHeight - 160);
    FabNumPagina.center  =CGPointMake(50,screenHeight - 105);
    //ImgCerrarLibro.center=CGPointMake(screenWidth - 50,50);
    
    ImgCerrarLibro.hidden=true;
    
    
    CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
    self.Slider.transform = sliderRotation;
    
    if (IPAD) {
        // iPad
        NSLog(@" es un ipad");
        /******Colores SubRayado****/
        FabColorSubRayar.center       = CGPointMake(screenWidth - 50, screenHeight/2);
        FabColorSubRayarYellow.center = CGPointMake((screenWidth/2)-80, (screenHeight /2)-135);
        FabColorSubRayarBlue.center   = CGPointMake((screenWidth/2)-15, (screenHeight /2)-135);
        FabColorSubRayarPink.center   = CGPointMake((screenWidth/2)+50, (screenHeight /2)-135);
        /*************************/
        
        /******Colores Rayado****/
        self.Slider.center         = CGPointMake(screenWidth - 50, (screenHeight /2)+70);
        FabColorRayar.center       = CGPointMake(screenWidth - 50, screenHeight/2);
        FabColorRayarBlack.center  = CGPointMake((screenWidth/2)-80, (screenHeight /2)-135);
        FabColorRayarRed.center    = CGPointMake((screenWidth/2)-15, (screenHeight /2)-135);
        FabColorRayarYellow.center = CGPointMake((screenWidth/2)+50, (screenHeight /2)-135);
        FabTamanoLienzo.center     = CGPointMake(screenWidth - 50, (screenHeight/2)- 55);
        
        FabColorRayarGreen.center  = CGPointMake((screenWidth/2)-80, (screenHeight /2)-80);
        FabColorRayarPurple.center = CGPointMake((screenWidth/2)-15, (screenHeight /2)-80);
        FabColorRayarBlue.center   = CGPointMake((screenWidth/2)+50, (screenHeight /2)-80);
        /************************/
        
        /******Nuevo colores Rayado****/
        FabColorRayarRosa.center    = CGPointMake((screenWidth/2)-80, (screenHeight /2)-25);
        FabColorRayarCafe.center    = CGPointMake((screenWidth/2)-15, (screenHeight /2)-25);
        FabColorRayarNaranja.center = CGPointMake((screenWidth/2)+50, (screenHeight /2)-25);
        /************************/
    } else {
        NSLog(@" es un celular");
        NSInteger ajuste=10;
        
        /******Colores SubRayado****/
        FabColorSubRayar.center       = CGPointMake(screenWidth - 50, screenHeight/2);
        FabColorSubRayarYellow.center = CGPointMake((screenWidth/2)-80+ajuste, (screenHeight /2)-135);
        FabColorSubRayarBlue.center   = CGPointMake((screenWidth/2)-15+ajuste, (screenHeight /2)-135);
        FabColorSubRayarPink.center   = CGPointMake((screenWidth/2)+50+ajuste, (screenHeight /2)-135);
        /*************************/
        
        /******Colores Rayado****/
        self.Slider.center         = CGPointMake(screenWidth - 50, (screenHeight /2)+70);
        FabColorRayar.center       = CGPointMake(screenWidth - 50, screenHeight/2);
        FabColorRayarBlack.center  = CGPointMake((screenWidth/2)-80+ajuste, (screenHeight /2)-135);
        FabColorRayarRed.center    = CGPointMake((screenWidth/2)-15+ajuste, (screenHeight /2)-135);
        FabColorRayarYellow.center = CGPointMake((screenWidth/2)+50+ajuste, (screenHeight /2)-135);
        
        FabColorRayarGreen.center  = CGPointMake((screenWidth/2)-80+ajuste, (screenHeight /2)-80);
        FabColorRayarPurple.center = CGPointMake((screenWidth/2)-15+ajuste, (screenHeight /2)-80);
        FabColorRayarBlue.center   = CGPointMake((screenWidth/2)+50+ajuste, (screenHeight /2)-80);
        
        FabTamanoLienzo.center     = CGPointMake(screenWidth - 50, (screenHeight/2)- 55);
        /************************/
        
        /******Nuevo colores Rayado****/
        FabColorRayarRosa.center    = CGPointMake((screenWidth/2)-80, (screenHeight /2)-25);
        FabColorRayarCafe.center    = CGPointMake((screenWidth/2)-15, (screenHeight /2)-25);
        FabColorRayarNaranja.center = CGPointMake((screenWidth/2)+50, (screenHeight /2)-25);
        /************************/
    }

    
    self.Slider.minimumValue=0.5;
    self.Slider.maximumValue=10;
    
   
    //    self.viewController = [CDVViewController new];
        //CDVViewController* viewController = [CDVViewController new];
        self.CapViewController = [CAPBridgeViewController new];
        
        [self.CapViewController setServerBasePathWithPath:self.productURL];
        //_viewController.wwwFolderName = @"file:///var/mobile/Containers/Data/Application/32CAAD7C-B12C-483F-920D-E5643C0ABC7A/Documents/Libro2";
       // self.viewController.wwwFolderName = self.productURL;
        //self.viewController.wwwFolderName  = @"https://www.google.com";
        
        NSLog(@"url view did load = %@", self.productURL);
        NSLog(@"app = %@", self.App);
        NSLog(@"token = %@", self.TokenLBS);
        idTokenLBS = _TokenLBS;
      
        NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
        long digits = (long)time; // this is the first 10 digits
        int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
        
        NSString *timestampString = [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
     
        self.productURL = [self.productURL stringByAppendingFormat:@"?t=%@", timestampString];
       // self.viewController.startPage = indexHtml;
        
        NSLog(@"ultimo link =  %@", self.productURL);
    
        self.CapViewController.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        uiWebView.scrollView.delegate=self;
        uiWebView.scrollView.scrollEnabled = true;
        uiWebView.scrollView.bouncesZoom=false;
        uiWebView.scrollView.bounces=false;
        uiWebView.scrollView.maximumZoomScale=1.0;
        uiWebView.scrollView.showsHorizontalScrollIndicator=true;
        uiWebView.hidden=true;

        
        
        
        
        /*NSURL *url = [NSURL URLWithString:self.productURL];

        NSURLRequest* appReq = [
            NSURLRequest requestWithURL:url
            cachePolicy:NSURLRequestUseProtocolCachePolicy
            timeoutInterval:20.0
        ];
        
        [uiWebView loadRequest:appReq];*/
        

   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:@"webViewDidFinishLoading1" object:nil];        //UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:@"pageDidLoad" object:nil];
        [self.view addSubview:_CapViewController.view];


        [self.view sendSubviewToBack:self.CapViewController.view];
      //  [self FabsHandlerClose:0];
        
        //[self.view addSubview:_webView];
        //[self.view sendSubviewToBack:_webView];
        //[self.view addSubview:button];

        
        NSLog(@"screenWidth = %f", screenWidth);
        
        //Enviar token al libro en html
      //  NSString *script = [NSString stringWithFormat:@"Visor.cacharTokendesdeNativo('%@')",self.TokenLBS];
       // [uiWebView  evaluateJavaScript:script completionHandler:nil];
        
        /***Conexion a la bd*/
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        docsDir = dirPaths[0];
        
        docsDir= [[NSString alloc]
                  initWithString: [docsDir stringByAppendingPathComponent:@"NoCloud"]];
        
        docsDir= [[NSString alloc]
                  initWithString: [docsDir stringByAppendingPathComponent:@"books2020"]];
        
        // Build the path to the database file
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"libros.db"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: _databasePath ] == NO)
        {
            const char *dbpath = [_databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
            {
                //Estado preguntas 0=Incorrecta, 1=Correcta, 2=Sin calificar
                
                char *errMsg;
                const char *sql_stmt ="CREATE TABLE IF NOT EXISTS SEPARADORES (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT);CREATE TABLE IF NOT EXISTS RAYADO (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT);CREATE TABLE IF NOT EXISTS NOTAS (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER,HOJA TEXT, NOTA TEXT);CREATE TABLE IF NOT EXISTS IMAGENES (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER,HOJA TEXT,PATH TEXT);CREATE TABLE IF NOT EXISTS SUBRAYADO (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT);CREATE TABLE IF NOT EXISTS ESCRIBIR (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, EJERCICIO TEXT,DATA TEXT,ELEMENTO TEXT,ESTADO INTEGER);";
                
                if (sqlite3_exec(_db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    //_status.text = @"Failed to create table";
                     NSLog(@"Failed to create table!");
                }
                sqlite3_close(_db);
            } else {
                //_status.text = @"Failed to open/create database";
                  NSLog(@"Failed to open/create database");
            }
        }
        /*******************/

      
        [FabNumPagina setTitle:@"1" forState:UIControlStateNormal];
        // view is your UIViewController's view that contains your UIWebView as a subview
        //[self.viewController.view addGestureRecognizer:tap];
        //tap.delegate = self;
        
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    NSLog(@"⚡️ WebView loaded");
}

/*- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Tu lógica personalizada aquí...
    NSLog(@"⚡️ WebView loaded");
}*/

- (void)didFinishLoadingWebView {
    // Este método se llamará cuando el evento ocurra desde Swift
    NSLog(@"El webview ha terminado de cargar.");
}



- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if(BorrarActivo==true) return;

    
    NSLog(@"tap!");
    if(TapActivo==0)
    {
        FabMain.hidden      =true;
        FabSeparador.hidden =true;
        FabFavoritos.hidden =true;
        FabIndice.hidden    =true;
        FabNotas.hidden     =true;
        FabRayar.hidden     =true;
        FabSubrayar.hidden  =true;
        FabToolCamara.hidden =true;
        if ([self.App isEqualToString:@"Lbs"])
        {
            
            FabCandando.hidden=true;
            //FabCandadoEscribir.hidden=true;
        }
        FabCerrarLibro.hidden=true;
        FabNumPagina.hidden=true;
 
        TapActivo=1;
    }
    else
    {
        FabMain.hidden      =false;
        FabCerrarLibro.hidden=false;
        FabNumPagina.hidden=false;
        if ([self.App isEqualToString:@"Lbs"])
        {
            
            FabCandando.hidden=true;
            //FabCandadoEscribir.hidden=false;
        }
        TapActivo=0;
        if(MainOpen==true)
        {
            FabSeparador.hidden =false;
            FabFavoritos.hidden =false;
            FabIndice.hidden    =false;
            FabNotas.hidden     =false;
            FabRayar.hidden     =false;
            FabSubrayar.hidden  =false;
            FabToolCamara.hidden=false;
        }
    }

    /*if (gestureRecognizer.delegate) {
        NSLog(@"Removing delegate...");
        gestureRecognizer.delegate = nil;
    }*/
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        
        NSLog(@"added failure requirement to: %@", otherGestureRecognizer);
    }
    
    return YES;
}
- (void)pageDidLoad
{
    NSLog(@"carga completa");
    NSLog(@"Token 2= %@", _TokenLBS);
    idLibro=self.LibroId;
    idApp=self.App;
    idTokenLBS=_TokenLBS;
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    uiWebView.hidden=false;
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        
        
        FabMain.hidden=false;
        FabCerrarLibro.hidden=false;
        
        FabNumPagina.hidden=false;
        FabCandando.hidden=true;
        NSLog(@"url = %@", self.App);
        
        
        //Candado = Panel
        //Para reaprovechar el boton se uso el fabcandado para el panel
        FabCandando.hidden=true;
        //FabCandadoEscribir.hidden=false;
        
        //Enviar token al libro en html
        NSString *script = [NSString stringWithFormat:@"Visor.cacharTokendesdeNativo('%@')",self.TokenLBS];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
      //  [self dibujarSeparadores];
        [self dibujarNotas];
        [self dibujarRayado];
        [self dibujarFoto];
        [self dibujarSubrayado];
        
        if ([self.App isEqualToString:@"Lbs"])
        {
            
            //Candado = Panel
            //Para reaprovechar el boton se uso el fabcandado para el panel
            FabCandando.hidden=true;
            //FabCandadoEscribir.hidden=false;
            
            //Enviar token al libro en html
            NSString *script = [NSString stringWithFormat:@"Visor.cacharTokendesdeNativo('%@')",self.TokenLBS];
            [uiWebView evaluateJavaScript:script completionHandler:nil];
            [self dibujarSeparadores];
            [self dibujarNotas];
            [self dibujarRayado];
            [self dibujarFoto];
            [self dibujarSubrayado];
        }
        //self.LibroId=idLibro;
    });
    
    
      NSLog(@"LibroID 2= %@", _LibroId);
}
-(void)AbrirNota{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    NSLog(@"url = %@", @"BtnNotas");
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NotificationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    controller.webView=uiWebView;
    controller.DatosNota=[_DatosNota stringByReplacingOccurrencesOfString:@"%20" withString:@"\n"];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
    _DatosNota=nil;
}
-(void)AbrirIndice{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSString *script = [NSString stringWithFormat:@"Visor.mostrarIndicePaginas();"];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    
    NSLog(@"url = %@", @"BtnNotas");
    
}
-(void)AbrirGaleria{
    //if(SubrayarActivo==1 || RayarActivo==1) return;
    
    tap.enabled= tap.isEnabled==true ? false : true;
    
    NSLog(@"url = %@", @"BtnNotas");
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    GaleriaViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GaleriaViewController"];
    //controller.PathLibro= _productURL;
    controller.PathLibro= [self.productURL stringByReplacingOccurrencesOfString:@"capacitor://localhost/_capacitor_file_" withString:@"file://"];
    controller.HojaActual=_HojaActual;
    controller.webView=uiWebView;
    controller.recipeImages=_ImagenesGaleria;
    

    
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
}
- (BOOL)shouldAutorotate{
    return NO;
}
/****Querys db*****/
/*- (void) findContact {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM SEPARADORES WHERE HOJA=\"%@\"",
                              _HojaActual];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 0)];
                //_address.text = addressField;
                NSString *phoneField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                //_phone.text = phoneField;
                //_status.text = @"Match found";
            } else {
                //_status.text = @"Match not found";
                //_address.text = @"";
                //_phone.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}*/
- (void) dibujarSeparadores {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT HOJA FROM SEPARADORES WHERE LIBROID=\"%@\"",
                              _LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *hoja = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 0)];
                
                NSString *script = [NSString stringWithFormat:@"Visor.dibujarSeparador(%@)",hoja];
                [uiWebView evaluateJavaScript:script completionHandler:nil];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}
- (void) dibujarNotas {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT HOJA FROM NOTAS WHERE LIBROID=\"%@\"",
                              _LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *hoja = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *script = [NSString stringWithFormat:@"Visor.dibujarNota(%@)",hoja];
                [uiWebView evaluateJavaScript:script completionHandler:nil];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}
- (void) dibujarFoto {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT HOJA FROM IMAGENES WHERE LIBROID=\"%@\" GROUP BY HOJA",
                              _LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *hoja = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *script = [NSString stringWithFormat:@"Visor.dibujarFoto(%@)",hoja];
                [uiWebView evaluateJavaScript:script completionHandler:nil];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}
- (void) dibujarRayado {
    dispatch_async(dispatch_get_main_queue(), ^{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        NSLog(@"Aqui LibroId %@", _LibroId);
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT DATA,HOJA FROM RAYADO WHERE LIBROID=\"%@\"",
                              _LibroId];
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *data = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *hoja = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 1)];
                NSLog(@"Insertado con exito hoja ---",hoja);
                NSLog(@"Insertado con exito rayado ---",data);
                NSString *script = [NSString stringWithFormat:@"Visor.dibujarRayado(%@,'%@')",hoja,data];
                [uiWebView evaluateJavaScript:script completionHandler:nil];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
    });
}
- (void) dibujarSubrayado {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT DATA,HOJA FROM SUBRAYADO WHERE LIBROID=\"%@\"",
                              _LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *data = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *hoja = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 1)];
                if(![data isEqualToString:@"[]"])
                {
                    NSString *script = [NSString stringWithFormat:@"Visor.dibujarMarcatexto(%@,'%@')",hoja,data];
                    [uiWebView evaluateJavaScript:script completionHandler:nil];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}

- (void) dibujarEscribir : Ejercicio {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT DATA,ELEMENTO,ESTADO FROM ESCRIBIR WHERE LIBROID=\"%@\" AND EJERCICIO=\"%@\"",
                              _LibroId,Ejercicio];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *data = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *elemento = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 1)];
                
                NSString *estado = [[NSString alloc]
                                      initWithUTF8String:
                                      (const char *) sqlite3_column_text(
                                                                         statement, 2)];
                
                if(![data isEqualToString:@"[]"])
                {
                    NSString *script = [NSString stringWithFormat:@"document.getElementById('%@').value='%@'",elemento,data];
                    [uiWebView evaluateJavaScript:script completionHandler:nil];
                }
                //Estado preguntas 0=Incorrecta, 1=Correcta, 2=Sin calificar
                if(![estado isEqualToString:@"2"])
                {
                    NSString *script = [NSString stringWithFormat:@"document.getElementById('%@').disabled=true",elemento];
                    [uiWebView evaluateJavaScript:script completionHandler:nil];
                   if([estado isEqualToString:@"1"])
                   {
                       NSString *script = [NSString stringWithFormat:@"document.getElementById('bien_%@').style.color='green'",elemento];
                       [uiWebView evaluateJavaScript:script completionHandler:nil];
                   }
                   else if([estado isEqualToString:@"0"])
                   {
                       NSString *script = [NSString stringWithFormat:@"document.getElementById('mal_%@').style.color='orange'",elemento];
                       [uiWebView evaluateJavaScript:script completionHandler:nil];
                   }
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}
- (void) saveData : insertSQL{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_db, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //_status.text = @"Contact added";
            //_name.text = @"";
            //_address.text = @"";
            //_phone.text = @""
            NSLog(@"Insertado con exito");
        } else {
            //_status.text = @"Failed to add contact";
            NSLog(@"Error al insertar");
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_db));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
}
- (void) TomarFoto : IdImagen{
    NSLog(@"Camara Ejercicio");
    
    FotoEjercicio = IdImagen;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.editing=true;
    picker.allowsEditing=true;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    [self presentViewController:picker animated:YES
                     completion:^ {
                         NSLog(@"Camara lista");
                     }];
}
- (void) EliminarFoto : IdImagen{
    ImagenID=IdImagen;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"LBS Plus"
                              message:@"¿Estas seguro de eliminar la imagen?"
                              delegate:self
                              cancelButtonTitle:@"Eliminar"
                              otherButtonTitles:nil];
    
    [alertView addButtonWithTitle:@"Cancelar"];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Click eliminar");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *NombreArchivo=ImagenID;
        NombreArchivo=[NombreArchivo stringByAppendingString:@".png"];
        
        //NSString *imagePath =self.productURL;
        NSString *imagePath =[self.productURL stringByReplacingOccurrencesOfString:@"capacitor://localhost/_capacitor_file_" withString:@"file://"];
        imagePath=[imagePath stringByAppendingPathComponent:@"assets"];
        imagePath=[imagePath stringByAppendingPathComponent:@"img"];
        imagePath=[imagePath stringByAppendingPathComponent:NombreArchivo];
        
        NSString *finalPath = [imagePath substringWithRange:NSMakeRange(5, imagePath.length -5 )];
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:finalPath error:&error];
        if (success) {
             WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
            
            NSString *script = [NSString stringWithFormat:@"Visor.LimpiarFoto('%@')",ImagenID];
            [uiWebView evaluateJavaScript:script completionHandler:nil];
        }

    } else if (buttonIndex == 1) {
        NSLog(@"Click Cancelar");
    }
}
- (void) cambiarCandado : estado {
    if([estado isEqualToString:@"abrir"]){
         [FabCandando setImage:[UIImage imageNamed:@"CandadoAbierto.png"] forState:UIControlStateNormal];
    }
    else if([estado isEqualToString:@"cerrar"]){
         [FabCandando setImage:[UIImage imageNamed:@"CandadoCerrado.png"] forState:UIControlStateNormal];
    }
}
/***Borrador*/
- (IBAction)ClickTamanoLienzo:(id)sender {
    if(self.Slider.hidden==true)
    {
        FabColorRayar.hidden =true;
        FabUndo.hidden       =true;
        FabLimpiar.hidden    =true;
        FabCerrarRayar.hidden=true;
        
        self.Slider.hidden=false;
    }
    else {
        FabColorRayar.hidden =false;
        FabUndo.hidden       =false;
        FabLimpiar.hidden    =false;
        FabCerrarRayar.hidden=false;
        
        self.Slider.hidden=true;
    }
}
- (IBAction)endTouch:(id)sender {
    NSLog(@"Touch final");
    
    FabColorRayar.hidden =false;
    FabUndo.hidden       =false;
    FabLimpiar.hidden    =false;
    FabCerrarRayar.hidden=false;
    
    self.Slider.hidden= true;
}

- (IBAction)sliderChanged:(id)sender {
    NSLog(@"SliderValue %f",self.Slider.value);
    [FabTamanoLienzo setTitle: [NSString stringWithFormat:@"%.1f",self.Slider.value] forState:UIControlStateNormal];
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSString *script = [NSString stringWithFormat:@"Visor.handleTamanoLienzo(%.1f)",_Slider.value];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
}

-(void)openPlayer {
    
    
    if(PresionarBotonPlayer==1)
        return;
    
    [self ValidarBotones:@"Panel"];
    
    PresionarBotonPlayer=1;
    
    if(PlayerOpen==0) {
        
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        NSString *script = [NSString stringWithFormat:@"Visor.openPlayer()"];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        //FabCandando.transform = CGAffineTransformMakeRotation(3.10);
        
        FabNumPagina.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabCerrarLibro.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabCandando.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        FabMain.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabSeparador.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabFavoritos.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabIndice.transform    = CGAffineTransformMakeScale(0.01, 0.01);
        FabNotas.transform     = CGAffineTransformMakeScale(0.01, 0.01);
        FabRayar.transform     = CGAffineTransformMakeScale(0.01, 0.01);
        FabSubrayar.transform  = CGAffineTransformMakeScale(0.01, 0.01);
        FabToolCamara.transform =CGAffineTransformMakeScale(0.01, 0.01);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 animations:^{
            //Desactiva pinch zoom
            NSString *scriptzoom=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=no')";
            [uiWebView evaluateJavaScript:scriptzoom completionHandler:nil];
            
            PlayerOpen=1;
        }completion:^(BOOL finished) {
            //code for completion
            PresionarBotonPlayer=0;
        }];
        
        PlayerOpen=1;
    } else {
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        NSString *script = [NSString stringWithFormat:@"document.getElementById('playerMusic')._hideModel()"];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        //FabCandando.transform = CGAffineTransformMakeRotation(0);
        
        FabNumPagina.transform = CGAffineTransformMakeScale(1, 1);
        FabCerrarLibro.transform = CGAffineTransformMakeScale(1, 1);
        FabCandando.transform = CGAffineTransformMakeScale(1, 1);
        
        FabMain.transform = CGAffineTransformMakeScale(1, 1);
        FabSeparador.transform = CGAffineTransformMakeScale(1, 1);
        FabFavoritos.transform = CGAffineTransformMakeScale(1, 1);
        FabIndice.transform    = CGAffineTransformMakeScale(1, 1);
        FabNotas.transform     = CGAffineTransformMakeScale(1, 1);
        FabRayar.transform     = CGAffineTransformMakeScale(1, 1);
        FabSubrayar.transform  = CGAffineTransformMakeScale(1, 1);
        FabToolCamara.transform =CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 animations:^{
            //Activa pinch zoom
            NSString *scriptzoom=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=5.0,user-scalable=yes')";
            [uiWebView evaluateJavaScript:scriptzoom completionHandler:nil];
            PanelOpen=0;
            
            double delayInSeconds = 0.4;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             
                PresionarBotonPlayer=0;
            });
        }completion:^(BOOL finished) {
            
        
        }];
        
        PlayerOpen=0;
    }
}
- (IBAction)ClickCandado:(id)sender {
    /*WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSString *script = [NSString stringWithFormat:@"Visor.activarCandados(%i)",2];
    [uiWebView evaluateJavaScript:script completionHandler:nil];*/
    //Candado = Panel
    
    if(tipoPanel==1)
    {
        [self openPlayer];
        return;
    }
    
    if(PresionarBotonPanel==1)
        return;
    
    [self ValidarBotones:@"Panel"];
    
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    NSString *script = [NSString stringWithFormat:@"Visor.openFooter()"];
    [uiWebView evaluateJavaScript:script completionHandler:nil];
    
    PresionarBotonPanel=1;
    
    if(PanelOpen==0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        FabCandando.transform = CGAffineTransformMakeRotation(3.10);
        
        FabNumPagina.transform = CGAffineTransformMakeScale(0.01, 0.01);;
        FabCerrarLibro.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        FabMain.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabSeparador.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabFavoritos.transform = CGAffineTransformMakeScale(0.01, 0.01);
        FabIndice.transform    = CGAffineTransformMakeScale(0.01, 0.01);
        FabNotas.transform     = CGAffineTransformMakeScale(0.01, 0.01);
        FabRayar.transform     = CGAffineTransformMakeScale(0.01, 0.01);
        FabSubrayar.transform  = CGAffineTransformMakeScale(0.01, 0.01);
        FabToolCamara.transform =CGAffineTransformMakeScale(0.01, 0.01);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 animations:^{
            //FabMain.hidden      =true;
            /*FabSeparador.hidden =true;
            FabFavoritos.hidden =true;
            FabIndice.hidden    =true;
            FabNotas.hidden     =true;
            FabRayar.hidden     =true;
            FabSubrayar.hidden  =true;
            FabToolCamara.hidden =true;*/
            /*if ([self.App isEqualToString:@"Lbs"])
                   
            
            //FabCerrarLibro.hidden=true;
            //FabNumPagina.hidden=true;
            
            //Desactiva pinch zoom
            NSString *scriptzoom=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=no')";
            [uiWebView evaluateJavaScript:scriptzoom completionHandler:nil];
            
            PanelOpen=1;
            //[uiWebView evaluateJavaScript:@"Visor.VerEjercicios();" completionHandler:nil];
        }completion:^(BOOL finished) {
            //code for completion
            PresionarBotonPanel=0;
            /*FabSeparador.hidden=true;
            FabFavoritos.hidden=true;
            FabIndice.hidden=true;
            FabNotas.hidden=true;
            FabRayar.hidden=true;
            FabSubrayar.hidden=true;
            FabToolCamara.hidden=true;*/
        }];
        
        PanelOpen=1;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        FabCandando.transform = CGAffineTransformMakeRotation(0);
        
        FabNumPagina.transform = CGAffineTransformMakeScale(1, 1);
        FabCerrarLibro.transform = CGAffineTransformMakeScale(1, 1);
        
        FabMain.transform = CGAffineTransformMakeScale(1, 1);
        FabSeparador.transform = CGAffineTransformMakeScale(1, 1);
        FabFavoritos.transform = CGAffineTransformMakeScale(1, 1);
        FabIndice.transform    = CGAffineTransformMakeScale(1, 1);
        FabNotas.transform     = CGAffineTransformMakeScale(1, 1);
        FabRayar.transform     = CGAffineTransformMakeScale(1, 1);
        FabSubrayar.transform  = CGAffineTransformMakeScale(1, 1);
        FabToolCamara.transform =CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 animations:^{
            //Activa pinch zoom
            NSString *scriptzoom=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=5.0,user-scalable=yes')";
            [uiWebView evaluateJavaScript:scriptzoom completionHandler:nil];
            PanelOpen=0;
            
            double delayInSeconds = 0.4;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //FabMain.hidden      =false;
                /*FabSeparador.hidden =false;
                FabFavoritos.hidden =false;
                FabIndice.hidden    =false;
                FabNotas.hidden     =false;
                FabRayar.hidden     =false;
                FabSubrayar.hidden  =false;
                FabToolCamara.hidden =false;*/
                if ([self.App isEqualToString:@"Lbs"])
                {
                    
                    //FabCandando.hidden=false;
                    //FabCandadoEscribir.hidden=false;
                }
                //FabCerrarLibro.hidden=false;
                //FabNumPagina.hidden=false;
                PresionarBotonPanel=0;
            });
        }completion:^(BOOL finished) {
            
            //code for completion
            /*FabSeparador.hidden=true;
            FabFavoritos.hidden=true;
            FabIndice.hidden=true;
            FabNotas.hidden=true;
            FabRayar.hidden=true;
            FabSubrayar.hidden=true;
            FabToolCamara.hidden=true;*/
        }];
        
        PanelOpen=0;
    }
}

- (IBAction)ClickCandadoEscribir:(id)sender {
}


-(void)FabsHandlerOpen {
    
    NSLog(@"Clicked Open Fabs");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    //FabCandando.transform = CGAffineTransformMakeRotation(0);
    
    FabNumPagina.transform = CGAffineTransformMakeScale(1, 1);
    FabCerrarLibro.transform = CGAffineTransformMakeScale(1, 1);
    FabCandando.transform = CGAffineTransformMakeScale(1, 1);
    
    FabMain.transform = CGAffineTransformMakeScale(1, 1);
    FabSeparador.transform = CGAffineTransformMakeScale(1, 1);
    FabFavoritos.transform = CGAffineTransformMakeScale(1, 1);
    FabIndice.transform    = CGAffineTransformMakeScale(1, 1);
    FabNotas.transform     = CGAffineTransformMakeScale(1, 1);
    FabRayar.transform     = CGAffineTransformMakeScale(1, 1);
    FabSubrayar.transform  = CGAffineTransformMakeScale(1, 1);
    FabToolCamara.transform =CGAffineTransformMakeScale(1, 1);
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 animations:^{
        //Desactiva pinch zoom
    }completion:^(BOOL finished) {
        //code for completion
        WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
        NSString *script = [NSString stringWithFormat:@"console.log('animacion ended OPEN');"];
        [uiWebView evaluateJavaScript:script completionHandler:nil];
    }];
}

-(void)FabsHandlerClose : tipoCerrar {
    NSLog(@"Clicked Fabs");

        /** 2 Significa si el Fabclose proviene de Crear nota.**/
        if([tipoCerrar intValue] == 2) {
            [FabMain sendActionsForControlEvents: UIControlEventTouchUpInside];
        }
        
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            //FabCandando.transform = CGAffineTransformMakeRotation(3.10);
            
           self->FabNumPagina.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self->FabCerrarLibro.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabCandando.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            self->FabMain.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabSeparador.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabFavoritos.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabIndice.transform    = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabNotas.transform     = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabRayar.transform     = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabSubrayar.transform  = CGAffineTransformMakeScale(0.01, 0.01);
    self->  FabToolCamara.transform =CGAffineTransformMakeScale(0.01, 0.01);
            [UIView commitAnimations];
            
            [UIView animateWithDuration:0.4 animations:^{
                //Desactiva pinch zoom
            }completion:^(BOOL finished) {
                //code for completion
                WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
                NSString *script = [NSString stringWithFormat:@"console.log('animacion ended CLOSE');"];
                [uiWebView evaluateJavaScript:script completionHandler:nil];
            }];
}
/*******************/
/*****************/
/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    WKWebView* uiWebView = (WKWebView*)self.CapViewController.webView;
    //NSLog(@"%@",uiWebView.URL);
    
    NSString *url = uiWebView.URL.absoluteString;
    NSString *pattern = @"page=(\\d+)";
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [url substringWithRange:matchRange];
    //NSLog(@"Pagina actual=%@", match);
    [FabNumPagina setTitle:match forState:UIControlStateNormal];
}*/

- (void) setIsTeacherBook : isTeacherBookVar {
    NSLog(@"IsTEacherBook %@", isTeacherBookVar);
    
    isTeacherBookBtnsNativos = isTeacherBookVar;
    
    NSLog(@"IsTEacherBook %@", isTeacherBookBtnsNativos);
}
@end
