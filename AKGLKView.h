//
//  AKGLKView.h
//  OpenGLESDeepDive
//
//  Created by Aryan Kashyap on 25/07/2016.
//  Copyright © 2016 Aryan Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class EAGLContext;
@protocol AKGLKViewDelegate;

/////////////////////////////////////////////////////////////////
// Type for depth buffer formats.
typedef enum {
AKGLKViewDrawableDepthFormatNone = 0,
ALGLKViewDrawableDepthFormat16,
} AKGLKViewDrawableDepthFormat;


///////////////////////////////////////////////////////////////////////////
// This is a subclass of the Cocoa Touch UIView class uses upon Open GL ES
// To render pixel data into a frame buffer that shares pixel
// color storage with Core Animation Layer

@interface AKGLKView : UIView
{
    EAGLContext  *context;
    GLuint  defaultFrameBuffer;
    GLuint  colorRenderBuffer;
    GLuint   depthRenderBuffer;
    GLint    drawableWidth;
    GLint   drawableHeight;
}

@property (nonatomic, weak) IBOutlet id <AKGLKViewDelegate> delegate;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;
@property (nonatomic) AKGLKViewDrawableDepthFormat
drawableDepthFormat;

- (void)display;

@end

#pragma mark - AKGLKViewDelegate

@protocol AKGLKViewDelegate <NSObject>
@required
- (void)akglkview:(AKGLKView *)view drawInRect:(CGRect)rect;

@end


