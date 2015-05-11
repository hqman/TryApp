//
//  ProfileVC.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "ProfileVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Person.h"
#import "RACEXTScope.h"
#import "HWCricleView.h"
#import "HWLayoutVC.h"
#import "Masonry.h"
#import "QBImagePickerController.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#include<AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Common.h"


@interface ProfileVC ()<UINavigationBarDelegate,UIImagePickerControllerDelegate,ABPeoplePickerNavigationControllerDelegate ,QBImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *aButton;
@end

@implementation ProfileVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        //self.tabBarItem.image = [UIImage imageNamed:@"first_normal"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // button event 触发 事件 & 实现
    
    @weakify(self)
    [[self.aButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         Person *p=[ [Person alloc]initWithName:@"Wang Kai" age:33 ];
         [p doSomething ];
         self.title = @"Profile";
         NSLog(@"click me");
     }];
    
    
    UIView *redView=[UIView new];
    redView.backgroundColor=[UIColor colorWithRed:1.000 green:0.329 blue:0.633 alpha:1.000];
    [self.view addSubview:redView];
    
    
    WS(ws)
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        //make.leading.equalTo(ws.view).with.offset(50);
        make.left.equalTo(@50);
        //        make.centerX.equalTo(ws.view.mas_centerX);
        //        make.centerY.equalTo(ws.view.mas_centerY);
        make.height.mas_equalTo(@50);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    [self  addNaturalOnTopEffectWithMaximumRelativeValue:50 view:redView];
    //[self  addNaturalBelowEffectWithMaximumRelativeValue:25 view:_aButton];
    
    //draw view
    // HWCricleView *subView=[[HWCricleView alloc]initWithFrame:self.view.bounds];
    //subView.backgroundColor=[UIColor redColor];
    // [self.view addSubview:subView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)go:(id)sender {
    HWLayoutVC *vc=[HWLayoutVC new];
    
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock=^(NSString *backs){
        NCLog(@" i am about to go  %@",backs);
    };
    [self presentViewController:vc animated:YES completion:^{
        NCLog(@" i am about to go  ");
    } ];
}


#pragma mark - ImagePicker

- (IBAction)takePIc:(id)sender {
    
    
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:nil];
    [actionSheet bk_addButtonWithTitle:@"相册选择" handler:nil];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet bk_setDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        switch (index) {
            case 0:{
                //拍照
                UIImagePickerController  *pvc=[UIImagePickerController new];
                pvc.delegate=self;
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    
                    pvc.sourceType=UIImagePickerControllerSourceTypeCamera;
                }else{
                    pvc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    
                }
                if([[[UIDevice
                      currentDevice] systemVersion] floatValue]>=8.0) {
                    
                    pvc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    
                }
                [self presentViewController:pvc animated:YES completion:nil];
            }
                break;
            case 1:{
                //相册
                QBImagePickerController *pvc = [[QBImagePickerController alloc] init];
                pvc.filterType = QBImagePickerControllerFilterTypePhotos;
                pvc.allowsMultipleSelection=NO;
                pvc.delegate = self;
               // pvc.allowsMultipleSelection = YES;
                //pvc.maximumNumberOfSelection = 6;
                [self presentViewController:pvc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:weakSelf.view];
    
    
    
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    _myImageView.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@" %@ ",@"cancel pick");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark QBImagePickerControllerDelegate


- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"Selected asset:");
    NSLog(@"%@", asset);
        UIImage *highQualityImage = [UIImage fullResolutionImageFromALAsset:asset];
    
        highQualityImage = [highQualityImage scaledToSize: [UIScreen mainScreen].bounds.size highQuality:YES];
    
        _myImageView.image=highQualityImage;
    
        [self dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
//{
//    NSLog(@"Selected assets:");
//    NSLog(@"%@", assets);
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)addNaturalOnTopEffectWithMaximumRelativeValue:(CGFloat)maximumRealtiveValue view:(UIView *)view{
    UIInterpolatingMotionEffect* motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(-maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @(maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(-maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
}

- (void)addNaturalBelowEffectWithMaximumRelativeValue:(CGFloat)maximumRealtiveValue view:(UIView *)view{
    UIInterpolatingMotionEffect* motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(-maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @(-maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
}

#pragma mark - AddressBook action



//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
//选择姓名后 继续选择号码
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

//选取 后处理
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    
    //    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    //    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    //
    //    if ([phoneNO hasPrefix:@"+"]) {
    //        phoneNO = [phoneNO substringFromIndex:3];
    //    }
    //
    //    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    NSLog(@"%@", phoneNO);
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
    NSDictionary *dic = @{@"fullname": [NSString stringWithFormat:@"%@%@", firstName, lastName]
                          ,@"phone" : phone};
    
    NSLog(@" %@ ",dic);
    _phoneLabel.text=[firstName stringByAppendingString:phone];
    
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return;
}
- (IBAction)getPhone:(id)sender {
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - test

-(void) setUpActionSheet{
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"do1" handler:nil];
    [actionSheet bk_addButtonWithTitle:@"do2" handler:nil];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet bk_setDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        switch (index) {
            case 0:
                NSLog(@" do1 " );
                break;
            case 1:
                NSLog(@" do2 " );
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:weakSelf.view];
}




@end
