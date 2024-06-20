#import <UIKit/UIKit.h>
#import <Capacitor/CAPPlugin.h>
#import <Capacitor/CAPBridgedPlugin.h>
#import <WebKit/WebKit.h>

@class CAPPluginCall;

@interface LbsViewerPlugin : CAPPlugin <CAPBridgedPlugin>

//@property (nonatomic, strong) WKWebView *webView;

- (void)echo:(CAPPluginCall *)call;
- (void)openBook:(CAPPluginCall * )call;
- (void)FabsHandler:(CAPPluginCall * )call;
- (void)CambioHoja:(CAPPluginCall * )call;
- (void)TotalHojas:(CAPPluginCall * )call;


@end

