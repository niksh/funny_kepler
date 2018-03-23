#include<vector>
#include<map>
#include<algorithm>
#include<iostream>
#include<fstream>
#include<utility>
#include<vector>
#include<list>

#include"vec_utils.h"
#include"cudaerror.h"
#include"data.h"
#include"parameters.h"
#include"listUpdaters.cuh"


Parameters params;
std::list<ListUpdater*> listUpdaters;

int main(int argc, char** argv)
{
    d_Data d_part;
    params.device = 0;
    params.block_size = 128;
    cudaSetDevice(params.device);
    cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 900000000);

    d_part.atom_count = 100;
    d_part.atom_count = d_part.atom_count;
    int *t = (int*)calloc(d_part.atom_count, sizeof(int));
    float3 *c = (float3*)calloc(d_part.atom_count, sizeof(float3));
    for(int i = 0; i < d_part.atom_count; i++)
    {
        t[i] = TYPEA;
        c[i].x = i;
    }
    cudaMalloc((void**)&(d_part.t), d_part.atom_count * sizeof(int));
    cudaMalloc((void**)&(d_part.c), d_part.atom_count * sizeof(float3));
    cudaMemcpy(d_part.t, t, d_part.atom_count * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_part.c, c, d_part.atom_count * sizeof(float3), cudaMemcpyHostToDevice);
    d_part.atom_count = d_part.atom_count;

    params.maxpossiblepairs = 1000;
    cudaMalloc((void**)&(d_part.possiblePairsCount), d_part.atom_count * sizeof(int));
    cudaMemset(d_part.possiblePairsCount, 0, d_part.atom_count * sizeof(int));
    cudaMalloc((void**)&(d_part.possiblePairs), d_part.atom_count * params.maxpossiblepairs * sizeof(int));
    cudaMemset(d_part.possiblePairs, 0, d_part.atom_count * params.maxpossiblepairs * sizeof(int));
    checkCUDAError(__LINE__,__FILE__);
    cudaDeviceSynchronize();
    params.possiblepairscutoff = 2;
    listUpdaters.push_back(new ListUpdater(d_part, params));
    listUpdaters.front()->update();
}
