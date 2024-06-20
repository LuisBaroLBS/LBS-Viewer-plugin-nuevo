//
//  FullScreenViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 29/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()

@end

@implementation FullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Imagen.clipsToBounds = YES;
    Imagen.image=[UIImage imageWithContentsOfFile:_ImgName];
    Scroll.minimumZoomScale=1.0;
    Scroll.maximumZoomScale=6.0;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    FabAtras.center     = CGPointMake(50,50);
    
    
    [self.view sendSubviewToBack:Scroll];
   //[self.view bringSubviewToFront:FabAtras];
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:200];
}
-(IBAction)ClickAtras:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
