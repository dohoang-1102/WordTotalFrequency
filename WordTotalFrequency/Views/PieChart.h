//
//  PieChart.h
//  TestPie
//
//  Created by hx on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vector.h"
#import "Matrix.h"

@interface PieChart : UIView  
{
    bool isPieInited;
    
    //parts
#define PART_NUM 5
    float partData[PART_NUM];

    
    //pie model
#define RADIUS 130
#define HEIGHT 20
#define DIVIDE_NUM 120
    
    struct Vector4 topDivideVec[DIVIDE_NUM+1];
    struct Vector4 btmDivideVec[DIVIDE_NUM+1];
    struct Vector4 topTransformVec[DIVIDE_NUM+1];
    struct Vector4 btmTransformVec[DIVIDE_NUM+1];
    //struct Vector2 topNoRotateProjPoint[DIVIDE_NUM+1];
    struct Vector4 partTopEndVec[PART_NUM];
    struct Vector4 partBtmEndVec[PART_NUM];
    struct Vector4 partTopEndTransformVec[PART_NUM];
    struct Vector4 partBtmEndTransformVec[PART_NUM];
    
    struct Vector4 centerVec;
    struct Vector4 centerTransformVec;
    
    UIImage     *pieTopImg[PART_NUM];
    UIImage     *pieBtmImg[PART_NUM];
        
    int partStartDivide[PART_NUM];
    int partEndDivide[PART_NUM];
    
    float pieRotateX;
    float pieRotateY;
    
#define MIN_PIE_ROTATE_X .25
#define MAX_PIE_ROTATE_X 1.2

    //cam
    struct Matrix4 camMtx;
    
    struct Vector4 camPosition;

    float camFocalDistance;
    
    struct Vector2 topProjPoint[DIVIDE_NUM+1];
    struct Vector2 btmProjPoint[DIVIDE_NUM+1];
    struct Vector2 partTopEndProjVec[PART_NUM];
    struct Vector2 partBtmEndProjVec[PART_NUM];
    struct Vector2 centerProjVec;
    //struct Vector2 topNoRotateProjPoint[DIVIDE_NUM+1];
    
    struct Vector4 VECTOR_AXI_X;
    struct Vector4 VECTOR_AXI_Y;
    struct Vector4 VECTOR_AXI_Z;
    
    
    //UIImageView *imgview;
}

-(void) initPie;
-(void) initPieModel;
-(void) initPieTexture;

-(void) setPartData:(float*)value;

-(void) rotatePieX:(float) rad;
-(void) rotatePieY:(float) rad;

@end
