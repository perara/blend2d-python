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

# BLMatrix2D
# BLResult blMatrix2DSetIdentity(BLMatrix2D* self)
# BLResult blMatrix2DSetTranslation(BLMatrix2D* self, double x, double y)
# BLResult blMatrix2DSetScaling(BLMatrix2D* self, double x, double y)
# BLResult blMatrix2DSetSkewing(BLMatrix2D* self, double x, double y)
# BLResult blMatrix2DSetRotation(BLMatrix2D* self, double angle, double cx, double cy)
# BLResult blMatrix2DApplyOp(BLMatrix2D* self, BLTransformOp opType, const void* opData)
# BLResult blMatrix2DInvert(BLMatrix2D* dst, const BLMatrix2D* src)
# uint32_t blMatrix2DGetType(const BLMatrix2D* self)
# BLResult blMatrix2DMapPointDArray(const BLMatrix2D* self, BLPoint* dst, const BLPoint* src, size_t count)



cdef class Matrix2D:
    cdef _capi.BLMatrix2D _self

    def __cinit__(self):
        _capi.blMatrix2DSetIdentity(&self._self)

    def rotate(self, double angle, double cx, double cy):
        cdef double data[3]
        data[0] = angle
        data[1] = cx
        data[2] = cy
        _capi.blMatrix2DApplyOp(&self._self, _capi.BLTransformOp.BL_TRANSFORM_OP_ROTATE_PT, data)

    def scale(self, double x, double y):
        cdef double data[2]
        data[0] = x
        data[1] = y
        _capi.blMatrix2DApplyOp(&self._self, _capi.BLTransformOp.BL_TRANSFORM_OP_SCALE, data)

    def translate(self, double x, double y):
        cdef double data[2]
        data[0] = x
        data[1] = y
        _capi.blMatrix2DApplyOp(&self._self, _capi.BLTransformOp.BL_TRANSFORM_OP_TRANSLATE, data)


cdef class Rect:
    cdef _capi.BLRect _self

    def __cinit__(self, float x, float y, float w, float h):
        self._self.x = x
        self._self.y = y
        self._self.w = w
        self._self.h = h


cdef class RectI:
    cdef _capi.BLRectI _self

    def __cinit__(self, int x, int y, int w, int h):
        self._self.x = x
        self._self.y = y
        self._self.w = w
        self._self.h = h
