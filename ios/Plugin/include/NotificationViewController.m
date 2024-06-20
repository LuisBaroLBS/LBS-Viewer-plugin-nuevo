//
//  NotificationViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 15/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "NotificationViewController.h"
#import <sqlite3.h>

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     NSLog(@"Nota Cargada");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (IPAD) {
        // iPad
        NSLog(@" es un ipad");
        
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.60];
        
        self.contentView.layer.cornerRadius = 3.0;
        
        //self.notificationTitleLabel.text = self.titleText;
        //self.imageView.image = self.image;
        TxtNota.center            = CGPointMake((screenWidth/2)- 60, (screenHeight/2)-180);
        LblFondo.center           = CGPointMake((screenWidth/2) - 65, (screenHeight/2)-185);
        BtnEliminar.center        = CGPointMake((screenWidth/2)+180, (screenHeight/2)+40);
        BtnGuardar.center        = CGPointMake((screenWidth/2)-170, (screenHeight/2)+40);
        //BtnCerrar.center          = CGPointMake((screenWidth/2)+145, (screenHeight/2)-323);
        LblNota.center          = CGPointMake((screenWidth/2)-175, (screenHeight/2)-300);
        LblLinea.center          = CGPointMake((screenWidth/2) - 65, (screenHeight/2)-275);
        TxtNota.layer.borderColor = [[UIColor whiteColor] CGColor];
        TxtNota.layer.borderWidth = 1.0;
        TxtNota.layer.cornerRadius = 8;
        //LblFondo.layer.borderColor = [[UIColor grayColor] CGColor];
        //LblFondo.layer.borderWidth = 1.0;
        LblFondo.layer.cornerRadius = 25;
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 450, 400);
        LblFondo.frame=CGRectMake(LblFondo.frame.origin.x, LblFondo.frame.origin.y, 450, 400);
        LblLinea.frame=CGRectMake(LblLinea.frame.origin.x, LblLinea.frame.origin.y, 450, LblLinea.frame.size.height);
        TxtNota.frame=CGRectMake(TxtNota.frame.origin.x, TxtNota.frame.origin.y, 440, 300);
    } else {
         NSLog(@" es un celular");
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.60];
        
        //CGRectMake(x, y, width, height);
        LblFondo.frame            = CGRectMake(LblFondo.frame.origin.x,LblFondo.frame.origin.y, 300,300);
        TxtNota.frame            = CGRectMake(TxtNota.frame.origin.x,TxtNota.frame.origin.y, 300,195);
        LblLinea.frame            = CGRectMake(LblLinea.frame.origin.x,LblLinea.frame.origin.y, 300,3);
        
        //Posicion
        NSInteger ajuste=80;
        TxtNota.center            = CGPointMake((screenWidth/2), (screenHeight/2)-180+ajuste);
        LblFondo.center           = CGPointMake((screenWidth/2), (screenHeight/2)-185+ajuste);
        BtnEliminar.center        = CGPointMake((screenWidth/2)+100, (screenHeight/2)-70+ajuste);
        BtnGuardar.center        = CGPointMake((screenWidth/2)-100, (screenHeight/2)-70+ajuste);
        //BtnCerrar.center          = CGPointMake((screenWidth/2)+145, (screenHeight/2)-323);
        LblNota.center          = CGPointMake((screenWidth/2)-100, (screenHeight/2)-300+ajuste);
        LblLinea.center          = CGPointMake((screenWidth/2), (screenHeight/2)-275+ajuste);
        TxtNota.layer.borderColor = [[UIColor whiteColor] CGColor];
        TxtNota.layer.borderWidth = 1.0;
        TxtNota.layer.cornerRadius = 8;
        //LblFondo.layer.borderColor = [[UIColor grayColor] CGColor];
        //LblFondo.layer.borderWidth = 1.0;
        LblFondo.layer.cornerRadius = 25;
    }

    
    if (_DatosNota != nil) {
        TxtNota.text=_DatosNota;
        _DatosNota=nil;
    }
    
    [self buscarNota];
    
    self.dismissButton.layer.cornerRadius = 3.0;
    self.dismissButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.dismissButton.layer.borderWidth = 2.0;
    
    [self.view sendSubviewToBack:LblFondo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)ClickCerrar{
    [self dismissViewControllerAnimated:YES completion:nil];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *scriptzoom=@"document.querySelector('meta[name=viewport]').setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=2.0,user-scalable=yes')";
        [self.webView evaluateJavaScript:scriptzoom completionHandler:nil];
    });
}
-(IBAction)ClickEliminar:(id)sender{
   NSLog(@"Nota Eliminar");
   //[self.webView evaluateJavaScript:@"document.getElementById('BtnEliminarNota').click()" completionHandler:nil];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt  *statement;
    
    //[self findContact];
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM NOTAS WHERE HOJA=\"%@\" and LIBROID=\"%@\"",
                              _HojaActual,_LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSString *sql;
            NSString *script;
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                //sqlite3_finalize(statement);
                NSLog(@"ya existe una nota en la hoja");
                
                sql = [NSString stringWithFormat:
                       @"delete from NOTAS where HOJA=\"%@\" and LIBROID=\"%@\"",
                       _HojaActual,_LibroId];
                //[self.webView evaluateJavaScript:@"document.getElementById('BtnEliminarNota').click()" completionHandler:nil];
                [self.webView evaluateJavaScript:@"Visor.handleEliminarNota()" completionHandler:nil];
                //script = [NSString stringWithFormat:@"Visor.borrarSeparador(%@)",_HojaActual];
            } else {
                return;
                sqlite3_finalize(statement);
                sqlite3_close(_db);
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_db);
            [self saveData:sql];
            [self.webView evaluateJavaScript:script completionHandler:nil];
            //[BtnCerrar sendActionsForControlEvents: UIControlEventTouchUpInside];
            [self ClickCerrar];
            return;
        }
        sqlite3_close(_db);
    }
    
   [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)ClickGuardar:(id)sender{
  NSLog(@"Nota Guardar");
  [self.view endEditing:YES];
  /*NSString *script=@"document.getElementById('txtnota').value='";
    
  script = [script stringByAppendingString:[TxtNota.text stringByReplacingOccurrencesOfString:@"\n" withString:@"%20"]];
  script = [script stringByAppendingString:@"'"];
  NSLog(@"%@",script);
  [self.webView evaluateJavaScript:script completionHandler:nil];
  [self.webView evaluateJavaScript:@"document.getElementById('BtnGuardarNota').click()" completionHandler:nil];*/
    
  if([TxtNota.text length]==0)
      return;
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    //[self findContact];
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM NOTAS WHERE HOJA=\"%@\" and LIBROID=\"%@\"",
                              _HojaActual,_LibroId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSString *sql;
            NSString *script;
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                //sqlite3_finalize(statement);
                NSLog(@"ya existe una nota en la hoja");
                
                sql = [NSString stringWithFormat:
                       @"UPDATE NOTAS SET NOTA=\"%@\" where HOJA=\"%@\" and LIBROID=\"%@\"",
                       TxtNota.text,_HojaActual,_LibroId];
                //script = [NSString stringWithFormat:@"Visor.borrarSeparador(%@)",_HojaActual];
            } else {
                sql = [NSString stringWithFormat:
                       @"INSERT INTO NOTAS (LIBROID,NOTA,HOJA) VALUES (\"%@\", \"%@\", \"%@\")",
                       _LibroId,TxtNota.text,_HojaActual];
                script = [NSString stringWithFormat:@"Visor.dibujarNota(%@)",_HojaActual];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_db);
            [self saveData:sql];
            [self.webView evaluateJavaScript:script completionHandler:nil];
            //[BtnCerrar sendActionsForControlEvents: UIControlEventTouchUpInside];
            [self ClickCerrar];
            return;
        }
        sqlite3_close(_db);
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view.tag==-1) {
        //your touch was in a uipickerview ... do whatever you have to do
        //Desactiva el pinch zoom
        //[BtnCerrar sendActionsForControlEvents: UIControlEventTouchUpInside];
         [self ClickCerrar];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
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
- (void) buscarNota {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT NOTA FROM NOTAS WHERE LIBROID=\"%@\" and HOJA=\"%@\"",
                              _LibroId,_HojaActual];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *nota = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                /*NSString *script = [NSString stringWithFormat:@"Visor.dibujarRayado(%@,'%@')",hoja,data];
                [self.webView evaluateJavaScript:script completionHandler:nil];*/
                TxtNota.text=nota;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_db);
    }
}
- (BOOL)shouldAutorotate{
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
