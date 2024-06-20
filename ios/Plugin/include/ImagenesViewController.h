//
//  ImagenesViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 28/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagenesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UILabel     *LblFondo;
    IBOutlet UILabel     *LblNota;
    IBOutlet UITableView *TableView;
    IBOutlet UIView      *Header;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, readwrite,strong) NSMutableArray *Imagenes;
//@property (nonatomic, readwrite,assign) NSMutableArray *Indice;

@end
