//
//  FullScreenViewController.h
//  TestWebView
//
//  Created by App Alfa LBS on 29/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenViewController : UIViewController <UIScrollViewDelegate>{
    IBOutlet UIImageView *Imagen;
    IBOutlet UIScrollView *Scroll;
    IBOutlet UIButton    *FabAtras;
}
@property (weak, nonatomic) NSString *ImgName;

-(IBAction)ClickAtras:(id)sender;


@end
