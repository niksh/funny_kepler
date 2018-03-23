#pragma once

#include <math.h>

#include "cuda_runtime.h"
#include "vector_types.h"

inline __host__ __device__ float3 operator-(float3 a, float3 b){
    return make_float3(a.x - b.x, a.y - b.y, a.z - b.z);
}

inline __host__ __device__ float3 getVector(float3 ri, float3 rj, float3 L)
{
	float3 dr = rj -ri;
    if(L.x > 0)
    	dr.x -= rint(dr.x/(2*L.x))*(2*L.x);
    if(L.y > 0)
	    dr.y -= rint(dr.y/(2*L.y))*(2*L.y);
    if(L.z > 0)
	    dr.z -= rint(dr.z/(2*L.z))*(2*L.z);
	return dr;
}

inline float __host__ __device__ len(float3 a)
{
    return sqrtf(a.x*a.x + a.y*a.y + a.z*a.z);
}

inline float __host__ __device__ getDistance(float3 ri, float3 rj, float3 L)
{
	float3 dr = getVector(ri, rj, L);
	return len(dr);
}
