# OpenCL Runtime Loader

This repository contains a static runtime loader library for OpenCL APIs.

Rather than linking to the dynamic OpenCL ICD loader library, applications may instead link to this static runtime loader library.
The static runtime loader library will open the standard OpenCL ICD loader library to enumerate platforms, but all other OpenCL APIs are implemented as part of this library.

This library is a work in progress.
Check back soon for updates!

---

OpenCL and the OpenCL logo are trademarks of Apple Inc. used by permission by Khronos.

\* Other names and brands may be claimed as the property of others.
