#import "LbsViewer.h"
#import "BookViewer.h"
#import "ViewController1.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <Capacitor/Capacitor.h>
#import <Capacitor/Capacitor-Swift.h>
#import <Capacitor/CAPBridgedPlugin.h>
#import <Capacitor/CAPBridgedJSTypes.h>




@implementation LbsViewerPlugin
ViewController *yourViewController;

- (void) echo: (CAPPluginCall *)call {
    NSString *message = call.options[@"value"];
    
    NSLog(@"Aqui %@", message);
   
     /*   if (urlString) {
            
     
                if (!self.webView) {
                    self.webView = [[WKWebView alloc] initWithFrame:self.bridge.viewController.view.bounds];
                    self.webView.navigationDelegate = self;
                    [self.bridge.viewController.view addSubview:self.webView];
                }
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            
        }*/
}

- (void) openBook: (CAPPluginCall *)call {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        /*NSString *url = call.options[@"url"];
         NSString *token = call.options[@"token"];
         NSString *libroId = call.options[@"libroId"];
         NSString *urlString = @"file:///Users/cesar/Library/Developer/CoreSimulator/Devices/4FA7E47E-A87B-4D98-B80F-6C4CD1C5A46F/data/Containers/Data/Application/94356938-2543-4076-9E1C-2D9890E9FB10/Library/NoCloud/books2020/Libro1833";
         NSURL *_url = [NSURL URLWithString:urlString];
         
         NSLog(@"Aqui %@", url);*/
        
        NSString* PathLibro = call.options[@"url"];
       // NSString* LibroId   = @"1885";
        NSString* LibroId = call.options[@"libroId"];
        NSString* App       = @"Test";
        NSString* TokenLBS  = call.options[@"token"];
        
        NSLog(@"Aqui %@",PathLibro);
        NSLog(@"Aqui LibroId %@",LibroId);
        
        /***PAth a mis documentos*/
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        docsDir= [[NSString alloc]
                  initWithString: [docsDir stringByAppendingPathComponent:@"NoCloud"]];
        docsDir= [[NSString alloc]
                  initWithString: [docsDir stringByAppendingPathComponent:@"books2020"]];
        
        NSArray *arrayPathLibro = [PathLibro componentsSeparatedByString:@"/"];
        NSString *NombreLibro=arrayPathLibro[[arrayPathLibro count]-1];
        
        NSLog(@"libro = %@",NombreLibro);
        
        // Build the path to the database file
        NSString *pathLibroReal = [[NSString alloc]
                                   initWithString: [docsDir stringByAppendingPathComponent:
                                                    NombreLibro]];
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
        yourViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        // Código para inicializar o modificar la interfaz de usuario
        //  BookViewer *yourViewController = [[BookViewer alloc] init];
        
        yourViewController.productURL= [NSString stringWithFormat: @"capacitor://localhost/_capacitor_file_%@/Libro%@/indexNew.html", pathLibroReal, LibroId];
        
        NSLog(@"libroPath = %@",yourViewController.productURL);
        yourViewController.App = App;
        yourViewController.TokenLBS = TokenLBS;
        yourViewController.LibroId=LibroId;
        
        //Linea agregada para ios 13
        yourViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.bridge.viewController presentViewController:yourViewController animated:YES completion:nil];
        
        
        //yourViewController.LibroId=PathLibro;
        
        //viewContVar.modalPresentationStyle = UIModalPresentationCustom;
        //[self.bridge.viewController presentViewController:viewContVar animated:YES completion:nil];
        /*   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BookStoryUI" bundle:nil];
         viewContVar = [storyboard   instantiateViewControllerWithIdentifier:@"BookViewer"];
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
         dispatch_get_main_queue(), ^{
         });*/
    });
}

- (void)FabsHandler:(CAPPluginCall *)call{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"estado: %@", call.options);
        NSNumber *estado = call.options[@"key1"];
        NSLog(@"estado: %@", estado);
     //   ViewController *yourViewController = [[ViewController alloc] init];
        NSString *message = call.options[@"value"];
        if([estado intValue] == 1) {
            [yourViewController FabsHandlerOpen];
        } else if([estado intValue] == 0 || [estado intValue] == 2) {
            [yourViewController FabsHandlerClose: estado];
        }
    });
}

- (void)CambioHoja:(CAPPluginCall*)call
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        yourViewController.HojaActual=call.options[@"numeroHoja"];
        [yourViewController CambioHoja];

    });
}

