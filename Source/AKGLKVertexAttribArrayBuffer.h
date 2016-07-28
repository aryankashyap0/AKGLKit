//
//  AKGLKVertexAttribArrayBuffer.h
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class AKGLKVertexAttribArrayBuffer;

@interface AKGLKVertexAttribArrayBuffer : NSObject
{
    GLsizeiptr stride;
    GLsizeiptr bufferSizeBytes;
    GLuint     glName;
    
}

@property (nonatomic, readonly) GLuint glName;
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly) GLsizeiptr stride;

- (id)initWithAttribStride:(GLsizeiptr)aStride
          numberOfVertices:(GLsizei)count
                      data:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

@end
