#define CL_USE_DEPRECATED_OPENCL_1_0_APIS
#define CL_USE_DEPRECATED_OPENCL_1_1_APIS
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#define CL_USE_DEPRECATED_OPENCL_2_0_APIS
#define CL_USE_DEPRECATED_OPENCL_2_1_APIS
#define CL_USE_DEPRECATED_OPENCL_2_2_APIS
#define CL_USE_DEPRECATED_OPENCL_3_0_APIS
#include "CL/cl.h"

void call_all(void)
{
#ifdef CL_VERSION_1_0
    clGetPlatformIDs(0, NULL, NULL);
    clGetExtensionFunctionAddress(NULL);
    clUnloadCompiler();
    clGetPlatformInfo(NULL, CL_PLATFORM_NAME, 0, NULL, NULL);
    clGetDeviceIDs(NULL, CL_DEVICE_TYPE_ALL, 0, NULL, NULL);
    clGetDeviceInfo(NULL, CL_DEVICE_NAME, 0, NULL, NULL);
    clCreateContext(NULL, 0, NULL, NULL, NULL, NULL);
    clCreateContextFromType(NULL, CL_DEVICE_TYPE_DEFAULT, NULL, NULL, NULL);
    clRetainContext(NULL);
    clReleaseContext(NULL);
    clGetContextInfo(NULL, CL_CONTEXT_REFERENCE_COUNT, 0, NULL, NULL);
    clRetainCommandQueue(NULL);
    clReleaseCommandQueue(NULL);
    clGetCommandQueueInfo(NULL, CL_QUEUE_REFERENCE_COUNT, 0, NULL, NULL);
    clCreateBuffer(NULL, CL_MEM_READ_WRITE, 0, NULL, NULL);
    clRetainMemObject(NULL);
    clReleaseMemObject(NULL);
    clGetSupportedImageFormats(NULL, CL_MEM_READ_WRITE, CL_MEM_OBJECT_IMAGE2D, 0, NULL, NULL);
    clGetMemObjectInfo(NULL, CL_MEM_REFERENCE_COUNT, 0, NULL, NULL);
    clGetImageInfo(NULL, CL_IMAGE_FORMAT, 0, NULL, NULL);
    clRetainSampler(NULL);
    clReleaseSampler(NULL);
    clGetSamplerInfo(NULL, CL_SAMPLER_REFERENCE_COUNT, 0, NULL, NULL);
    clCreateProgramWithSource(NULL, 0, NULL, NULL, NULL);
    clCreateProgramWithBinary(NULL, 0, NULL, NULL, NULL, NULL, NULL);
    clRetainProgram(NULL);
    clReleaseProgram(NULL);
    clBuildProgram(NULL, 0, NULL, NULL, NULL, NULL);
    clGetProgramInfo(NULL, CL_PROGRAM_REFERENCE_COUNT, 0, NULL, NULL);
    clGetProgramBuildInfo(NULL, NULL, CL_PROGRAM_BUILD_STATUS, 0, NULL, NULL);
    clCreateKernel(NULL, NULL, NULL);
    clCreateKernelsInProgram(NULL, 0, NULL, NULL);
    clRetainKernel(NULL);
    clReleaseKernel(NULL);
    clSetKernelArg(NULL, 0, 0, NULL);
    clGetKernelInfo(NULL, CL_KERNEL_REFERENCE_COUNT, 0, NULL, NULL);
    clGetKernelWorkGroupInfo(NULL, NULL, CL_KERNEL_WORK_GROUP_SIZE, 0, NULL, NULL);
    clWaitForEvents(0, NULL);
    clGetEventInfo(NULL, CL_EVENT_REFERENCE_COUNT, 0, NULL, NULL);
    clRetainEvent(NULL);
    clReleaseEvent(NULL);
    clGetEventProfilingInfo(NULL, CL_PROFILING_COMMAND_QUEUED, 0, NULL, NULL);
    clFlush(NULL);
    clFinish(NULL);
    clEnqueueReadBuffer(NULL, NULL, CL_FALSE, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueWriteBuffer(NULL, NULL, CL_FALSE, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueCopyBuffer(NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL);
    clEnqueueReadImage(NULL, NULL, CL_FALSE, NULL, NULL, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueWriteImage(NULL, NULL, CL_FALSE, NULL, NULL, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueCopyImage(NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL);
    clEnqueueCopyImageToBuffer(NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL);
    clEnqueueCopyBufferToImage(NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL);
    clEnqueueMapBuffer(NULL, NULL, CL_FALSE, CL_MAP_READ, 0, 0, 0, NULL, NULL, NULL);
    clEnqueueMapImage(NULL, NULL, CL_FALSE, CL_MAP_READ, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL);
    clEnqueueUnmapMemObject(NULL, NULL, NULL, 0, NULL, NULL);
    clEnqueueNDRangeKernel(NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL);
    clEnqueueNativeKernel(NULL, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL);
    clSetCommandQueueProperty(NULL, CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, CL_FALSE, NULL);
    clCreateImage2D(NULL, CL_MEM_READ_WRITE, NULL, 0, 0, 0, NULL, NULL);
    clCreateImage3D(NULL, CL_MEM_READ_WRITE, NULL, 0, 0, 0, 0, 0, NULL, NULL);
    clEnqueueMarker(NULL, NULL);
    clEnqueueWaitForEvents(NULL, 0, NULL);
    clEnqueueBarrier(NULL);
    clCreateCommandQueue(NULL, NULL, 0, NULL);
    clCreateSampler(NULL, CL_FALSE, CL_ADDRESS_NONE, CL_FILTER_NEAREST, NULL);
    clEnqueueTask(NULL, NULL, 0, NULL, NULL);
#endif
#ifdef CL_VERSION_1_1
    clCreateSubBuffer(NULL, CL_MEM_READ_WRITE, CL_BUFFER_CREATE_TYPE_REGION, NULL, NULL);
    clSetMemObjectDestructorCallback(NULL, NULL, NULL);
    clCreateUserEvent(NULL, NULL);
    clSetUserEventStatus(NULL, CL_COMPLETE);
    clSetEventCallback(NULL, CL_COMPLETE, NULL, NULL);
    clEnqueueReadBufferRect(NULL, NULL, CL_FALSE, NULL, NULL, NULL, 0, 0, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueWriteBufferRect(NULL, NULL, CL_FALSE, NULL, NULL, NULL, 0, 0, 0, 0, NULL, 0, NULL, NULL);
    clEnqueueCopyBufferRect(NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL);
#endif
#ifdef CL_VERSION_1_2
    clCreateSubDevices(NULL, NULL, 0, NULL, NULL);
    clRetainDevice(NULL);
    clReleaseDevice(NULL);
    clCreateImage(NULL, CL_MEM_READ_WRITE, NULL, NULL, NULL, NULL);
    clCreateProgramWithBuiltInKernels(NULL, 0, NULL, NULL, NULL);
    clCompileProgram(NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
    clLinkProgram(NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL);
    clUnloadPlatformCompiler(NULL);
    clGetKernelArgInfo(NULL, 0, CL_KERNEL_ARG_NAME, 0, NULL, NULL);
    clEnqueueFillBuffer(NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL);
    clEnqueueFillImage(NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL);
    clEnqueueMigrateMemObjects(NULL, 0, NULL, CL_MIGRATE_MEM_OBJECT_HOST, 0, NULL, NULL);
    clEnqueueMarkerWithWaitList(NULL, 0, NULL, NULL);
    clEnqueueBarrierWithWaitList(NULL, 0, NULL, NULL);
    clGetExtensionFunctionAddressForPlatform(NULL, NULL);
#endif
#ifdef CL_VERSION_2_0
    clCreateCommandQueueWithProperties(NULL, NULL, NULL, NULL);
    clCreatePipe(NULL, CL_MEM_READ_WRITE, 0, 0, NULL, NULL);
    clGetPipeInfo(NULL, CL_PIPE_PACKET_SIZE, 0, NULL, NULL);
    clSVMAlloc(NULL, CL_MEM_READ_WRITE, 0, 0);
    clSVMFree(NULL, NULL);
    clCreateSamplerWithProperties(NULL, NULL, NULL);
    clSetKernelArgSVMPointer(NULL, 0, NULL);
    clSetKernelExecInfo(NULL, CL_KERNEL_EXEC_INFO_SVM_PTRS, 0, NULL);
    clEnqueueSVMFree(NULL, 0, NULL, NULL, NULL, 0, NULL, NULL);
    clEnqueueSVMMemcpy(NULL, CL_FALSE, NULL, NULL, 0, 0, NULL, NULL);
    clEnqueueSVMMemFill(NULL, NULL, NULL, 0, 0, 0, NULL, NULL);
    clEnqueueSVMMap(NULL, CL_FALSE, CL_MAP_READ, NULL, 0, 0, NULL, NULL);
    clEnqueueSVMUnmap(NULL, NULL, 0, NULL, NULL);
#endif
#ifdef CL_VERSION_2_1
    clSetDefaultDeviceCommandQueue(NULL, NULL, NULL);
    clGetDeviceAndHostTimer(NULL, NULL, NULL);
    clGetHostTimer(NULL, NULL);
    clCreateProgramWithIL(NULL, NULL, 0, NULL);
    clCloneKernel(NULL, NULL);
    clGetKernelSubGroupInfo(NULL, NULL, CL_KERNEL_MAX_NUM_SUB_GROUPS, 0, NULL, 0, NULL, NULL);
    clEnqueueSVMMigrateMem(NULL, 0, NULL, NULL, CL_MIGRATE_MEM_OBJECT_HOST, 0, NULL, NULL);
#endif
#ifdef CL_VERSION_2_2
    clSetProgramReleaseCallback(NULL, NULL, NULL);
    clSetProgramSpecializationConstant(NULL, 0, 0, NULL);
#endif
#ifdef CL_VERSION_3_0
    clSetContextDestructorCallback(NULL, NULL, NULL);
    clCreateBufferWithProperties(NULL, NULL, CL_MEM_READ_WRITE, 0, NULL, NULL);
    clCreateImageWithProperties(NULL, NULL, CL_MEM_READ_WRITE, NULL, NULL, NULL, NULL);
#endif
}
