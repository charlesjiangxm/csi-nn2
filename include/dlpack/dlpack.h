/*
 * Minimal DLPack-compatible definitions required by CSI-NN2 TVMGEN support.
 */

#ifndef INCLUDE_DLPACK_DLPACK_H_
#define INCLUDE_DLPACK_DLPACK_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

enum DLDeviceType {
    kDLCPU = 1,
};

enum DLDataTypeCode {
    kDLInt = 0U,
    kDLUInt = 1U,
    kDLFloat = 2U,
};

typedef struct {
    uint8_t code;
    uint8_t bits;
    uint16_t lanes;
} DLDataType;

typedef struct {
    enum DLDeviceType device_type;
    int device_id;
} DLDevice;

typedef struct DLTensor {
    void *data;
    DLDevice device;
    int ndim;
    DLDataType dtype;
    int64_t *shape;
    int64_t *strides;
    uint64_t byte_offset;
} DLTensor;

#ifdef __cplusplus
}
#endif

#endif  // INCLUDE_DLPACK_DLPACK_H_
