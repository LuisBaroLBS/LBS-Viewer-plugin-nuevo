//
//  BookViewer.m
//  LbsViewer
//
//  Created by Cesar LBS on 09/04/24.
//
#import <UIKit/UIKit.h>
#import "BookViewer.h"
#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
#import <objc/runtime.h>

@implementation BookViewer


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Crear una vista principal
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    
    // Crear una etiqueta de texto
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 50)];
    label.text = @"Hola, este es un storyboard creado con código en Objective-C";
    label.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:label];
    
    // Crear un botón
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Haz clic aquí" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 200, self.view.bounds.size.width - 200, 50)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:button];
    
    
    self.view.backgroundColor = UIColor.blueColor;
    
    //NSURL *myURL = [NSURL URLWithString:@"capacitor://localhost"];
    //NSURLRequest *myRequest = [NSURLRequest requestWithURL:self.productURL];
    
    self.viewController = [CAPBridgeViewController new];
    //self.viewController = [[CAPBridgeViewController alloc] init];
    //self.viewController = [CAPPlugin new];
    [self.viewController setServerBasePathWithPath:self.productURL];
    self.viewController.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
 
    WKWebView* uiWebView = (WKWebView*)self.viewController.webView;
    /*   uiWebView.scrollView.delegate=self;
       uiWebView.scrollView.scrollEnabled = true;
       uiWebView.scrollView.bouncesZoom=false;
       uiWebView.scrollView.bounces=false;
       uiWebView.scrollView.maximumZoomScale=1.0;
       uiWebView.scrollView.showsHorizontalScrollIndicator=true;
       uiWebView.hidden=true;*/
    //NSURL *myURL = [NSURL URLWithString:self.productURL];
    //[uiWebView loadRequest:[NSURLRequest requestWithURL:myURL]];
 

    
    [mainView addSubview:_viewController.view];
    [mainView sendSubviewToBack:self.viewController.view];
    
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Botón clickeado");
    
    WKWebView* uiWebView = (WKWebView*)self.viewController.webView;
    //NSURL *myURL = [NSURL URLWithString:self.productURL];
    //[uiWebView loadRequest:[NSURLRequest requestWithURL:myURL]];
    NSString* open = self.productURL;
    NSLog(@"libroPath = %@",open);
    [self.viewController setServerBasePathWithPath:open];
}

/*- (void)loadView {
    NSString *urlString = @"https://www.google.com.mx/";
    
        if (urlString) {
            NSURL *url = [NSURL URLWithString:urlString];
 
            if (!self.webView) {
                self.webView = [[WKWebView alloc] initWithFrame:self.bridge.viewController.view.bounds];
                //self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
                self.webView.navigationDelegate = self;
                [self.bridge.viewController.view addSubview:self.webView];
            }
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
}*/

/*- (void)openLibro:(NSString *)url token:(NSString *)token libroId:(NSString *)libroId {
    NSString *urlString = @"https://www.google.com.mx/";
    
        if (urlString) {
            NSURL *url = [NSURL URLWithString:urlString];
     
                if (!self.webView) {
                    DispatchQueue.main.async {
                        self.webView = [[WKWebView alloc] initWithFrame:self.bridge.viewController.view.bounds];
                        //self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
                        self.webView.navigationDelegate = self;
                        [self.bridge.viewController.view addSubview:self.webView];
                    }
                    
                }
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            
        }
}
 


- (void)loadURL:(NSURL *)url {
}

- (void)loadHTMLString:(NSString *)htmlString {
}

 */
/*@synthesize pluginMethods;

@synthesize identifier;

@synthesize jsName;*/

@end
