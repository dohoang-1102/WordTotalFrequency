//
//  Matrix.c
//  TestPie
//
//  Created by hx on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "Matrix.h"
#include "Math.h"




void mtxReset(struct Matrix4 *mtx){
    mtx->n11 = 1.0;
    mtx->n22 = 1.0;
    mtx->n33 = 1.0;
    mtx->n44 = 1.0;
    
    mtx->n12 = 0.0;
    mtx->n13 = 0.0;
    mtx->n14 = 0.0;
    
    mtx->n21 = 0.0;
    mtx->n23 = 0.0;
    mtx->n24 = 0.0;
    
    mtx->n31 = 0.0;
    mtx->n32 = 0.0;
    mtx->n34 = 0.0;
    
    mtx->n41 = 0.0;
    mtx->n42 = 0.0;
    mtx->n43 = 0.0;
}

void mtxClone(struct Matrix4 *a, struct Matrix4 *b){
    b->n11 = a->n11;
    b->n22 = a->n22;
    b->n33 = a->n33;
    b->n44 = a->n44;
    
    b->n12 = a->n12;
    b->n13 = a->n13;
    b->n14 = a->n14;
    
    b->n21 = a->n21;
    b->n23 = a->n23;
    b->n24 = a->n24;
    
    b->n31 = a->n31;
    b->n32 = a->n32;
    b->n34 = a->n33;
    
    b->n41 = a->n41;
    b->n42 = a->n42;
    b->n43 = a->n43;
}

struct Matrix4 cacheMultiplyMtxa;
struct Matrix4 cacheMultiplyMtxb;

void mtxMultiply(struct Matrix4 *a, struct Matrix4 *b,struct Matrix4 *result){
    mtxClone(a,&cacheMultiplyMtxa);
    mtxClone(b,&cacheMultiplyMtxb);
    mtxReset(result);
    result->n11 = cacheMultiplyMtxa.n11 * cacheMultiplyMtxb.n11 + cacheMultiplyMtxa.n12 * cacheMultiplyMtxb.n21 + cacheMultiplyMtxa.n13 * cacheMultiplyMtxb.n31;
    result->n12 = cacheMultiplyMtxa.n11 * cacheMultiplyMtxb.n12 + cacheMultiplyMtxa.n12 * cacheMultiplyMtxb.n22 + cacheMultiplyMtxa.n13 * cacheMultiplyMtxb.n32;
    result->n13 = cacheMultiplyMtxa.n11 * cacheMultiplyMtxb.n13 + cacheMultiplyMtxa.n12 * cacheMultiplyMtxb.n23 + cacheMultiplyMtxa.n13 * cacheMultiplyMtxb.n33;
    result->n14 = cacheMultiplyMtxa.n11 * cacheMultiplyMtxb.n14 + cacheMultiplyMtxa.n12 * cacheMultiplyMtxb.n24 + cacheMultiplyMtxa.n13 * cacheMultiplyMtxb.n34 + cacheMultiplyMtxa.n14;
    
    result->n21 = cacheMultiplyMtxa.n21 * cacheMultiplyMtxb.n11 + cacheMultiplyMtxa.n22 * cacheMultiplyMtxb.n21 + cacheMultiplyMtxa.n23 * cacheMultiplyMtxb.n31;
    result->n22 = cacheMultiplyMtxa.n21 * cacheMultiplyMtxb.n12 + cacheMultiplyMtxa.n22 * cacheMultiplyMtxb.n22 + cacheMultiplyMtxa.n23 * cacheMultiplyMtxb.n32;
    result->n23 = cacheMultiplyMtxa.n21 * cacheMultiplyMtxb.n13 + cacheMultiplyMtxa.n22 * cacheMultiplyMtxb.n23 + cacheMultiplyMtxa.n23 * cacheMultiplyMtxb.n33;
    result->n24 = cacheMultiplyMtxa.n21 * cacheMultiplyMtxb.n14 + cacheMultiplyMtxa.n22 * cacheMultiplyMtxb.n24 + cacheMultiplyMtxa.n23 * cacheMultiplyMtxb.n34 + cacheMultiplyMtxa.n24;
    
    result->n31 = cacheMultiplyMtxa.n31 * cacheMultiplyMtxb.n11 + cacheMultiplyMtxa.n32 * cacheMultiplyMtxb.n21 + cacheMultiplyMtxa.n33 * cacheMultiplyMtxb.n31;
    result->n32 = cacheMultiplyMtxa.n31 * cacheMultiplyMtxb.n12 + cacheMultiplyMtxa.n32 * cacheMultiplyMtxb.n22 + cacheMultiplyMtxa.n33 * cacheMultiplyMtxb.n32;
    result->n33 = cacheMultiplyMtxa.n31 * cacheMultiplyMtxb.n13 + cacheMultiplyMtxa.n32 * cacheMultiplyMtxb.n23 + cacheMultiplyMtxa.n33 * cacheMultiplyMtxb.n33;
    result->n34 = cacheMultiplyMtxa.n31 * cacheMultiplyMtxb.n14 + cacheMultiplyMtxa.n32 * cacheMultiplyMtxb.n24 + cacheMultiplyMtxa.n33 * cacheMultiplyMtxb.n34 + cacheMultiplyMtxa.n34;
    
    /*result->n41 = cacheMultiplyMtxa.n41 * cacheMultiplyMtxb.n11 + cacheMultiplyMtxa.n42 * cacheMultiplyMtxb.n21 + cacheMultiplyMtxa.n43 * cacheMultiplyMtxb.n31;
    result->n42 = cacheMultiplyMtxa.n41 * cacheMultiplyMtxb.n12 + cacheMultiplyMtxa.n42 * cacheMultiplyMtxb.n22 + cacheMultiplyMtxa.n43 * cacheMultiplyMtxb.n32;
    result->n43 = cacheMultiplyMtxa.n41 * cacheMultiplyMtxb.n13 + cacheMultiplyMtxa.n42 * cacheMultiplyMtxb.n23 + cacheMultiplyMtxa.n43 * cacheMultiplyMtxb.n33;
    result->n44 = cacheMultiplyMtxa.n41 * cacheMultiplyMtxb.n14 + cacheMultiplyMtxa.n42 * cacheMultiplyMtxb.n24 + cacheMultiplyMtxa.n43 * cacheMultiplyMtxb.n34 + cacheMultiplyMtxa.n44;*/
}




