#include"listUpdaters.cuh"
#include"vec_utils.h"
#include"cudaerror.h"

__global__ void possibleListUpdater_kernel(d_Data data, Parameters params, IndexStruct select)
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    if( (i < data.atom_count) && (data.t[i] != TYPENONE) )
    {
        if(i < select.index_count)
            i = select.index[i];
        float3 ri = data.c[i];
        int pairsCount = 0;
        for(int j = 0; j < data.atom_count; j++)
        {
            if ( (j != i) && (data.t[j] != TYPENONE) )
            {
                float3 rj = data.c[j];
                if( (len(ri-rj) < params.possiblepairscutoff) && (pairsCount < params.maxpossiblepairs) )
                    pairsCount ++;
            }
        }
        data.possiblePairsCount[i] = pairsCount;
        printf("%d %d\n", i, pairsCount);
    }
}

void ListUpdater::update(IndexStruct select)
{
    int grid_size;
    if(select.index_count > 0)
        grid_size = select.index_count/params->block_size+1;
    else
        grid_size = data->atom_count/params->block_size+1;
    possibleListUpdater_kernel<<<grid_size, params->block_size>>>(data->d_data, *params, select);
    cudaDeviceSynchronize();
    checkCUDAError(__LINE__,__FILE__);
}
