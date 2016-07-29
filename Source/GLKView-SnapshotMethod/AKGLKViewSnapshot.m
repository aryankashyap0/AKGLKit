//
//  AKGLKViewSnapshot.m
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import "AKGLKViewSnapshot.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AKGLKViewSnapshot ()

@property (nonatomic) GLuint sampleFramebuffer;

@end

@implementation AKGLKViewSnapshot

// Release Data aswell
void dataProviderReleaseDataCallback(void *info, const void *data, size_t size)
{
    free((void *)data);
}

// This is the method which takes the snapshot for a model/
- (UIImage *)snapshotWithRenderingBlock:(void (^)(void))renderingBlock
{
    // you should cache the Texture so it doesnt render everything everytime.
    
    glBindFramebuffer(GL_FRAMEBUFFER, _sampleFramebuffer);
    
    renderingBlock();
    
    
    GLuint dataFramebuffer;
    glGenFramebuffers(1, &dataFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, dataFramebuffer);
    
    
    CVOpenGLESTextureCacheRef rawDataTextureCache;
    CVReturn error = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [EAGLContext currentContext], NULL, &rawDataTextureCache);
    
    if (error) {
        NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate %d", error);
    }
    
  
    // This code helps you cache the texture
    
    CFDictionaryRef empty; // empty value for attr value.
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault, // our empty IOSurface properties dictionary
                               NULL,
                               NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                      1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    // Sets the value corresponding to a given key.
    CFDictionarySetValue(attrs,
                         kCVPixelBufferIOSurfacePropertiesKey,
                         empty);
    
    // A reference to a Core Video pixel buffer object.
    CVPixelBufferRef renderTarget;
    
    // Creates a single pixel buffer for a given size and pixel format.
    CVPixelBufferCreate(kCFAllocatorDefault,
                        _drawableWidth,
                        _drawableHeight,
                        kCVPixelFormatType_32BGRA,
                        attrs,
                        &renderTarget);
    
    CVOpenGLESTextureRef renderTexture;
    
    // Creates a CVOpenGLESTextureRef object from an existing CVImageBufferRef.
    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                  rawDataTextureCache, renderTarget,
                                                  NULL, // texture attributes
                                                  GL_TEXTURE_2D,
                                                  GL_RGBA, // opengl format
                                                  _drawableWidth,
                                                  _drawableHeight,
                                                  GL_BGRA, // native iOS format
                                                  GL_UNSIGNED_BYTE,
                                                  0,
                                                  &renderTexture);
    CFRelease(attrs);
    CFRelease(empty);
    glActiveTexture(GL_TEXTURE2);
    
    glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture), 0);
    
    
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, dataFramebuffer);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();
    
    glFinish();
    
    
    
    // Locks the base address of the pixel buffer.
    CVPixelBufferLockBaseAddress(renderTarget, 0);
    GLubyte *_rawBytesForImage = (GLubyte *)CVPixelBufferGetBaseAddress(renderTarget);
    
    NSUInteger paddedWidthOfImage = CVPixelBufferGetBytesPerRow(renderTarget) / 4;
    NSUInteger paddedBytesForImage = paddedWidthOfImage * _drawableHeight * 4;
    
    void *copiedData = malloc(paddedBytesForImage);
    // A Pointer to the destination array where the content is to be copied, type-casted to a pointer of type void*.
    // This is an C++ method
    memcpy(copiedData, _rawBytesForImage, paddedBytesForImage);
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, copiedData, paddedBytesForImage, dataProviderReleaseDataCallback);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef cgImageFromBytes = CGImageCreate(_drawableWidth, _drawableHeight, 8, 32, CVPixelBufferGetBytesPerRow(renderTarget), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    
    // Unlocks the base address of the pixel buffer.
    CVPixelBufferUnlockBaseAddress(renderTarget, 0);
    
    UIImage *image = [UIImage imageWithCGImage:cgImageFromBytes];
    
    // CGImage Release is similar to CFRelease but i prefer the one below..
    //  CGImageRelease checks for null but doenst crash.. if null is passed in CGRelease the application crashes.
    CGImageRelease(cgImageFromBytes);
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colorSpace);
    
    
    if (renderTexture) {
        CFRelease(renderTexture);
        renderTexture = NULL;
    }
    
    if (dataFramebuffer) {
        // delete frame buffer objects. and set the value to nil
        glDeleteFramebuffers(1, &dataFramebuffer);
        dataFramebuffer = 0;
    }
    
    if (rawDataTextureCache) {
        // Performs internal housekeeping/recycling operations on a texture cache.
        CVOpenGLESTextureCacheFlush(rawDataTextureCache, 0);
        // Release the raw data texture cacehe and set the value to nil
        CFRelease(rawDataTextureCache);
        rawDataTextureCache = 0;
    }
    
    if (renderTarget) {
        // Release a the pixel buffer and set the render target to nil
        CVPixelBufferRelease(renderTarget);
        renderTarget = 0;
    }
    
    return image;
    
}


@end
