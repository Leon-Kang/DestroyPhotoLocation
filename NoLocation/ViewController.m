//
//  ViewController.m
//  NoLocation
//
//  Created by 康梁 on 2017/5/9.
//  Copyright © 2017年 LeonKang. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

static NSString * const BSCollectionName = @"bsCollection";

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *getPhotoButton;
@property (nonatomic, strong) UIImagePickerController *imagePiker;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initImagePiker];
    [_getPhotoButton addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initImagePiker {
    _imagePiker = [[UIImagePickerController alloc] init];
    _imagePiker.delegate = self;
    _imagePiker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePiker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    _imagePiker.allowsEditing = NO;
}
- (void)getPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentViewController:_imagePiker animated:YES completion:nil];
    }
}

#pragma mark - Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

@end
