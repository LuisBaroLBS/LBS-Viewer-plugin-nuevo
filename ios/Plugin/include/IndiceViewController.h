//
//  IndiceViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 21/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface IndiceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UILabel     *LblFondo;
    IBOutlet UILabel     *LblNota;
    IBOutlet UITableView *TableView;
    IBOutlet UIView      *Header;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, readwrite,strong) NSArray *Indice;
@property (nonatomic, readwrite,assign) WKWebView *webView;
//@property (nonatomic, readwrite,assign) NSMutableArray *Indice;

@end

