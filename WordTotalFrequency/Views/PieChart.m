//
//  PieChart.m
//  TestPie
//
//  Created by hx on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PieChart.h"
#import "Matrix.h"
#import "Matrix.h"

@implementation PieChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initPie];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
       NSLog(@"initWithCoder");
       [self initPie];
    }
    return self;
}


-(void)viewDidLoad{
     NSLog(@"pie view did load");
}

-(void)initPie
{
    if(isPieInited){
        return;
    }
    isPieInited    = true;
    [self initPieTexture];
    [self initPieModel];
    
    [self setNeedsDisplay];
}




/**************************************************************
 *init
 **************************************************************/

-(void) initPieTexture
{
    
    
    for(int i=0;i<PART_NUM;i++){
        pieTopImg[i] = [UIImage imageNamed:[NSString stringWithFormat:@"pieTopImg_part%d.jpg",i+1]];
        pieBtmImg[i] = [UIImage imageNamed:[NSString stringWithFormat:@"pieBtmImg_part%d.jpg",i+1]];
        pieTopImgView[i] =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        pieBtmImgView[i] =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self addSubview:pieBtmImgView[i]];
        
        
    }
    for(int i=0;i<PART_NUM;i++){
        [self addSubview:pieTopImgView[i]];
    }
    
    pieHighLightView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:pieHighLightView];
    //UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
    //[self addSubview:imgview];
}



-(void)initPieModel
{
    //equally divide parts

    float partPercent   = 1.0/PART_NUM;
    for(int i=0;i<PART_NUM;i++){
        partData[i] = partPercent;
    }
    [self setPartData:partData];
    
    //intialize the pie model
    
    for (int i=0; i<=DIVIDE_NUM; i++) {
        float ang   =  6.28318f * i/DIVIDE_NUM;
        topDivideVec[i].x    = cosf(ang)*RADIUS;
        topDivideVec[i].z    = sinf(ang)*RADIUS;
        topDivideVec[i].y    = 0;
        btmDivideVec[i].x    = topDivideVec[i].x;
        btmDivideVec[i].z    = topDivideVec[i].z;
        btmDivideVec[i].y    = HEIGHT;
    }
    
    
    //init cam
    
    camFocalDistance     = 140;
    camPosition.z        = -50;
    
    [self rotatePieX:.3];
    
    //init vector
    VECTOR_AXI_X.x      = 1;
    VECTOR_AXI_Y.y      = 1;
    VECTOR_AXI_Z.z      = 1;
}




/**************************************************************
 *data
 **************************************************************/


-(void)setPartData:(float*)value{
    float   val       = 0;
    for (int i=0; i<PART_NUM; i++) {
        partData[i]     = value[i];
        partStartDivide[i]    = ceilf(val * DIVIDE_NUM);
        val             += value[i];
        float ang       =  6.28318f * val;
        partTopEndVec[i].x    = cosf(ang)*RADIUS;
        partTopEndVec[i].z    = sinf(ang)*RADIUS;
        partTopEndVec[i].y    = 0;
        partBtmEndVec[i].x    = partTopEndVec[i].x;
        partBtmEndVec[i].z    = partTopEndVec[i].z;
        partBtmEndVec[i].y    = HEIGHT;
        partEndDivide[i]      = floorf(val * DIVIDE_NUM);
    }
}




