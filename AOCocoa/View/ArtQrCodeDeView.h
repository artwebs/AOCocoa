//
//  ArtQrCodeDeView.h
//  BusinessCard
//
//  Created by artwebs on 14-7-4.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtView.h"
#import <AVFoundation/AVFoundation.h>
@protocol ArtQrCodeDeViewDelegate;
@interface ArtQrCodeDeView : ArtView<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput *captureMetadataOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) UIView *highlightView;
@property (strong, nonatomic) UILabel *textLabel;

@property (strong,nonatomic) id<ArtQrCodeDeViewDelegate>delegate;

@end

@protocol ArtQrCodeDeViewDelegate <NSObject>

-(void)decodeResult:(NSString *)str;

@end