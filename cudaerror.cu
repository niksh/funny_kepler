#include<stdio.h>
#include"cudaerror.h"
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
