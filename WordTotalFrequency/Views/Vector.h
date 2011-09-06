//
//  Vector.h
//  TestPie
//
//  Created by hx on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef TestPie_Vector_h
#define TestPie_Vector_h


struct Vector4{
    float x;
    float y;
    float z;
    float w;
};


struct Vector3{
    float x;
    float y;
    float z;
};

struct Vector2{
    float x;
    float y;
};



void vec4Normalize(struct Vector4 *v);
float vec4GetNorm(struct Vector4 *v);
#endif
