//
//  AKGLKVertexAttribArrayBuffer.m
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import "AKGLKVertexAttribArrayBuffer.h"

@interface AKGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizeiptr stride;

@end

@implementation AKGLKVertexAttribArrayBuffer

@synthesize glName;
@synthesize bufferSizeBytes;
@synthesize stride;

// This method creates a vertex attribute array buffer in
// the current OpenGl ES Context for thread upon which this
// method is called.

-(id)initWithAttribStride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    if(nil != (self = [super init])){
      
        stride = aStride;
        bufferSizeBytes = stride *count;
        
        glGenBuffers(1, &glName);
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage);
        
        NSAssert(0 != glName, @"Failed to generare gl name");
        
    }
    
    return self;
}

// A Vertex attribute buffer array buffer must be prepared when your
// application wants to use buffer to render any geometry
// When your application prepares an buffer, some OpenGL ES state
// is altered to allow bind the buffer and configure pointers

-(void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable{

    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != glName, @"Invalid glName");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    
    if(shouldEnable){
      
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(index,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          self.stride,
                          NULL + offset);
    
}

// Submits Drawing Command identified by mode and instructs
// Open GL ES to use count vertices from buffer starting from
// the vertex at index first. Vertex indices start at 0

-(void)drawArrayWithMode:(GLenum)mode
        startVertexIndex:(GLint)first
        numberOfVertices:(GLsizei)count
{
    
    NSAssert(self.bufferSizeBytes >= ((first + count) *stride), @"Attempt to draw more vertex dat than available");
    
    glDrawArrays(mode, first, count);
}

-(void)dealloc{
   
    // Delete Buffer frame from the current context
    if(0 != glName){
     
        glDeleteBuffers(1, &glName);
        glName = 0;
    }
}


@end
