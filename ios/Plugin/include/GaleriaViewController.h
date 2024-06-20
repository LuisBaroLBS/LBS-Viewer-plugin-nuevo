//
//  GaleriaViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 29/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <sqlite3.h>

@interface GaleriaViewController : UIViewController{
    IBOutlet UICollectionView *collection;
    IBOutlet UIView      *Header;
    IBOutlet UILabel     *LblNota;
    
    NSMutableArray *selectedImages;
    IBOutlet UIButton   *BtnSeleccionar;
    IBOutlet UIButton   *BtnEliminar;
    BOOL seleccionActivo;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSMutableArray *recipeImages;
//@property (strong, nonatomic) NSArray *recipeImages;
//@property (nonatomic, readwrite,assign)  NSString *PathLibro;
@property (nonatomic, readwrite)  NSString *PathLibro;
@property (nonatomic, readwrite,assign)  NSString *HojaActual;
@property (nonatomic, readwrite,assign) WKWebView *webView;
@property (nonatomic, readwrite,assign) NSString *LibroId;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *db;

@end

