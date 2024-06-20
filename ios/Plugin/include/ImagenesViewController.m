//
//  ImagenesViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 28/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "ImagenesViewController.h"

@interface ImagenesViewController ()

@end

@implementation ImagenesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Imagenes Cargado");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.60];
    
    Header.center           = CGPointMake((screenWidth/2), (screenHeight/2)-290);
    TableView.center        = CGPointMake((screenWidth/2), (screenHeight/2)-40);
    
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
    return [self.Imagenes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indice=@"• ";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    indice = [indice stringByAppendingString: [_Imagenes objectAtIndex: indexPath.row]];
    cell.textLabel.text =indice;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Row Tap" message:[NSString stringWithFormat:@"Row : %ld selected", indexPath.row + 1] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view.tag==-1) {
        //your touch was in a uipickerview ... do whatever you have to do
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
