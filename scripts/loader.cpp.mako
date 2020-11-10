<%
# APIs to skip - they need to be done "manually":
apiskip = {
    'clGetPlatformIDs',                 # calls into the ICD loader
    'clGetExtensionFunctionAddress',    # could call into the ICD loader or return NULL
    'clUnloadCompiler',                 # unconditionally returns CL_SUCCESS
    }

# Handles, and mappings to errors when handles are invalid:
apihandles = {
    'cl_command_queue'  : 'CL_INVALID_COMMAND_QUEUE',
    'cl_context'        : 'CL_INVALID_CONTEXT',
    'cl_device_id'      : 'CL_INVALID_DEVICE',
    'cl_event'          : 'CL_INVALID_EVENT',
    'cl_kernel'         : 'CL_INVALID_KERNEL',
    'cl_mem'            : 'CL_INVALID_MEM_OBJECT',
    'cl_platform_id'    : 'CL_INVALID_PLATFORM',
    'cl_program'        : 'CL_INVALID_PROGRAM',
    'cl_sampler'        : 'CL_INVALID_SAMPLER',
    }
%>/*
// Copyright (c) 2020 Ben Ashbaugh
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
*/

#include <CL/cl.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif

#include <stdlib.h>
#include <string.h>

#include <atomic>

#define _SCL_VALIDATE_HANDLE_RETURN_ERROR(_handle, _error)              ${"\\"}
    if (_handle == NULL) return _error;

#define _SCL_VALIDATE_HANDLE_RETURN_HANDLE(_handle, _error)             ${"\\"}
    if (_handle == NULL) {                                              ${"\\"}
        if (errcode_ret) *errcode_ret = _error;                         ${"\\"}
        return NULL;                                                    ${"\\"}
    }

///////////////////////////////////////////////////////////////////////////////
// API Function Pointers:
%for function in spec.findall('feature/require/command'):
<%
      api = apisigs[function.get('name')]
%>
#ifdef ${apivers[api.Name]}
typedef ${api.RetType} (CL_API_CALL *_sclpfn_${api.Name})(
%for i, param in enumerate(api.Params):
%  if i < len(api.Params)-1:
    ${param.Type} ${param.Name}${param.TypeEnd},
%  else:
    ${param.Type} ${param.Name}${param.TypeEnd});
%  endif
%endfor
#else
typedef void* _sclpfn_${api.Name};
#endif
%endfor

///////////////////////////////////////////////////////////////////////////////
// Dispatch Table - this must match the Khronos ICD loader!

