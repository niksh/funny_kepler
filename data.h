#ifndef DATA_H
#define DATA_H

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/device_ptr.h>

enum Types {TYPENONE = -1, TYPEA, TYPEB, TYPEC, TYPED, TYPEE, TYPEF, TYPEG, TYPEH, TYPEI};

template <typename T>
class hd_vector {
public:
    void resize(size_t len_) {
        h.resize(len_);
        d.resize(len_);
    }
    void h2d() { d = h; }
    void d2h() { h = d; }
    T* d_ptr() { return thrust::raw_pointer_cast(d.data()); }
    T* h_ptr() { return thrust::raw_pointer_cast(h.data()); }
    thrust::host_vector<T> h;
    thrust::device_vector<T> d;
};

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

struct Data
{
    hd_vector<float3> c;
    hd_vector<int> t;
    d_Data d_data;
    int atom_count;
};
#endif
