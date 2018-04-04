#include<stdio.h>

#include"data.h"


__global__ void possibleListUpdater_kernel(d_Data data, IndexStruct selected)
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    if( (i < data.atom_count) )
    {
        if(i < selected.index_count)
            i = selected.index[i];
        for(int j = 0; j < data.atom_count; j++)
        {
            if ( (j != i) && (data.t[j] != TYPENONE) )
            {
                int3 rj = data.c[j];
                data.possiblePairsCount[i] = rj.x;
            }
        }
    }
}

void checkCUDAError(int line, const char *file)
{
	cudaError_t error = cudaGetLastError();
	if(error != cudaSuccess)
    {
        if(line >= 0)
    		printf("CUDA error: %s  at line %d file %s\n", cudaGetErrorString(error), line, file);
        else
    		printf("CUDA error: %s\n", cudaGetErrorString(error));
        exit(0);
	}
}

IndexStruct selected;

int main(int argc, char** argv)
{
    d_Data d_part;
    d_part.block_size = 128;
    cudaSetDevice(3);
    cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 900000000);

    d_part.atom_count = 100;
    d_part.atom_count = d_part.atom_count;
    int *t = (int*)calloc(d_part.atom_count, sizeof(int));
    int3 *c = (int3*)calloc(d_part.atom_count, sizeof(int3));
    for(int i = 0; i < d_part.atom_count; i++)
    {
        t[i] = TYPEA;
        c[i].x = (float)i;
    }
    cudaMalloc((void**)&(d_part.t), d_part.atom_count * sizeof(int));
    cudaMalloc((void**)&(d_part.c), d_part.atom_count * sizeof(int3));
    cudaMemcpy(d_part.t, t, d_part.atom_count * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_part.c, c, d_part.atom_count * sizeof(int3), cudaMemcpyHostToDevice);
    d_part.atom_count = d_part.atom_count;

    cudaMalloc((void**)&(d_part.possiblePairsCount), d_part.atom_count * sizeof(int));
    cudaMemset(d_part.possiblePairsCount, 0, d_part.atom_count * sizeof(int));
    checkCUDAError(__LINE__,__FILE__);
    cudaDeviceSynchronize();
    selected.index_count = -1;
    selected.index = NULL;
    int grid_size;
    grid_size = d_part.atom_count/d_part.block_size+1;
    possibleListUpdater_kernel<<<grid_size, d_part.block_size>>>(d_part, selected);
    cudaDeviceSynchronize();
    checkCUDAError(__LINE__,__FILE__);
}