struct _sclDispatchTable {
    /* OpenCL 1.0 */
    _sclpfn_clGetPlatformIDs                         clGetPlatformIDs;
    _sclpfn_clGetPlatformInfo                        clGetPlatformInfo;
    _sclpfn_clGetDeviceIDs                           clGetDeviceIDs;
    _sclpfn_clGetDeviceInfo                          clGetDeviceInfo;
    _sclpfn_clCreateContext                          clCreateContext;
    _sclpfn_clCreateContextFromType                  clCreateContextFromType;
    _sclpfn_clRetainContext                          clRetainContext;
    _sclpfn_clReleaseContext                         clReleaseContext;
    _sclpfn_clGetContextInfo                         clGetContextInfo;
    _sclpfn_clCreateCommandQueue                     clCreateCommandQueue;
    _sclpfn_clRetainCommandQueue                     clRetainCommandQueue;
    _sclpfn_clReleaseCommandQueue                    clReleaseCommandQueue;
    _sclpfn_clGetCommandQueueInfo                    clGetCommandQueueInfo;
    _sclpfn_clSetCommandQueueProperty                clSetCommandQueueProperty;
    _sclpfn_clCreateBuffer                           clCreateBuffer;
    _sclpfn_clCreateImage2D                          clCreateImage2D;
    _sclpfn_clCreateImage3D                          clCreateImage3D;
    _sclpfn_clRetainMemObject                        clRetainMemObject;
    _sclpfn_clReleaseMemObject                       clReleaseMemObject;
    _sclpfn_clGetSupportedImageFormats               clGetSupportedImageFormats;
    _sclpfn_clGetMemObjectInfo                       clGetMemObjectInfo;
    _sclpfn_clGetImageInfo                           clGetImageInfo;
    _sclpfn_clCreateSampler                          clCreateSampler;
    _sclpfn_clRetainSampler                          clRetainSampler;
    _sclpfn_clReleaseSampler                         clReleaseSampler;
    _sclpfn_clGetSamplerInfo                         clGetSamplerInfo;
    _sclpfn_clCreateProgramWithSource                clCreateProgramWithSource;
    _sclpfn_clCreateProgramWithBinary                clCreateProgramWithBinary;
    _sclpfn_clRetainProgram                          clRetainProgram;
    _sclpfn_clReleaseProgram                         clReleaseProgram;
    _sclpfn_clBuildProgram                           clBuildProgram;
    _sclpfn_clUnloadCompiler                         clUnloadCompiler;
    _sclpfn_clGetProgramInfo                         clGetProgramInfo;
    _sclpfn_clGetProgramBuildInfo                    clGetProgramBuildInfo;
    _sclpfn_clCreateKernel                           clCreateKernel;
    _sclpfn_clCreateKernelsInProgram                 clCreateKernelsInProgram;
    _sclpfn_clRetainKernel                           clRetainKernel;
    _sclpfn_clReleaseKernel                          clReleaseKernel;
    _sclpfn_clSetKernelArg                           clSetKernelArg;
    _sclpfn_clGetKernelInfo                          clGetKernelInfo;
    _sclpfn_clGetKernelWorkGroupInfo                 clGetKernelWorkGroupInfo;
    _sclpfn_clWaitForEvents                          clWaitForEvents;
    _sclpfn_clGetEventInfo                           clGetEventInfo;
    _sclpfn_clRetainEvent                            clRetainEvent;
    _sclpfn_clReleaseEvent                           clReleaseEvent;
    _sclpfn_clGetEventProfilingInfo                  clGetEventProfilingInfo;
    _sclpfn_clFlush                                  clFlush;
    _sclpfn_clFinish                                 clFinish;
    _sclpfn_clEnqueueReadBuffer                      clEnqueueReadBuffer;
    _sclpfn_clEnqueueWriteBuffer                     clEnqueueWriteBuffer;
    _sclpfn_clEnqueueCopyBuffer                      clEnqueueCopyBuffer;
    _sclpfn_clEnqueueReadImage                       clEnqueueReadImage;
    _sclpfn_clEnqueueWriteImage                      clEnqueueWriteImage;
    _sclpfn_clEnqueueCopyImage                       clEnqueueCopyImage;
    _sclpfn_clEnqueueCopyImageToBuffer               clEnqueueCopyImageToBuffer;
    _sclpfn_clEnqueueCopyBufferToImage               clEnqueueCopyBufferToImage;
    _sclpfn_clEnqueueMapBuffer                       clEnqueueMapBuffer;
    _sclpfn_clEnqueueMapImage                        clEnqueueMapImage;
    _sclpfn_clEnqueueUnmapMemObject                  clEnqueueUnmapMemObject;
    _sclpfn_clEnqueueNDRangeKernel                   clEnqueueNDRangeKernel;
    _sclpfn_clEnqueueTask                            clEnqueueTask;
    _sclpfn_clEnqueueNativeKernel                    clEnqueueNativeKernel;
    _sclpfn_clEnqueueMarker                          clEnqueueMarker;
    _sclpfn_clEnqueueWaitForEvents                   clEnqueueWaitForEvents;
    _sclpfn_clEnqueueBarrier                         clEnqueueBarrier;
    _sclpfn_clGetExtensionFunctionAddress            clGetExtensionFunctionAddress;
    void* /* _sclpfn_clCreateFromGLBuffer       */   clCreateFromGLBuffer;
    void* /* _sclpfn_clCreateFromGLTexture2D    */   clCreateFromGLTexture2D;
    void* /* _sclpfn_clCreateFromGLTexture3D    */   clCreateFromGLTexture3D;
    void* /* _sclpfn_clCreateFromGLRenderbuffer */   clCreateFromGLRenderbuffer;
    void* /* _sclpfn_clGetGLObjectInfo          */   clGetGLObjectInfo;
    void* /* _sclpfn_clGetGLTextureInfo         */   clGetGLTextureInfo;
    void* /* _sclpfn_clEnqueueAcquireGLObjects  */   clEnqueueAcquireGLObjects;
    void* /* _sclpfn_clEnqueueReleaseGLObjects  */   clEnqueueReleaseGLObjects;
    void* /* _sclpfn_clGetGLContextInfoKHR      */   clGetGLContextInfoKHR;

