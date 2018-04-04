#ifndef DATA_H
#define DATA_H

#define TYPENONE -1
#define TYPEA 0

struct IndexStruct
{
    int index_count; //select.index_count = -1 to select all
    int *index;
};

struct d_Data
{
    int3 *c;
    int *t;
    int *possiblePairsCount;
    int atom_count;
    int block_size;
};

#endif
