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
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    CGImageSourceRef imgSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CFStringRef UTI = CGImageSourceGetType(imgSource);
    
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSLog(@"%@", dict);
    
    NSMutableData *newImageData = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge  CFMutableDataRef)newImageData, UTI, 1, NULL);

    if(!destination) {
        NSLog(@"*** Could not create image destination ***");
        return;
    }
    
    NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (metadata) {
        [metadata setValue:nil forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    
    CGImageDestinationAddImageFromSource(destination, imgSource, 0, (__bridge  CFDictionaryRef) metadata);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);

    if(!success) {
        NSLog(@"*** Could not create data from image destination ***");
        return ;
    }
    
    CFRelease(imgSource);
    CFRelease(destination);
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imgSource, 0, NULL);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

@end
