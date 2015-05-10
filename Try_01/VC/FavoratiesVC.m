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



@interface FavoratiesVC ()
@property (strong ,nonatomic) UILabel * aLabel;

@property (strong ,nonatomic) UIImageView * imageView;
@end

@implementation FavoratiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@" FavoratiesVC viewDidLoad");
    // Do any additional setup after loading the view.
    NSString *json_url=@"http://courseware.codeschool.com.s3.amazonaws.com/try_ios/level6demo/userProfile.json";
    // 2
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 3
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    
    NSURLSessionDataTask *jsonData = [session dataTaskWithURL: [NSURL URLWithString:json_url]
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                // 1
                                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                if (httpResp.statusCode == 200) {
                                                    
                                                    NSError *jsonError;
                                                    
                                                    // 2
                                                    NSDictionary *notesJSON =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments                                                                             
                                                                                      error:&jsonError];
                                                    
                                                    //NSMutableArray *notesFound = [[NSMutableArray alloc] init];
                                                    NSLog(@"NSURLSessionDataTask: \n %@",notesJSON);
                                                                                                        if (!jsonError) {
                                                        // TODO 2: More coming here!
                                                    }
                                                }
                                            }];
    [jsonData resume];
    
    //NSURL *url = [[NSURL alloc] initWithString:@"http://courseware.codeschool.com.s3.amazonaws.com/try_ios/level6demo/userProfile.json"];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://courseware.codeschool.com.s3.amazonaws.com/try_ios/level6demo/userProfile.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@",  responseObject   );
//        
//        NSLog(@"%@",[responseObject valueForKey:@"city"]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    _aLabel= [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    _aLabel.backgroundColor = [UIColor clearColor];
    _aLabel.font = [UIFont boldSystemFontOfSize:17];
    _aLabel.textAlignment = NSTextAlignmentCenter;
    _aLabel.text = @"a lable";
    [self.view addSubview:_aLabel];
    
    
    [self setUpImageView];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) setUpImageView {
    
    
    // 1
    NSString *imageUrl =
    @"http://cdn2.raywenderlich.com/wp-content/themes/raywenderlich/images/store/profile-page-products/pgsk@2x.png";
    // 2
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 3
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    
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


                   }); }];
    // 4
    [getImageTask resume];

}


-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self    name:SaveNotificationKey object:nil];
}

@end
