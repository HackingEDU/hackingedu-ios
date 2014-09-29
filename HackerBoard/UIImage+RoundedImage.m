//
//  UIImage+RoundedImage.m
//  GreenPaw
//
//  Created by Nikolay Dyankov on 7/10/13.
//  Copyright (c) 2013 Nikolay Dyankov. All rights reserved.
//

#import "UIImage+RoundedImage.h"

@implementation UIImage (RoundedImage)

+ (BOOL)hasAlpha: (UIImage *)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)roundedImageWithImage:(UIImage *)image {
    if (image) {
        if (![self hasAlpha:image]) {
            
            CGImageRef imageRef = image.CGImage;
            size_t width = CGImageGetWidth(imageRef);
            size_t height = CGImageGetHeight(imageRef);
            
            // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
            CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                                  width,
                                                                  height,
                                                                  8,
                                                                  0,
                                                                  CGImageGetColorSpace(imageRef),
                                                                  kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
            
            // Draw the image into the context and retrieve the new image, which will now have an alpha layer
            CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
            CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
            image = [UIImage imageWithCGImage:imageRefWithAlpha];
            
            // Clean up
            CGContextRelease(offscreenContext);
            CGImageRelease(imageRefWithAlpha);
        }
        
        CGContextRef cx = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        
        CGContextBeginPath(cx);
        CGRect pathRect;
        /*
        if (image.size.width > image.size.height){
            pathRect = CGRectMake(((image.size.height/2)-(image.size.width/4)), 0, image.size.height, image.size.height);
        }
        else{
            pathRect = CGRectMake(0, 0, image.size.width, image.size.width);
        }*/
        pathRect = CGRectMake(0, 0, image.size.width, image.size.width);
        CGContextAddEllipseInRect(cx, pathRect);
        CGContextClosePath(cx);
        CGContextClip(cx);
        
        CGContextDrawImage(cx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
        
        CGImageRef clippedImage = CGBitmapContextCreateImage(cx);
        CGContextRelease(cx);
        
        UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
        CGImageRelease(clippedImage);
        
        
        return roundedImage;
    }
    
    return nil;
}

@end