    /* cl_khr_d3d10_sharing */
    void* /* _sclpfn_clGetDeviceIDsFromD3D10KHR      */ clGetDeviceIDsFromD3D10KHR;
    void* /* _sclpfn_clCreateFromD3D10BufferKHR      */ clCreateFromD3D10BufferKHR;
    void* /* _sclpfn_clCreateFromD3D10Texture2DKHR   */ clCreateFromD3D10Texture2DKHR;
    void* /* _sclpfn_clCreateFromD3D10Texture3DKHR   */ clCreateFromD3D10Texture3DKHR;
    void* /* _sclpfn_clEnqueueAcquireD3D10ObjectsKHR */ clEnqueueAcquireD3D10ObjectsKHR;
    void* /* _sclpfn_clEnqueueReleaseD3D10ObjectsKHR */ clEnqueueReleaseD3D10ObjectsKHR;

    /* OpenCL 1.1 */
    _sclpfn_clSetEventCallback                       clSetEventCallback;
    _sclpfn_clCreateSubBuffer                        clCreateSubBuffer;
    _sclpfn_clSetMemObjectDestructorCallback         clSetMemObjectDestructorCallback;
    _sclpfn_clCreateUserEvent                        clCreateUserEvent;
    _sclpfn_clSetUserEventStatus                     clSetUserEventStatus;
    _sclpfn_clEnqueueReadBufferRect                  clEnqueueReadBufferRect;
    _sclpfn_clEnqueueWriteBufferRect                 clEnqueueWriteBufferRect;
    _sclpfn_clEnqueueCopyBufferRect                  clEnqueueCopyBufferRect;

    /* cl_ext_device_fission */
    void* /* _sclpfn_clCreateSubDevicesEXT */       clCreateSubDevicesEXT;
    void* /* _sclpfn_clRetainDeviceEXT     */       clRetainDeviceEXT;
    void* /* _sclpfn_clReleaseDeviceEXT    */       clReleaseDeviceEXT;

    /* cl_khr_gl_event */
    void* /* _sclpfn_clCreateEventFromGLsyncKHR */  clCreateEventFromGLsyncKHR;

    /* OpenCL 1.2 */
    _sclpfn_clCreateSubDevices                      clCreateSubDevices;
    _sclpfn_clRetainDevice                          clRetainDevice;
    _sclpfn_clReleaseDevice                         clReleaseDevice;
    _sclpfn_clCreateImage                           clCreateImage;
    _sclpfn_clCreateProgramWithBuiltInKernels       clCreateProgramWithBuiltInKernels;
    _sclpfn_clCompileProgram                        clCompileProgram;
    _sclpfn_clLinkProgram                           clLinkProgram;
    _sclpfn_clUnloadPlatformCompiler                clUnloadPlatformCompiler;
    _sclpfn_clGetKernelArgInfo                      clGetKernelArgInfo;
    _sclpfn_clEnqueueFillBuffer                     clEnqueueFillBuffer;
    _sclpfn_clEnqueueFillImage                      clEnqueueFillImage;
    _sclpfn_clEnqueueMigrateMemObjects              clEnqueueMigrateMemObjects;
    _sclpfn_clEnqueueMarkerWithWaitList             clEnqueueMarkerWithWaitList;
    _sclpfn_clEnqueueBarrierWithWaitList            clEnqueueBarrierWithWaitList;
    _sclpfn_clGetExtensionFunctionAddressForPlatform clGetExtensionFunctionAddressForPlatform;
    void* /* _sclpfn_clCreateFromGLTexture */       clCreateFromGLTexture;

