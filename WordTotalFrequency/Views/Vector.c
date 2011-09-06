//
//  Vector.c
//  TestPie
//
//  Created by hx on 8/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "Vector.h"
#include <math.h>
void vec4Normalize(struct Vector4 *v){
    
    float norm  = sqrt( v->w * v->w + v->x * v->x + v->y * v->y + v->z * v->z );
    v->x        = v->x/norm;
    v->y        = v->y/norm;
    v->z        = v->z/norm;
    v->w        = v->w/norm;
}

float vec4GetNorm(struct Vector4 *v){
    return sqrt( v->w * v->w + v->x * v->x + v->y * v->y + v->z * v->z );
}