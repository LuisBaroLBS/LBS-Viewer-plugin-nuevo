#import <WebKit/WebKit.h>

@interface MyWKWebView : WKWebView <WKNavigationDelegate>

@end

@implementation MyWKWebView

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Tu lógica personalizada aquí...
    
    // Llamada al método original del delegado de navegación, si es necesario
    if ([self.navigationDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.navigationDelegate webView:webView didFinishNavigation:navigation];
    }
}

@end
