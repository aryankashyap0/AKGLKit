//
//  AKGLKContext.m
//  AKGLKKit
//
//  Copyright (c) 2016 Aryan Kashyap. All rights reserved.
//

#import "AKGLKContext.h"

@implementation AKGLKContext

/**** This is class tells you how EAGLContext works.. ****/

/////////////////////////////////////////////////////
// This method sets clear (background) RGBA color.
// The clear color is undefined until this method is called.

-(void)setClearColor:(GLKVector4)clearColorRGBA{
   
    clearColor = clearColorRGBA;
    
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    
    glClearColor(clearColorRGBA.r,
                 clearColorRGBA.g,
                 clearColorRGBA.b,
                 clearColorRGBA.a);
}

//////////////////////////////////////////////////////////////
// Return the clear (background) color set via - setClearColor
// If no clear color has been set via - setClearColor:, the
// return clear color is undefined

- (GLKVector4)clearColor{
    return clearColor;
}

///////////////////////////////////////////////////////
// This method instructs Open GL ES to set all data in the
// current Context's Render Buffer(s) identified by mask to
// colors (values) specified via -setClearColor: and/or
// Open GL ES functions for Render Buffer Type

-(void)clear:(GLbitfield)mask{

    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");

    glClear(mask);
}

/////////////////////////////////////////////////////////////////

-(void)enable:(GLenum)capability{
  
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
  
    glEnable(capability);
}

/////////////////////////////////////////////////////////////////

- (void)disable:(GLenum)capability;
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    
    glDisable(capability);
}

/////////////////////////////////////////////////////////////////

- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dfactor;
{
    glBlendFunc(sfactor, dfactor);
}


@end
