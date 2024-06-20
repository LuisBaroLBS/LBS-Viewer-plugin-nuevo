//
//  IndiceViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 21/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "IndiceViewController.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface IndiceViewController ()

@end

@implementation IndiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    NSLog(@"Indice Cargado");
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.60];
    
    
    if (IPAD) {
        // iPad
        NSLog(@" es un ipad");
        Header.center           = CGPointMake((screenWidth/2), (screenHeight/2)-290);
        TableView.center        = CGPointMake((screenWidth/2), (screenHeight/2)-40);
    } else {
        NSLog(@" es un celular");
        Header.frame            = CGRectMake(Header.frame.origin.x,Header.frame.origin.y, 300,42);
        TableView.frame            = CGRectMake(TableView.frame.origin.x,TableView.frame.origin.y, 300,458);
        
        Header.center           = CGPointMake((screenWidth/2), (screenHeight/2)-290+50);
        TableView.center        = CGPointMake((screenWidth/2), (screenHeight/2)-40+50);
    }
    
  
    self.contentView.layer.cornerRadius = 3.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Indice count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indice=@"";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    indice = [indice stringByAppendingString: [_Indice objectAtIndex: indexPath.row]];
    cell.textLabel.text =indice;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indice= [_Indice objectAtIndex:indexPath.row];
    NSString *peticion=[NSString stringWithFormat:@"Visor.handleIndiceNative('%@')",indice];
    
    [self.webView evaluateJavaScript:peticion completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view.tag==-1) {
        //your touch was in a uipickerview ... do whatever you have to do
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
}
- (BOOL)shouldAutorotate{
    return NO;
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
