#ifndef LISTUPDATER
#define LISTUPDATER
#include"data.h"
#include"parameters.h"
class ListUpdater
{
    Parameters params;
    d_Data data;
public:
    void update(IndexStruct select = {-1, NULL});
    ListUpdater(d_Data _data, Parameters _params) : data(_data), params(_params)
    {
    };

};
#endif
