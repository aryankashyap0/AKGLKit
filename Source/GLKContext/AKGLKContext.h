//
//  AKGLKContext.h
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import <GLKit/GLKit.h>

/**** This is class tells you how EAGLContext works.. ****/

@interface AKGLKContext : EAGLContext
{
    GLKVector4 clearColor;
}

@property(nonatomic, assign, readwrite) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dFactor;
@end