- (void)GuardarRayado:(CAPPluginCall*)call
{
    dispatch_async(dispatch_get_main_queue(), ^{

    NSString *Hoja = call.options[@"numeroHoja"];
    NSString *Data = call.options[@"rayado"];
    
    const char *dbpath = [yourViewController.databasePath UTF8String];
    sqlite3_stmt *statement;
    
    sqlite3 *db=yourViewController.db;
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
            NSLog(@"Aqui LibroId %@",yourViewController.LibroId);
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT DATA FROM RAYADO WHERE LIBROID=\"%@\" AND HOJA=\"%@\"",
                                  yourViewController.LibroId,Hoja];
            NSString *sql;
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_ROW)
                {
                    sql = [NSString stringWithFormat:
                                     //@"INSERT INTO RAYADO (LIBROID,HOJA,DATA) VALUES (\"%@\", \"%@\",\"%@\")",
                                     @"UPDATE RAYADO SET DATA='%@' WHERE LIBROID='%@' AND HOJA='%@'",
                                     Data,yourViewController.LibroId,Hoja];
                    sqlite3_finalize(statement);
                    sqlite3_close(db);
                    //[self saveData:sql];
                }
                else
                {
                    sql = [NSString stringWithFormat:
                                     //@"INSERT INTO RAYADO (LIBROID,HOJA,DATA) VALUES (\"%@\", \"%@\",\"%@\")",
                                     @"INSERT INTO RAYADO (LIBROID,HOJA,DATA) VALUES ('%@', '%@','%@')",
                                     yourViewController.LibroId,Hoja,Data];
                    //[self saveData:sql];
                    sqlite3_finalize(statement);
                    sqlite3_close(db);
                }
                [yourViewController saveData:(sql)];
            }
    }
  });
}

- (void)GuardarSubrayado:(CAPPluginCall*)call
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *Hoja = call.options[@"numeroHoja"];
    NSString *Data = call.options[@"subrayado"];
    
    const char *dbpath = [yourViewController.databasePath UTF8String];
    sqlite3_stmt *statement;
    
    sqlite3 *db=yourViewController.db;
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT DATA FROM SUBRAYADO WHERE LIBROID=\"%@\" AND HOJA=\"%@\"",
                              yourViewController.LibroId,Hoja];
        NSString *sql;
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                sql = [NSString stringWithFormat:
                       //@"INSERT INTO RAYADO (LIBROID,HOJA,DATA) VALUES (\"%@\", \"%@\",\"%@\")",
                       @"UPDATE SUBRAYADO SET DATA='%@' WHERE LIBROID='%@' AND HOJA='%@'",
                       Data,yourViewController.LibroId,Hoja];
                sqlite3_finalize(statement);
                sqlite3_close(db);
                //[self saveData:sql];
            }
            else
            {
                sql = [NSString stringWithFormat:
                       //@"INSERT INTO RAYADO (LIBROID,HOJA,DATA) VALUES (\"%@\", \"%@\",\"%@\")",
                       @"INSERT INTO SUBRAYADO (LIBROID,HOJA,DATA) VALUES ('%@', '%@','%@')",
                       yourViewController.LibroId,Hoja,Data];
                //[self saveData:sql];
                sqlite3_finalize(statement);
                sqlite3_close(db);
            }
            [yourViewController saveData:(sql)];
        }
    }
  });
}

- (void)domDidLoad:(CAPPluginCall*)call
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [yourViewController pageDidLoad];

    });
}

- (void)TotalHojas:(CAPPluginCall*)call
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = call.options[@"totalHojas"];
        yourViewController.TotalPaginas=[msg integerValue];
    });
}

- (void)mostrarBotonPanelMaestro:(CAPPluginCall*)call
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* estado = call.options[@"key1"];
        
        [yourViewController mostrarBotonPanelMaestro: estado];
    });
}
- (void)TomarFoto:(CAPPluginCall*)call{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* IdImg = call.options[@"key1"];
        
        // NSString* ejercicio = [msg objectAtIndex:0];
        
        [yourViewController TomarFoto: IdImg];
    });
}
- (void)EliminarFoto:(CAPPluginCall*)call{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* IdImg = call.options[@"key1"];
        
        [yourViewController EliminarFoto: IdImg];
    });
}
- (void)openPlayer:(CAPPluginCall*)call{
        dispatch_async(dispatch_get_main_queue(), ^{
        //NSString* IdImg = [command.arguments objectAtIndex:0];
        
        [yourViewController openPlayer];
    });
}

-  (void)abrirLink:(CAPPluginCall*)call{
        dispatch_async(dispatch_get_main_queue(), ^{
        NSString *link = call.options[@"link"];
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:link];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    });    
}

- (void)deshabilitarBotonesNativos:(CAPPluginCall*)call{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *isTeacherB = call.options[@"key1"];
        NSLog(@"estado: %@", isTeacherB);
        
        [yourViewController setIsTeacherBook:isTeacherB];
    });
}

@end



