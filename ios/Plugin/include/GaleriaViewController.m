//
//  GaleriaViewController.m
//  TestWebView
//
//  Created by App Alfa LBS on 29/05/18.
//  Copyright © 2018 App Alfa LBS. All rights reserved.
//

#import "GaleriaViewController.h"
#import "FullScreenViewController.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface GaleriaViewController ()

@end

@implementation GaleriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.view.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.60];
    //collection.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.00];
    
    
    if (IPAD) {
        // iPad
        NSLog(@" es un ipad");
        
        Header.center           = CGPointMake((screenWidth/2), (screenHeight/2)-290);
        collection.center        = CGPointMake((screenWidth/2), (screenHeight/2)-40);
    } else {
        NSLog(@" es un celular");
        
        Header.frame            = CGRectMake(Header.frame.origin.x,Header.frame.origin.y, 300,42);
        collection.frame            = CGRectMake(collection.frame.origin.x,collection.frame.origin.y, 300,458);
        
        Header.center           = CGPointMake((screenWidth/2), (screenHeight/2)-290+50);
        collection.center        = CGPointMake((screenWidth/2), (screenHeight/2)-40+50);
        
        BtnSeleccionar.frame = CGRectMake(Header.frame.origin.x + 205,BtnSeleccionar.frame.origin.y, 80,30);
    }
    
    /*recipeImages = [NSArray arrayWithObjects:@"IMG_0001.JPG",@"IMG_0002.JPG",@"IMG_0003.JPG",
                    @"microsoft.png",@"hp.jpg",@"cisco.png",@"android.png",@"xcode.jpg",@"ionic.jpg",@"motorola.png", nil];*/
    
    self.contentView.layer.cornerRadius = 3.0;
    
    
    selectedImages = [NSMutableArray array];
    
    [self cargarImagenes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recipeImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     cell.layer.borderColor=[[UIColor redColor] CGColor];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    NSString *FinalPathTemp = [_PathLibro substringWithRange:NSMakeRange(5, _PathLibro.length -5 )];
    NSString *FinalPath=[FinalPathTemp stringByAppendingPathComponent:_HojaActual];
    
    NSLog(@"FinalPath = %@",FinalPath);
    NSString *Imagen=[FinalPath stringByAppendingPathComponent:[_recipeImages objectAtIndex:indexPath.row]];
  
    
    recipeImageView.image = [UIImage imageWithContentsOfFile:Imagen];
   
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return CGSizeMake(100,100);
        
    }
    else
    {
        NSLog(@"width %f",self.view.frame.size.width);
        return CGSizeMake(105, 105);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if(seleccionActivo)
    {
        UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
        NSString *selectedRecipe =[_recipeImages objectAtIndex:indexPath.row];
        cell.layer.opacity = 0.5;
        
        // Add the selected item into the array
        [selectedImages addObject:selectedRecipe];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Row Tap" message:[NSString stringWithFormat:@"Row : %ld selected", indexPath.row + 1] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        
        //[self presentViewController:alert animated:YES completion:nil];
        
        FullScreenViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenViewController"];
        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        NSString *FinalPathTemp = [_PathLibro substringWithRange:NSMakeRange(5, _PathLibro.length -5 )];
        NSString *FinalPath=[FinalPathTemp stringByAppendingPathComponent:_HojaActual];
        NSString *Imagen=[FinalPath stringByAppendingPathComponent:[_recipeImages objectAtIndex:indexPath.row]];
        
        controller.ImgName=Imagen;
        
        //ivc.label = self.label.text;
        //[self.navigationController pushViewController:ivc animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
  
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view.tag==-1) {
        //your touch was in a uipickerview ... do whatever you have to do
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void) cargarImagenes {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray *imagenesBD = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT PATH FROM IMAGENES WHERE LIBROID=\"%@\" AND HOJA=\"%@\"",
                              _LibroId,_HojaActual];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_db,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *path = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                [imagenesBD addObject:path];
                //[controller.recipeImages addObject:path];
            }
            sqlite3_finalize(statement);
            self.recipeImages=imagenesBD;
        }
        sqlite3_close(_db);
    }
    
    //controller.recipeImages=_ImagenesGaleria;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
}
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (seleccionActivo) {
        NSString *deSelectedRecipe = [_recipeImages objectAtIndex:indexPath.row];
        [selectedImages removeObject:deSelectedRecipe];
        
        UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.opacity = 1.0;
    }
}
-(IBAction)ClickSeleccion:(id)sender{
    NSLog(@"Click Seleccion");
    seleccionActivo= !seleccionActivo;
    
    if(seleccionActivo){
        //Presiono seleccionar
        [sender setTitle:@"Cancelar" forState:UIControlStateNormal];
        
        BtnEliminar.hidden = false;
        collection.allowsMultipleSelection=YES;
    }
    else{
        //Cuando presiona cancelar
        
        // Deselect all selected items
        for(NSIndexPath *indexPath in collection.indexPathsForSelectedItems) {
            //[collection deselectItemAtIndexPath:indexPath animated:NO];
            UICollectionViewCell *cell =[collection cellForItemAtIndexPath:indexPath];
            cell.layer.opacity = 1.0;
        }
        
        BtnEliminar.hidden = true;
        // Remove all items from selectedRecipes array
        [selectedImages removeAllObjects];
        collection.allowsMultipleSelection=NO;
        [sender setTitle:@"Seleccionar" forState:UIControlStateNormal];
    }
}
-(IBAction)ClickEliminar:(id)sender{
    NSLog(@"Click Eliminar");
    if ([selectedImages count] == 0)
        return;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Alfa"
                              message:@"¿Estas seguro de eliminar las imagenes seleccionadas?"
                              delegate:self
                              cancelButtonTitle:@"Eliminar"
                              otherButtonTitles:nil];
    
    [alertView addButtonWithTitle:@"Cancelar"];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSMutableArray *tempRecipeImages= [NSMutableArray array];
    
    if (buttonIndex == 0) {
        NSLog(@"Click eliminar");
        
        for(NSIndexPath *indexPath in collection.indexPathsForVisibleItems) {
            
            UICollectionViewCell *cell =[collection cellForItemAtIndexPath:indexPath];
            cell.layer.opacity = 1.0;
            
            if(cell.selected==NO){
                NSString *item = [_recipeImages objectAtIndex:indexPath.row];
                [tempRecipeImages addObject:item];
            }
            else {
                NSString *img = [_recipeImages objectAtIndex:indexPath.row];
                
                NSString *FinalPathTemp = [_PathLibro substringWithRange:NSMakeRange(5, _PathLibro.length -5 )];
                NSString *FinalPath=[FinalPathTemp stringByAppendingPathComponent:_HojaActual];
                NSString *imagePath=[FinalPath stringByAppendingPathComponent:[_recipeImages objectAtIndex:indexPath.row]];
                
                [[NSFileManager defaultManager] removeItemAtPath: imagePath error: nil];
                
                NSString *sql = [NSString stringWithFormat:
                                      @"DELETE FROM IMAGENES WHERE PATH=\"%@\" AND LIBROID=\"%@\"",
                                      img,_LibroId];
                 [self saveData:sql];
            }
        }
        
        
        [_recipeImages removeAllObjects];
        _recipeImages=tempRecipeImages;
        [collection reloadData];
        
        [BtnSeleccionar sendActionsForControlEvents: UIControlEventTouchUpInside];
    } else if (buttonIndex == 1) {
        NSLog(@"Click Cancelar");
    }
}

- (void) saveData : insertSQL{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_db) == SQLITE_OK)
    {
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_db, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //_status.text = @"Contact added";
            //_name.text = @"";
            //_address.text = @"";
            //_phone.text = @""
            NSLog(@"Insertado con exito");
        } else {
            //_status.text = @"Failed to add contact";
            NSLog(@"Error al insertar");
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_db));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
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
