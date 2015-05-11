//
//  FavoratiesVC.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "FavoratiesVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "Person.h"
#import "HWItemCell.h"
#import "MBProgressHUD.h"
static NSString *CellIdentifier = @"HWItemCell";


typedef int (^CompleteHandler)(UIImageView *image_view);


@interface FavoratiesVC ()<UITableViewDataSource>
@property (strong ,nonatomic) UILabel * aLabel;

@property (strong ,nonatomic) UIImageView * imageView;
@end

@implementation FavoratiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Loading...";
    //定义一个block
    [self setUpImageView:^int(UIImageView *image_view) {
        sleep(3);
        [hud hide:YES];
        NSLog(@" %@ ",image_view.image);
        return 1;
    }];
    
    
   
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UINib *nib=[UINib nibWithNibName:CellIdentifier bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflesh:) name:SaveNotificationKey object:nil];
    }

-(void) reflesh:(NSNotification*)aNotification{
    NSString *name = [aNotification object];
    NSLog(@"NSNotificationCenter reflesh ....");
    _aLabel.text =name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Favoraties";
        //self.tabBarItem.image = [UIImage imageNamed:@"first_normal"];
    }
    return self;
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *CellIdentifier = @"HWItemCell";
    HWItemCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.selectionStyle=UITableViewCellStyleValue1;
//    cell.textLabel.text=@"wangkai";
//    cell.detailTextLabel.text=@"In a storyboard-based application  do a little preparation before navigation";
    
    cell.nameLabel.text=@"wangkai";
    cell.snLabel.text=@"23434635463";
    cell.valueLabel.text=@"2.3";
    cell.thumbView.image=[UIImage imageNamed:@"placeholder"];
    tableView.rowHeight=100;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
    
}
    
/*
#pragma mark - Navigation
 

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)test{
    //定义
    void (^MyBlock)(id,NSUInteger ,BOOL*)=^(id obj,NSUInteger idx ,BOOL *stop){
        NSLog(@" %@ ",obj);
    };
    //使用
    BOOL stop;
    MyBlock(@"ttt",1,&stop);
    
    //作为方法参数
    NSArray *citys=@[@"suzhou",@"hangzhou"];
    [citys enumerateObjectsUsingBlock:MyBlock];
    
    //内联用法
    [citys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@" %@ ",obj);
    }];

    
}
//-(void) setUpImageView : (int (^)(UIImageView *image_view)) completionCallback{
-(void) setUpImageView : (CompleteHandler) completionCallback{

    
    
    // 1
    NSString *imageUrl =
    @"http://cdn2.raywenderlich.com/wp-content/themes/raywenderlich/images/store/profile-page-products/pgsk@2x.png";
    // 2
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 3
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    //NSLog(@" %@ ",<#v#>);
    
    // 1
    NSURLSessionDownloadTask *getImageTask =
    [session downloadTaskWithURL:[NSURL URLWithString:imageUrl]
               completionHandler:^(NSURL *location, NSURLResponse *response,
                                   NSError *error) {
                   // 2
                   UIImage *downloadedImage = [UIImage imageWithData:
                                               [NSData dataWithContentsOfURL:location]];
                   //3
                   dispatch_async(dispatch_get_main_queue(), ^{
                       // do stuff with image
                       _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
                       _imageView.image = downloadedImage;
                       NSLog(@"mmmmmmm%@",downloadedImage);
                       [self.view addSubview:_imageView];
                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                       //call block
                       int back=completionCallback(_imageView);
                       NSLog(@" %d",back);
                       
                   }); }];
    // 4
    [getImageTask resume];

}


-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self    name:SaveNotificationKey object:nil];
}

@end
