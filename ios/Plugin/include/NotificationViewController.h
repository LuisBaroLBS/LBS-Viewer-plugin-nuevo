//
//  NotificationViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 15/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <sqlite3.h>

@interface NotificationViewController : UIViewController{
       IBOutlet UITextView  *TxtNota;
       IBOutlet UILabel     *LblFondo;
       IBOutlet UILabel     *LblLinea;
       IBOutlet UILabel     *LblNota;
    
       IBOutlet UIButton   *BtnEliminar;
       //IBOutlet UIButton   *BtnCerrar;
       IBOutlet UIButton   *BtnGuardar;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite,assign) WKWebView *webView;
@property (nonatomic, readwrite,assign) NSString *DatosNota;
@property (nonatomic, readwrite,assign) NSString *LibroId;
@property (nonatomic, readwrite,assign) NSString *HojaActual;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *db;

-(IBAction)ClickCerrar:(id)sender;
-(IBAction)ClickEliminar:(id)sender;
-(IBAction)ClickGuardar:(id)sender;

@end