    /* cl_khr_d3d11_sharing */
    void* /* _sclpfn_clGetDeviceIDsFromD3D11KHR      */ clGetDeviceIDsFromD3D11KHR;
    void* /* _sclpfn_clCreateFromD3D11BufferKHR      */ clCreateFromD3D11BufferKHR;
    void* /* _sclpfn_clCreateFromD3D11Texture2DKHR   */ clCreateFromD3D11Texture2DKHR;
    void* /* _sclpfn_clCreateFromD3D11Texture3DKHR   */ clCreateFromD3D11Texture3DKHR;
    void* /* _sclpfn_clCreateFromDX9MediaSurfaceKHR  */ clCreateFromDX9MediaSurfaceKHR;
    void* /* _sclpfn_clEnqueueAcquireD3D11ObjectsKHR */ clEnqueueAcquireD3D11ObjectsKHR;
    void* /* _sclpfn_clEnqueueReleaseD3D11ObjectsKHR */ clEnqueueReleaseD3D11ObjectsKHR;

    /* cl_khr_dx9_media_sharing */
    void* /* _sclpfn_clGetDeviceIDsFromDX9MediaAdapterKHR */    clGetDeviceIDsFromDX9MediaAdapterKHR;
    void* /* _sclpfn_clEnqueueAcquireDX9MediaSurfacesKHR  */    clEnqueueAcquireDX9MediaSurfacesKHR;
    void* /* _sclpfn_clEnqueueReleaseDX9MediaSurfacesKHR  */    clEnqueueReleaseDX9MediaSurfacesKHR;

    /* cl_khr_egl_image */
    void* /* _sclpfn_clCreateFromEGLImageKHR       */   clCreateFromEGLImageKHR;
    void* /* _sclpfn_clEnqueueAcquireEGLObjectsKHR */   clEnqueueAcquireEGLObjectsKHR;
    void* /* _sclpfn_clEnqueueReleaseEGLObjectsKHR */   clEnqueueReleaseEGLObjectsKHR;

    /* cl_khr_egl_event */
    void* /* _sclpfn_clCreateEventFromEGLSyncKHR  */    clCreateEventFromEGLSyncKHR;

    /* OpenCL 2.0 */
    _sclpfn_clCreateCommandQueueWithProperties      clCreateCommandQueueWithProperties;
    _sclpfn_clCreatePipe                            clCreatePipe;
    _sclpfn_clGetPipeInfo                           clGetPipeInfo;
    _sclpfn_clSVMAlloc                              clSVMAlloc;
    _sclpfn_clSVMFree                               clSVMFree;
    _sclpfn_clEnqueueSVMFree                        clEnqueueSVMFree;
    _sclpfn_clEnqueueSVMMemcpy                      clEnqueueSVMMemcpy;
    _sclpfn_clEnqueueSVMMemFill                     clEnqueueSVMMemFill;
    _sclpfn_clEnqueueSVMMap                         clEnqueueSVMMap;
    _sclpfn_clEnqueueSVMUnmap                       clEnqueueSVMUnmap;
    _sclpfn_clCreateSamplerWithProperties           clCreateSamplerWithProperties;
    _sclpfn_clSetKernelArgSVMPointer                clSetKernelArgSVMPointer;
    _sclpfn_clSetKernelExecInfo                     clSetKernelExecInfo;

    /* cl_khr_sub_groups */
    void* /* _sclpfn_clGetKernelSubGroupInfoKHR */  clGetKernelSubGroupInfoKHR;

