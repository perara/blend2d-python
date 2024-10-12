# The MIT License (MIT)
#
# Copyright (c) 2019 John Wiggins
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# BLImage
# BL_API BLResult BL_CDECL blImageInit(BLImageCore* self) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageInitMove(BLImageCore* self, BLImageCore* other) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageInitWeak(BLImageCore* self, const BLImageCore* other) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageInitAs(BLImageCore* self, int w, int h, BLFormat format) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageInitAsFromData(BLImageCore* self, int w, int h, BLFormat format, void* pixelData, intptr_t stride, BLDataAccessFlags accessFlags, BLDestroyExternalDataFunc destroyFunc, void* userData) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageDestroy(BLImageCore* self) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageReset(BLImageCore* self) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageAssignMove(BLImageCore* self, BLImageCore* other) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageAssignWeak(BLImageCore* self, const BLImageCore* other) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageAssignDeep(BLImageCore* self, const BLImageCore* other) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageCreate(BLImageCore* self, int w, int h, BLFormat format) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageCreateFromData(BLImageCore* self, int w, int h, BLFormat format, void* pixelData, intptr_t stride, BLDataAccessFlags accessFlags, BLDestroyExternalDataFunc destroyFunc, void* userData) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageGetData(const BLImageCore* self, BLImageData* dataOut) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageMakeMutable(BLImageCore* self, BLImageData* dataOut) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageConvert(BLImageCore* self, BLFormat format) BL_NOEXCEPT_C;
# BL_API bool BL_CDECL blImageEquals(const BLImageCore* a, const BLImageCore* b) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageScale(BLImageCore* dst, const BLImageCore* src, const BLSizeI* size, BLImageScaleFilter filter) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageReadFromFile(BLImageCore* self, const char* fileName, const BLArrayCore* codecs) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageReadFromData(BLImageCore* self, const void* data, size_t size, const BLArrayCore* codecs) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageWriteToFile(const BLImageCore* self, const char* fileName, const BLImageCodecCore* codec) BL_NOEXCEPT_C;
# BL_API BLResult BL_CDECL blImageWriteToData(const BLImageCore* self, BLArrayCore* dst, const BLImageCodecCore* codec) BL_NOEXCEPT_C;)

cdef class Image:
    cdef _capi.BLImageCore _self
    cdef object _array_ref

    def __cinit__(self, char [:, :, :] array):
        cdef int w, h
        h, w = array.shape[0], array.shape[1]

        _capi.blImageInitAsFromData(
            &self._self,
            w, h,
            _capi.BL_FORMAT_XRGB32,
            <char*>&array[0][0][0],
            array.strides[0],
            _capi.BL_DATA_ACCESS_RW,
            _destroy_array_data, NULL
        )
        self._array_ref = array

    def __dealloc__(self):
        _capi.blImageDestroy(&self._self)
        self._array_ref = None
