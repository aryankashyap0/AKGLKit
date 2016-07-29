//
//  AKGLKViewSnapshot.h
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <GLKit/GLKit.h>

@interface AKGLKViewSnapshot : NSObject

@property (nonatomic, readonly) GLint drawableWidth;
@property (nonatomic, readonly) GLint drawableHeight;

- (UIImage *)snapshotWithRenderingBlock:(void (^)(void))renderingBlock;

@end