/**************************************************************
 *render
 **************************************************************/



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self initPie];

    struct Vector2 projCenter;
    projCenter.x    = self.frame.size.width/2;
    projCenter.y    = self.frame.size.width/2;
    
    //calculate 3d transform and projection
    
    //matrix rotation
    mtxReset(&camMtx);
    mtxRotate(&camMtx, &VECTOR_AXI_X, pieRotateX, &camMtx);
    mtxRotate(&camMtx, &VECTOR_AXI_Y, pieRotateY, &camMtx);
     
    mtxTranslateMinus(&camMtx, &camPosition);
    
    //project center point
    mtxMultiplyVec(&camMtx, &centerVec, &centerTransformVec);
    float scale = camFocalDistance/(centerTransformVec.z+camFocalDistance);
    centerProjVec.x   = centerTransformVec.x * scale;
    centerProjVec.y   = centerTransformVec.y * scale;
    
   
    //project part end line
    for (int i=0; i<PART_NUM; i++) {
        mtxMultiplyVec(&camMtx, &partTopEndVec[i], &partTopEndTransformVec[i]);
        float scale = camFocalDistance/(partTopEndTransformVec[i].z+camFocalDistance);
        partTopEndProjVec[i].x   = partTopEndTransformVec[i].x * scale+projCenter.x;
        partTopEndProjVec[i].y   = partTopEndTransformVec[i].y * scale+projCenter.y;
        
        
        mtxMultiplyVec(&camMtx, &partBtmEndVec[i], &partBtmEndTransformVec[i]);
        scale = camFocalDistance/(partBtmEndTransformVec[i].z+camFocalDistance);
        partBtmEndProjVec[i].x   = partBtmEndTransformVec[i].x * scale+projCenter.x;
        partBtmEndProjVec[i].y   = partBtmEndTransformVec[i].y * scale+projCenter.y;
    }
    
    //top rect height
    float   minTopProjY = self.frame.size.height;
    float   maxTopProjY = 0;
    //project pie
    for (int i=0; i<=DIVIDE_NUM; i++) {
        mtxMultiplyVec(&camMtx, &topDivideVec[i], &topTransformVec[i]);
        float scale = camFocalDistance/(topTransformVec[i].z+camFocalDistance);
        topProjPoint[i].x   = topTransformVec[i].x * scale+projCenter.x;
        topProjPoint[i].y   = topTransformVec[i].y * scale+projCenter.y;
        if(minTopProjY>topProjPoint[i].y){
            minTopProjY = topProjPoint[i].y;
        }
        if(maxTopProjY<topProjPoint[i].y){
            maxTopProjY = topProjPoint[i].y;
        }
        
        mtxMultiplyVec(&camMtx, &btmDivideVec[i], &btmTransformVec[i]);
        scale = camFocalDistance/(btmTransformVec[i].z+camFocalDistance);
        btmProjPoint[i].x   = btmTransformVec[i].x * scale+projCenter.x;
        btmProjPoint[i].y   = btmTransformVec[i].y * scale+projCenter.y;
    }
    
    
    
    //draw
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextDrawImage(&context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), image.CGImage);

    //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    //CGContextSetLineWidth(context, 1.0);
    
    /*for (int i=0; i<PART_NUM; i++) {
        
        CGContextMoveToPoint(context, centerProjVec.x+projCenter.x, centerProjVec.y+projCenter.y);
        CGContextAddLineToPoint(context, partTopEndProjVec[i].x+projCenter.x, partTopEndProjVec[i].y+projCenter.y);
        
        CGContextMoveToPoint(context, partTopEndProjVec[i].x+projCenter.x, partTopEndProjVec[i].y+projCenter.y);
        CGContextAddLineToPoint(context, partBtmEndProjVec[i].x+projCenter.x, partBtmEndProjVec[i].y+projCenter.y);
    }
    for (int i=0; i<DIVIDE_NUM-1; i++) {
        CGContextMoveToPoint(context, btmProjPoint[i].x+projCenter.x, btmProjPoint[i].y+projCenter.y);
        CGContextAddLineToPoint(context, btmProjPoint[i+1].x+projCenter.x, btmProjPoint[i+1].y+projCenter.y);
    }
    
    for (int i=0; i<DIVIDE_NUM-1; i++) {
        CGContextMoveToPoint(context, topProjPoint[i].x+projCenter.x, topProjPoint[i].y+projCenter.y);
        CGContextAddLineToPoint(context, topProjPoint[i+1].x+projCenter.x, topProjPoint[i+1].y+projCenter.y);
    }*/
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    
    
    
    //draw highlight part
    CGContextRef highLightContext = CGBitmapContextCreate(NULL, self.frame.size.width, self.frame.size.width, 8, 4 * self.frame.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    
    
    float pieTopHeight        = maxTopProjY-minTopProjY;
    float hightLight1AlphaRange   = pieTopHeight*6;
    float hightLight2AlphaRange   = pieTopHeight*4;
    float hightLight1SizeRange    = pieTopHeight/8;
    float hightLight2SizeRange    = pieTopHeight/4;
    
    for (int i=0; i<DIVIDE_NUM; i++) {
        CGContextSetRGBStrokeColor(highLightContext, 1.0, 1.0, 1.0, (topProjPoint[i].y-minTopProjY)/hightLight1AlphaRange);
        CGContextSetLineWidth(highLightContext, (topProjPoint[i].y-minTopProjY)/hightLight1SizeRange);
        CGContextMoveToPoint(highLightContext, topProjPoint[i].x, topProjPoint[i].y);
        CGContextAddLineToPoint(highLightContext, topProjPoint[i+1].x, topProjPoint[i+1].y);
        CGContextStrokePath(highLightContext);
        CGContextSetRGBStrokeColor(highLightContext, 1.0, 1.0, 1.0, (topProjPoint[i].y-minTopProjY)/hightLight2AlphaRange);
        CGContextSetLineWidth(highLightContext, (topProjPoint[i].y-minTopProjY)/hightLight2SizeRange);
        CGContextMoveToPoint(highLightContext, topProjPoint[i].x, topProjPoint[i].y);
        CGContextAddLineToPoint(highLightContext, topProjPoint[i+1].x, topProjPoint[i+1].y);
        CGContextStrokePath(highLightContext);
    }
    
    
    CGImageRef cgHightLightImage = CGBitmapContextCreateImage(highLightContext);
    CGContextRelease(highLightContext);
    
    UIImage *uiHighLightImage   = [[UIImage alloc] initWithCGImage:cgHightLightImage scale:1.0 orientation:UIImageOrientationDown];
    pieHighLightView.image      = uiHighLightImage;
    [uiHighLightImage release];
    CGImageRelease(cgHightLightImage);
    
    
    //draw the bottom part
    for (int i=0; i<PART_NUM; i++) {
        CGContextRef context = CGBitmapContextCreate(NULL, self.frame.size.width, self.frame.size.width, 8, 4 * self.frame.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        if(i>0){
            CGContextMoveToPoint(context, partTopEndProjVec[i-1].x, partTopEndProjVec[i-1].y);
        }
        
        int divideId   = partStartDivide[i];
        if(i==0){
            CGContextMoveToPoint(context, topProjPoint[divideId].x, topProjPoint[divideId].y);
        }
        
        while (divideId<=partEndDivide[i]) {
            CGContextAddLineToPoint(context, topProjPoint[divideId].x, topProjPoint[divideId].y);
            divideId++;
        }
        
        CGContextAddLineToPoint(context, partTopEndProjVec[i].x, partTopEndProjVec[i].y);
        CGContextAddLineToPoint(context, partBtmEndProjVec[i].x, partBtmEndProjVec[i].y);
        divideId    = partEndDivide[i];
        
        while (divideId>partStartDivide[i]) {
            CGContextAddLineToPoint(context, btmProjPoint[divideId].x, btmProjPoint[divideId].y);
            divideId--;
        }
        
        if(i>0){
            CGContextAddLineToPoint(context, partBtmEndProjVec[i-1].x, partBtmEndProjVec[i-1].y);
        }else{
            CGContextAddLineToPoint(context, btmProjPoint[divideId].x, btmProjPoint[divideId].y);
        }
        
        CGContextClosePath(context);
        
        CGContextClip(context);
        CGContextDrawImage(context,pieBtmImgView[i].frame,pieBtmImg[i].CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context); 
        CGContextRelease(context); 
        
        UIImage *newImage = [UIImage imageWithCGImage:imageMasked scale:1.0 orientation:UIImageOrientationDown];
        CGImageRelease(imageMasked);
        
        pieBtmImgView[i].image=newImage; 
    }
    
    
    //draw the top part
    for (int i=0; i<PART_NUM; i++) {
       
        CGContextRef context = CGBitmapContextCreate(NULL, self.frame.size.width, self.frame.size.width, 8, 4 * self.frame.size.width, colorSpace, kCGImageAlphaPremultipliedFirst); 
        
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, projCenter.x, projCenter.y);
        
        if(i>0){
            CGContextAddLineToPoint(context, partTopEndProjVec[i-1].x, partTopEndProjVec[i-1].y);
        }
        int divideId   = partStartDivide[i];
        while (divideId<=partEndDivide[i]) {
            CGContextAddLineToPoint(context, topProjPoint[divideId].x, topProjPoint[divideId].y);
            divideId++;
        }
        
        CGContextAddLineToPoint(context, partTopEndProjVec[i].x, partTopEndProjVec[i].y);
        
        CGContextAddLineToPoint(context, projCenter.x, projCenter.y);
        
        CGContextClosePath(context);
        
        
        CGContextClip(context);
        
        CGContextDrawImage(context,pieTopImgView[i].frame,pieTopImg[i].CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context); 
        CGContextRelease(context); 
        
        UIImage *newImage = [UIImage imageWithCGImage:imageMasked scale:1.0 orientation:UIImageOrientationDown];
        CGImageRelease(imageMasked);
        
        pieTopImgView[i].image = newImage; 
    }
    
    //draw shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=4; i<=8; i+=4) {
        CGContextSetStrokeColorWithColor(context, [[UIColor alloc]initWithRed:.101 green:.415 blue:.725 alpha:.15].CGColor);
        CGContextSetLineWidth(context, i);
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, btmProjPoint[0].x, btmProjPoint[0].y);
        for (int i=1; i<=DIVIDE_NUM; i++) {
            CGContextAddLineToPoint(context, btmProjPoint[i].x, btmProjPoint[i].y);
        }
        
        CGContextStrokePath(context);

    }
    
    CGColorSpaceRelease(colorSpace);
    
       // CGContextDrawImage(context,pieShadowView.frame,pieShadow.CGImage);
    //CGContextRelease(context);  
    
}




/**************************************************************
 *drag
 **************************************************************/


float oldX, oldY;
BOOL dragging;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.frame, touchLocation)) {
        
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (dragging) {

        float deltax = -(touchLocation.x - oldX)/90.0;
        float deltay = (touchLocation.y - oldY)/360.0;
        [self rotatePieX:pieRotateX+deltay];
        [self rotatePieY:pieRotateY+deltax];
        
        [self setNeedsDisplay];
    }
    
    oldX = touchLocation.x;
    oldY = touchLocation.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    dragging = NO;
}





/**************************************************************
 *rotate
 **************************************************************/


-(void) rotatePieX:(float) rad{
    if(rad<MIN_PIE_ROTATE_X){
        rad = MIN_PIE_ROTATE_X;
    }else if(rad>MAX_PIE_ROTATE_X){
        rad = MAX_PIE_ROTATE_X;
    }
    pieRotateX  = rad;
}

-(void)rotatePieY:(float) rad{
    pieRotateY  = rad;
}

@end
