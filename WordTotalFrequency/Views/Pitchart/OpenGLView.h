//
//  OpenGLView.h
//  OpenGLES2Test
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#include "ModelBuilder.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface OpenGLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    GLuint _pieVertexBuffer;
    GLuint _pieIndexBuffer;
    GLuint _shadowVertexBuffer;
    GLuint _shadowIndexBuffer;
    
    GLuint _depthBuffer;
    GLuint _colorBuffer;
    GLuint _frameBuffer;
    GLuint _msaaFrameBuffer;
    GLuint _msaaColorBuffer;
    GLuint _msaaDepthBuffer;
    int _msaaSample;
    
    GLuint _pieProgramHandle;
    GLuint _shadowProgramHandle;
    
    GLuint _piePositionSlot;
    
    GLuint _pieColorSlot;
    GLuint _pieNormalSlot;
    GLuint _pieTexCoordSlot;
    
    GLuint _pieProjectMtxUniform;
    GLuint _pieNormalMtxUniform;
    GLuint _pieModelViewMtxUniform;
    GLuint _pieLightDirectionnUniform;
    GLuint _pieTextureUniform;
    
    GLuint _shadowPositionSlot;
    GLuint _shadowColorSlot;
    GLuint _shadowNormalSlot;
    GLuint _shadowTexCoordSlot;
    
    GLuint _shadowProjectionUniform;
    GLuint _shadowLightDirectionnUniform;
    GLuint _shadowTextureUniform;
    
    GLuint _floorTexture;

    float _rotatePieX;
    float _rotatePieY;
    
    float _currentRotatePieX;
    float _currentRotatePieY;
    
    
}
- (void)setupLayer;
- (void)setupContext;
- (void)setupRenderBuffer;

- (void)setupVBOs;
- (void)setupLight;
- (GLuint)setupTexture:(NSString *)fileName;

- (void)render:(CADisplayLink*)displayLink;
- (void)compileShaders;

@end
