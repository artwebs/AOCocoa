//
//  ArtQrCodeDeView.m
//  BusinessCard
//
//  Created by artwebs on 14-7-4.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtQrCodeDeView.h"

@implementation ArtQrCodeDeView
@synthesize highlightView,textLabel,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        contentView.hidden=YES;
        playerView.hidden=NO;
        self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([self.captureDevice isLowLightBoostSupported] && [self.captureDevice lockForConfiguration:nil]) {
            self.captureDevice.automaticallyEnablesLowLightBoostWhenAvailable = YES;
            [self.captureDevice unlockForConfiguration];
        }
        
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession beginConfiguration];
        
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
        [self.captureSession addInput:self.captureDeviceInput];
        
        self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:self.captureMetadataOutput];
        self.captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        [self.captureSession commitConfiguration];
        [self.captureSession startRunning];
        
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.captureVideoPreviewLayer.frame = self.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.captureVideoPreviewLayer];
        
        if (self.captureDevice.hasTorch && self.captureDevice.torchAvailable && [self.captureDevice isTorchModeSupported:AVCaptureTorchModeOn] && [self.captureDevice lockForConfiguration:nil]) {
            [self.captureDevice setTorchModeOnWithLevel:0.25 error:nil];
            [self.captureDevice unlockForConfiguration];
        }
        
        self.highlightView = [[UIView alloc] init];
        self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.highlightView.layer.borderColor = [UIColor greenColor].CGColor;
        self.highlightView.layer.borderWidth = 3;
        [self addSubview:self.highlightView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.frame = CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40);
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.textLabel.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.text = @"";
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    __block CGRect highlightViewRect = CGRectZero;
    __block NSString *result;
    
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *metadataObject, NSUInteger idx, BOOL *stop) {
        AVMetadataMachineReadableCodeObject *readableCodeObject = (AVMetadataMachineReadableCodeObject *)[self.captureVideoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadataObject];
        highlightViewRect = readableCodeObject.bounds;
        result = [readableCodeObject stringValue];
    }];
    
    self.highlightView.frame = highlightViewRect;
    if (result != nil) {
        self.textLabel.text = result;
        if (delegate) {
            [delegate decodeResult:result];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
