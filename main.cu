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
    Data data;
    d_Data d_part;
    params.device = 0;
    params.block_size = 128;
    cudaSetDevice(params.device);
    cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 900000000);

    params.max_parts = 100;
    data.atom_count = params.max_parts;
    data.c.resize(data.atom_count);
    data.t.resize(data.atom_count);
    for(int i = 0; i < data.atom_count; i++)
    {
        data.t.h[i] = TYPEA;
        data.c.h[i].x = i;
    }
    data.c.h2d();
    data.t.h2d();
    d_part.c = data.c.d_ptr();
    d_part.t = data.t.d_ptr();
    d_part.atom_count = data.atom_count;

    params.maxpossiblepairs = 1000;
    cudaMalloc((void**)&(d_part.possiblePairsCount), data.atom_count * sizeof(int));
    cudaMemset(d_part.possiblePairsCount, 0, data.atom_count * sizeof(int));
    cudaMalloc((void**)&(d_part.possiblePairs), data.atom_count * params.maxpossiblepairs * sizeof(int));
    cudaMemset(d_part.possiblePairs, 0, data.atom_count * params.maxpossiblepairs * sizeof(int));
    checkCUDAError(__LINE__,__FILE__);
    cudaDeviceSynchronize();
    data.d_data = d_part;
    params.possiblepairscutoff = 2;
    listUpdaters.push_back(new ListUpdater(&data, &params));
    listUpdaters.front()->update();
}