    /* OpenCL 2.1 */
    _sclpfn_clCloneKernel                           clCloneKernel;
    _sclpfn_clCreateProgramWithIL                   clCreateProgramWithIL;
    _sclpfn_clEnqueueSVMMigrateMem                  clEnqueueSVMMigrateMem;
    _sclpfn_clGetDeviceAndHostTimer                 clGetDeviceAndHostTimer;
    _sclpfn_clGetHostTimer                          clGetHostTimer;
    _sclpfn_clGetKernelSubGroupInfo                 clGetKernelSubGroupInfo;
    _sclpfn_clSetDefaultDeviceCommandQueue          clSetDefaultDeviceCommandQueue;

    /* OpenCL 2.2 */
    _sclpfn_clSetProgramReleaseCallback             clSetProgramReleaseCallback;
    _sclpfn_clSetProgramSpecializationConstant      clSetProgramSpecializationConstant;

    /* OpenCL 3.0 */
    _sclpfn_clCreateBufferWithProperties            clCreateBufferWithProperties;
    _sclpfn_clCreateImageWithProperties             clCreateImageWithProperties;
    _sclpfn_clSetContextDestructorCallback          clSetContextDestructorCallback;
};

struct _cl_platform_id {
    _sclDispatchTable *dispatch;
};

struct _cl_device_id {
    _sclDispatchTable *dispatch;
};

struct _cl_context {
    _sclDispatchTable *dispatch;
};

struct _cl_command_queue {
    _sclDispatchTable *dispatch;
};

struct _cl_mem {
    _sclDispatchTable *dispatch;
};

struct _cl_program {
    _sclDispatchTable *dispatch;
};

struct _cl_kernel {
    _sclDispatchTable *dispatch;
};

struct _cl_event {
    _sclDispatchTable *dispatch;
};

struct _cl_sampler {
    _sclDispatchTable *dispatch;
};

///////////////////////////////////////////////////////////////////////////////
// Manually written API function definitions:

// This error code is defined by the ICD extension, but it may not have
// been included yet:
#ifdef CL_PLATFORM_NOT_FOUND_KHR
#define _SCL_PLATFORM_NOT_FOUND_KHR CL_PLATFORM_NOT_FOUND_KHR
#else
#define _SCL_PLATFORM_NOT_FOUND_KHR -1001
#endif

#ifdef _WIN32
typedef HMODULE _sclModuleHandle;
#define _sclOpenICDLoader()                     ::LoadLibraryA("OpenCL.dll")
#define _sclCloseICDLoader(_module)             ::FreeLibrary(_module)
#define _sclGetFunctionAddress(_module, _name)  ::GetProcAddress(_module, _name)
#else
typedef void*   _sclModuleHandle;
static inline _sclModuleHandle _sclOpenICDLoader()
{
    _sclModuleHandle ret = ::dlopen("libOpenCL.so.1", RTLD_LAZY | RTLD_LOCAL);
    if (ret == NULL) {
        ret = ::dlopen("libOpenCL.so", RTLD_LAZY | RTLD_LOCAL);
    }
    return ret;
}
#define _sclCloseICDLoader(_module)             ::dlclose(_module)
#define _sclGetFunctionAddress(_module, _name)  ::dlsym(_module, _name)
#endif

#define _SCL_MAKE_VERSION(_major, _minor)   (((_major) << 16) | (_minor))

static std::atomic<_sclModuleHandle> g_ICDLoaderHandle{NULL};

// This is a helper function to safely get a handle the ICD loader:
static inline _sclModuleHandle _sclGetICDLoaderHandle(void)
{
    _sclModuleHandle ret = g_ICDLoaderHandle.load();
    if (ret == NULL) {
        _sclModuleHandle loaded = _sclOpenICDLoader();
        if (loaded != NULL) {
            if (g_ICDLoaderHandle.compare_exchange_strong(ret, loaded)) {
                ret = loaded;
            } else {
                _sclCloseICDLoader(loaded);
            }
        }
    }
    return ret;
}

