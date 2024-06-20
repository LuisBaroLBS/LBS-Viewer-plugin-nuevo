//
//  BookViewer.h
//  LbsViewer
//
//  Created by Cesar LBS on 09/04/24.
//

#import <UIKit/UIKit.h>
#import <Capacitor/CAPPlugin.h>
#import <Capacitor/CAPBridgedPlugin.h>
#import <WebKit/WebKit.h>
#import <Capacitor/Capacitor.h>
#import <Capacitor/CAPInstanceConfiguration.h>


@class CAPPluginCall;

//@interface BookViewer : CAPPlugin <CAPBridgedPlugin>
@interface BookViewer : UIViewController<UIGestureRecognizerDelegate>
//@interface BookViewer : CAPBridgeViewController


// Declare a property for WKWebView
//@property (nonatomic, strong) WKWebView *webView;
//@property (retain, nonatomic) CAPBridgeViewController *viewController;
@property (retain, nonatomic) CAPBridgeViewController *viewController;
//@property (retain, nonatomic) CAPPlugin *viewController;
@property (nonatomic, strong) CAPInstanceConfiguration *config;
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
//@property (nonatomic) sqlite3 *db;


// Declare any methods related to WKWebView functionality
//- (void)loadURL:(NSURL *)url;
//- (void)loadHTMLString:(NSString *)htmlString;
//- (void)openLibro:(NSString *)url token:(NSString *)token libroId:(NSString *)libroId;

@end
