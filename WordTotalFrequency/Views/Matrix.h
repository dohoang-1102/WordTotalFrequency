//
//  Matrix.h
//  TestPie
//
//  Created by hx on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef TestPie_Matrix_h
#define TestPie_Matrix_h
#include "Vector.h"

struct Matrix4{
    /**
	 * X O O O
	 * O O O O
	 * O O O O
     */
	float n11;
    
	/**
	 * O X O O
	 * O O O O
	 * O O O O
     */
	float n12 ;
    
	/**
	 * O O X O
	 * O O O O
	 * O O O O
     */
	float n13 ;
    
	/**
	 * O O O X
	 * O O O O
	 * O O O O
     */
	float n14 ;
    
    
	/**
	 * O O O O
	 * X O O O
	 * O O O O
     */
	float n21 ;
    
	/**
	 * O O O O
	 * O X O O
	 * O O O O
     */
	float n22 ;
    
	/**
	 * O O O O
	 * O O X O
	 * O O O O
     */
	float n23 ;
    
	/**
	 * O O O O
	 * O O O X
	 * O O O O
     */
	float n24 ;
    
    
	/**
	 * O O O O
	 * O O O O
	 * X O O O
     */
	float n31 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O X O O
     */
	float n32 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O X O
     */
	float n33 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O O X
     */
	float n34 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O O O
	 * X O O O
     */
	float n41 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O O O
	 * O X O O
     */
	float n42 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O O O
	 * O O X O
     */
	float n43 ;
    
	/**
	 * O O O O
	 * O O O O
	 * O O O O
	 * O O O X
     */
	float n44 ;
};

void mtxReset(struct Matrix4 *mtx);

void mtxClone(struct Matrix4 *a, struct Matrix4 *b);

void mtxMultiply(struct Matrix4 *a, struct Matrix4 *b,struct Matrix4 *result);

void mtxAdd(struct Matrix4 *a, struct Matrix4 *b,struct Matrix4 *result);

void mtxTranslate(struct Matrix4 *mtx, struct Vector4 *vec);

void mtxTranslateMinus(struct Matrix4 *mtx, struct Vector4 *vec);

void mtxScale(struct Matrix4 *mtx, struct Vector4 *vec);

void mtxRotate(struct Matrix4 *mtx, struct Vector4 *vec,float rad, struct Matrix4 *result);


void mtxMultiplyVec(struct Matrix4 *mtx, struct Vector4 *vec,struct Vector4 *result);

#endif