// This is a helper function to allocate and get a platform info string.
// The platform info string returned by this function must be freed!
static inline cl_int _sclAllocateAndGetPlatformInfoString(
    _sclpfn_clGetPlatformInfo _clGetPlatformInfo,
    cl_platform_id platform,
    cl_platform_info param_name,
    char*& param_value)
{
    cl_int errorCode = CL_SUCCESS;
    size_t size = 0;

    if (_clGetPlatformInfo == NULL) {
        return CL_INVALID_OPERATION;
    }

    if (param_value != NULL) {
        return CL_INVALID_VALUE;
    }

    errorCode = _clGetPlatformInfo(
        platform,
        param_name,
        0,
        NULL,
        &size);

    if (errorCode == CL_SUCCESS && size != 0) {
        param_value = (char*)malloc(size);
        if (param_value == NULL) {
            errorCode = CL_OUT_OF_HOST_MEMORY;
        }
    }

    if (errorCode == CL_SUCCESS) {
        errorCode = _clGetPlatformInfo(
            platform,
            param_name,
            size,
            param_value,
            NULL);
    }

    if (errorCode != CL_SUCCESS) {
        free(param_value);
        param_value = NULL;
    }

    return errorCode;
}

// This is a helper function to get a major and minor version from a string.
// The string is expected to be formatted as a platform or device version
// string, with the format: "OpenCL <major>.<minor>".  If the string is
// not formatted properly, a version equal to 0.0.0 will be returned.
static inline cl_uint _sclGetMajorMinorVersion(
    const char* versionString)
{
    const char* prefix = "OpenCL ";
    const char* str = versionString;

    cl_uint major = 0;
    cl_uint minor = 0;

    if (str) {
        if (strncmp(str, prefix, strlen(prefix)) == 0) {
            str += strlen(prefix);
            while (isdigit(str[0])) {
                major *= 10;
                major += str[0] - '0';
                str++;
            }
            if (str[0] == '.') {
                str++;
            }
            while (isdigit(str[0])) {
                minor *= 10;
                minor += str[0] - '0';
                str++;
            }
            return _SCL_MAKE_VERSION(major, minor);
        }
    }

    return _SCL_MAKE_VERSION(0, 0);
}

// This is a helper function to check an extension string for an extension.
static inline bool _sclHasExtension(
    const char* extensionString,
    const char* extensionName)
{
    // Check that the extension name is not NULL and does not contain a space.
    if (extensionName == NULL || strchr(extensionName, ' ')) {
        return false;
    }

    bool supported = false;

    const char* start = extensionString;
    while (true) {
        const char* where = strstr(start, extensionName);
        if (!where) {
            break;
        }
        const char* terminator = where + strlen(extensionName);
        if (where == start || *(where - 1) == ' ') {
            if (*terminator == ' ' || *terminator == '\0') {
                supported = true;
                break;
            }
        }
        start = terminator;
    }

    return supported;
}

// This is a helper function to determine if we can return this platform:
static inline void _sclFilterPlatforms(
    _sclModuleHandle module,
    cl_uint total_num_platforms,
    cl_platform_id* all_platforms,
    cl_uint num_entries,
    cl_platform_id* platforms,
    cl_uint* num_platforms)
{
    _sclpfn_clGetPlatformInfo _clGetPlatformInfo =
        (_sclpfn_clGetPlatformInfo)_sclGetFunctionAddress(
            module, "clGetPlatformInfo");
    _sclpfn_clGetExtensionFunctionAddressForPlatform
        _clGetExtensionFunctionAddressForPlatform =
            (_sclpfn_clGetExtensionFunctionAddressForPlatform)
                _sclGetFunctionAddress(
                    module, "clGetExtensionFunctionAddressForPlatform");

    cl_uint num_icd_platforms = 0;

    for (cl_uint p = 0; p < total_num_platforms; p++) {
        // Include this platform if the ICD extension cl_khr_icd is in the
        // platform extension string, or if this is an OpenCL 1.2 or newer
        // platform and we can get a function pointer to the ICD function
        // clIcdGetPlatformIDsKHR.
        cl_int errorCode = CL_SUCCESS;

        char* platformVersion = NULL;
        char* platformExtensions = NULL;

        errorCode |= _sclAllocateAndGetPlatformInfoString(
            _clGetPlatformInfo,
            all_platforms[p],
            CL_PLATFORM_VERSION,
            platformVersion);
        errorCode |= _sclAllocateAndGetPlatformInfoString(
            _clGetPlatformInfo,
            all_platforms[p],
            CL_PLATFORM_EXTENSIONS,
            platformExtensions);

        if (errorCode == CL_SUCCESS) {
            cl_version version = _sclGetMajorMinorVersion(platformVersion);

            bool has_cl_khr_icd =
                _sclHasExtension(platformExtensions, "cl_khr_icd");
            bool has_clIcdGetPlatformIDsKHR =
                (version >= _SCL_MAKE_VERSION(1, 2)) &&
                (_clGetExtensionFunctionAddressForPlatform(
                     all_platforms[p], "clIcdGetPlatformIDsKHR") != NULL);

            if (has_cl_khr_icd || has_clIcdGetPlatformIDsKHR) {
                if (num_icd_platforms < num_entries && platforms != NULL) {
                    platforms[num_icd_platforms] = all_platforms[p];
                }
                num_icd_platforms++;
            }
        }

        free(platformVersion);
        free(platformExtensions);
    }

    if (num_platforms) {
        num_platforms[0] = num_icd_platforms;
    }
}

