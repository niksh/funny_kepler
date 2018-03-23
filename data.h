#ifndef DATA_H
#define DATA_H

enum Types {TYPENONE = -1, TYPEA, TYPEB, TYPEC, TYPED, TYPEE, TYPEF, TYPEG, TYPEH, TYPEI};

struct IndexStruct
{
    int index_count; //select.index_count = -1 to select all
    int *index;
};

struct d_Data
{
    float3 *c;
    int *t;
    int *possiblePairsCount;
    int *possiblePairs;
    int atom_count;
};

#endif