struct Matrix4 cacheAddMtxa;
struct Matrix4 cacheAddMtxb;

void mtxAdd(struct Matrix4 *a, struct Matrix4 *b,struct Matrix4 *result){
    mtxClone(a,&cacheAddMtxa);
    mtxClone(b,&cacheAddMtxb);
    mtxReset(result);
    
    result->n11 = cacheAddMtxa.n11 + cacheAddMtxb.n11;
    result->n12 = cacheAddMtxa.n12 + cacheAddMtxb.n12;
    result->n13 = cacheAddMtxa.n13 + cacheAddMtxb.n13;
    result->n14 = cacheAddMtxa.n14 + cacheAddMtxb.n14;
    
    result->n21 = cacheAddMtxa.n21 + cacheAddMtxb.n21;
    result->n22 = cacheAddMtxa.n22 + cacheAddMtxb.n22;
    result->n23 = cacheAddMtxa.n23 + cacheAddMtxb.n23;
    result->n24 = cacheAddMtxa.n24 + cacheAddMtxb.n24;
    
    result->n31 = cacheAddMtxa.n31 + cacheAddMtxb.n31;
    result->n32 = cacheAddMtxa.n32 + cacheAddMtxb.n32;
    result->n33 = cacheAddMtxa.n33 + cacheAddMtxb.n33;
    result->n34 = cacheAddMtxa.n34 + cacheAddMtxb.n34;
}





void mtxTranslate(struct Matrix4 *mtx, struct Vector4 *vec){
    mtx->n14    += vec->x;
    mtx->n24    += vec->y;
    mtx->n34    += vec->z;
}
void mtxTranslateMinus(struct Matrix4 *mtx, struct Vector4 *vec){
    mtx->n14    -= vec->x;
    mtx->n24    -= vec->y;
    mtx->n34    -= vec->z;
}





void mtxScale(struct Matrix4 *mtx, struct Vector4 *vec){
    mtx->n11    *= vec->x;
    mtx->n22    *= vec->y;
    mtx->n33    *= vec->z;
}



struct Matrix4 cacheRotateMtx;

void mtxRotate(struct Matrix4 *mtx, struct Vector4 *vec,float rad, struct Matrix4 *result){
    mtxReset(&cacheRotateMtx);
    
    float nCos	= cos( rad );
    float nSin	= sin( rad );
    float scos	= 1 - nCos;
    
    float sxy       = vec->x * vec->y * scos;
    float syz       = vec->y * vec->z * scos;
    float sxz       = vec->x * vec->z * scos;
    float sz        = nSin * vec->z;
    float sy        = nSin * vec->y;
    float sx        = nSin * vec->x;
    
    cacheRotateMtx.n11     =  nCos + vec->x * vec->x * scos;
    cacheRotateMtx.n12     = -sz   + sxy;
    cacheRotateMtx.n13     =  sy   + sxz;
    cacheRotateMtx.n14     = 0;
    
    cacheRotateMtx.n21     =  sz   + sxy;
    cacheRotateMtx.n22     =  nCos + vec->y * vec->y * scos;
    cacheRotateMtx.n23     = -sx   + syz;
    cacheRotateMtx.n24     = 0;
    
    cacheRotateMtx.n31     = -sy   + sxz;
    cacheRotateMtx.n32     =  sx   + syz;
    cacheRotateMtx.n33     =  nCos + vec->z * vec->z * scos;
    cacheRotateMtx.n34     = 0;
    
    mtxMultiply(mtx,&cacheRotateMtx,result);
}





void mtxMultiplyVec(struct Matrix4 *mtx, struct Vector4 *vec,struct Vector4 *result){
    result->x = vec->x * mtx->n11 + vec->y * mtx->n12 + vec->z * mtx->n13 + mtx->n14;
    result->y = vec->x * mtx->n21 + vec->y * mtx->n22 + vec->z * mtx->n23 + mtx->n24;
    result->z = vec->x * mtx->n31 + vec->y * mtx->n32 + vec->z * mtx->n33 + mtx->n34;
}