// This is a helper function to find a platform from context properties:
static inline cl_platform_id _sclGetPlatfromFromContextProperties(
    const cl_context_properties* properties)
{
    if (properties != NULL) {
        while (properties[0] != 0 ) {
            if (CL_CONTEXT_PLATFORM == (cl_int)properties[0]) {
                cl_platform_id platform = (cl_platform_id)properties[1];
                return platform;
            }
            properties += 2;
        }
    }
    return NULL;
}

#ifdef __cplusplus
extern "C" {
#endif

CL_API_ENTRY cl_int CL_API_CALL clGetPlatformIDs(
    cl_uint num_entries,
    cl_platform_id* platforms,
    cl_uint* num_platforms)
{
    // Basic error checks:
    if ((platforms == NULL && num_entries != 0) ||
        (platforms == NULL && num_platforms == NULL)) {
        return CL_INVALID_VALUE;
    }

    _sclModuleHandle module = _sclGetICDLoaderHandle();
    _sclpfn_clGetPlatformIDs _clGetPlatformIDs = NULL;

    if (module) {
        _clGetPlatformIDs =
            (_sclpfn_clGetPlatformIDs)_sclGetFunctionAddress(
                module, "clGetPlatformIDs");
    }

    if (_clGetPlatformIDs) {
        cl_int errorCode = CL_SUCCESS;
        cl_platform_id* all_platforms = NULL;
        cl_uint total_num_platforms = 0;

        // Get the total number of platforms:
        _clGetPlatformIDs(0, NULL, &total_num_platforms);
        if (total_num_platforms >= 0) {
            all_platforms = (cl_platform_id*)malloc(
                total_num_platforms * sizeof(cl_platform_id));
            if (all_platforms == NULL) {
                return CL_OUT_OF_HOST_MEMORY;
            }

            errorCode = _clGetPlatformIDs(total_num_platforms, all_platforms, NULL);
            if (errorCode == CL_SUCCESS) {
                _sclFilterPlatforms(
                    module,
                    total_num_platforms,
                    all_platforms,
                    num_entries,
                    platforms,
                    num_platforms);
            }

            free(all_platforms);
            return errorCode;
        }
    }

    // The cl_khr_icd spec says that an error should be returned if no
    // platforms are found, but this is not an error condition in the OpenCL
    // spec.
#if 1
    return _SCL_PLATFORM_NOT_FOUND_KHR;
#else
    if (num_platforms) {
        num_platforms[0] = 0;
    }
    return CL_SUCCESS;
#endif
}

CL_API_ENTRY void* CL_API_CALL clGetExtensionFunctionAddress(
    const char* function_name)
{
#if 0
    _sclModuleHandle module = _sclGetICDLoaderHandle();
    _sclpfn_clGetExtensionFunctionAddress _clGetExtensionFunctionAddress =
        (_sclpfn_clGetExtensionFunctionAddress)::GetProcAddress(
            module, "clGetExtensionFunctionAddress");
    if (_clGetExtensionFunctionAddress) {
        return _clGetExtensionFunctionAddress(function_name);
    }
#endif
    return NULL;
}

CL_API_ENTRY cl_int CL_API_CALL clUnloadCompiler(void)
{
    return CL_SUCCESS;
}

///////////////////////////////////////////////////////////////////////////////
// Generated API function definitions:
%for function in spec.findall('feature/require/command'):
%  if not function.get('name') in apiskip:
<%
      api = apisigs[function.get('name')]
      handle = api.Params[0]
      if handle.Type in apihandles:
          invalid = apihandles[handle.Type]
      else:
          invalid = 'NULL'
%>
#ifdef ${apivers[api.Name]}

CL_API_ENTRY ${api.RetType} CL_API_CALL ${api.Name}(
%for i, param in enumerate(api.Params):
%  if i < len(api.Params)-1:
    ${param.Type} ${param.Name}${param.TypeEnd},
%  else:
    ${param.Type} ${param.Name}${param.TypeEnd})
%  endif
%endfor
{
%if api.RetType in apihandles or api.RetType == "void*":
## clCreateContext is a special case, since it calls through
## the dispatch table via the first "device":
%  if api.Name == "clCreateContext":
    if (${api.Params[1].Name} == 0 || ${api.Params[2].Name} == NULL) {
        _SCL_VALIDATE_HANDLE_RETURN_HANDLE(NULL, CL_INVALID_VALUE);
    }
    _SCL_VALIDATE_HANDLE_RETURN_HANDLE(${api.Params[2].Name}[0], CL_INVALID_DEVICE);
## clCreateContextFromType is a special case, since it calls
## through a platform passed via properties:
%  elif api.Name == "clCreateContextFromType":
    cl_platform_id platform = _sclGetPlatfromFromContextProperties(${api.Params[0].Name});
    _SCL_VALIDATE_HANDLE_RETURN_HANDLE(platform, CL_INVALID_PLATFORM);
## These APIs are special cases because they return a void*, but
## do not nave an errcode_ret:
%  elif api.Name == "clSVMAlloc" or api.Name == "clGetExtensionFunctionAddressForPlatform":
    _SCL_VALIDATE_HANDLE_RETURN_ERROR(${handle.Name}, NULL);
%  else:
    _SCL_VALIDATE_HANDLE_RETURN_HANDLE(${handle.Name}, ${invalid});
%  endif
%elif api.Name == "clSVMFree":
## clSVMFree has no return value or errcode_ret:
    if (${handle.Name} == NULL) return;
## clWaitForEvents is a special case, since it calls through
## the dispatch table via the first "event":
%elif api.Name == "clWaitForEvents":
    if (${api.Params[0].Name} == 0 || ${api.Params[1].Name} == NULL) {
        return CL_INVALID_VALUE;
    }
    _SCL_VALIDATE_HANDLE_RETURN_ERROR(${api.Params[1].Name}[0], CL_INVALID_EVENT);
%else:
    _SCL_VALIDATE_HANDLE_RETURN_ERROR(${handle.Name}, ${invalid});
%endif
%if api.Name == "clCreateContext":
    return ${api.Params[2].Name}[0]->dispatch->${api.Name}(
%elif api.Name == "clWaitForEvents":
    return ${api.Params[1].Name}[0]->dispatch->${api.Name}(
%elif api.Name == "clCreateContextFromType":
    return platform->dispatch->${api.Name}(
%elif api.Name == "clSVMFree":
    ${handle.Name}->dispatch->${api.Name}(
%else:
    return ${handle.Name}->dispatch->${api.Name}(
%endif:
%for i, param in enumerate(api.Params):
%  if i < len(api.Params)-1:
        ${param.Name},
%  else:
        ${param.Name});
%  endif
%endfor
}

#endif

///////////////////////////////////////////////////////////////////////////////
%  endif
%endfor

#ifdef __cplusplus
}
#endif
