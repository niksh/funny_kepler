#pragma once
#include<cuda.h>

struct Parameters
{
    int max_parts;
    float possiblepairscutoff;
    int maxpossiblepairs;
    int block_size;
    int device;
};
