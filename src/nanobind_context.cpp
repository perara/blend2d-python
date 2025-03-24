#include "nanobind_common.h"

void register_context(nb::module_ &m)
{
     nb::class_<BLContext>(m, "BLContext")
         .def(nb::init<>()) // Default constructor
         .def(nb::init<BLImage &>(), nb::arg("image"))
         .def("__del__", [](BLContext *self)
              {
            self->end();
            self->reset(); })
         .def("__enter__", [](BLContext &self)
              {
            self.save();
            return &self; })
         .def("__exit__", [](BLContext &self, nb::object exc_type, nb::object exc_value, nb::object traceback)
              { self.restore(); })
         .def("clear_all", [](BLContext &self)
              { self.clearAll(); })
         .def("fill_all", [](BLContext &self)
              { self.fillAll(); })
         .def("flush", [](BLContext &self)
              { self.flush(BL_CONTEXT_FLUSH_SYNC); })
         .def("restore", [](BLContext &self)
              { self.restore(); })
         .def("save", [](BLContext &self)
              { self.save(); })
         .def("clip_to_rect", [](BLContext &self, const BLRect &rect)
              { self.clipToRect(rect); }, nb::arg("rect"))
         .def("restore_clipping", [](BLContext &self)
              { self.restoreClipping(); })
         .def("get_meta_transform", [](BLContext &self)
              { return self.metaTransform(); })
         .def("get_user_transform", [](BLContext &self)
              { return self.userTransform(); })
         .def("reset_transform", [](BLContext &self)
              { self.resetTransform(); })
         .def("rotate", [](BLContext &self, double angle)
              { self.rotate(angle); }, nb::arg("angle"))
         .def("rotate_around", [](BLContext &self, double angle, double x, double y)
              { 
            // Use _applyTransformOp with BL_TRANSFORM_OP_ROTATE_PT
            double values[3] = { angle, x, y };
            self._applyTransformOp(BL_TRANSFORM_OP_ROTATE_PT, values); }, nb::arg("angle"), nb::arg("x"), nb::arg("y"))
         .def("scale", [](BLContext &self, double x, double y)
              { self.scale(x, y); }, nb::arg("x"), nb::arg("y"))
         .def("skew", [](BLContext &self, double x, double y)
              { self.skew(x, y); }, nb::arg("x"), nb::arg("y"))
         .def("transform", [](BLContext &self, const BLMatrix2D &matrix)
              { 
            // Use setTransform instead of transform
            self.setTransform(matrix); }, nb::arg("matrix"))
         .def("translate", [](BLContext &self, double x, double y)
              { self.translate(x, y); }, nb::arg("x"), nb::arg("y"))
         .def("user_to_meta", [](BLContext &self)
              { self.userToMeta(); })
         .def_prop_rw("comp_op", [](const BLContext &self)
                      { return self.compOp(); }, [](BLContext &self, BLCompOp op)
                      { self.setCompOp(op); })
         .def_prop_rw("global_alpha", [](const BLContext &self)
                      { return self.globalAlpha(); }, [](BLContext &self, double alpha)
                      { self.setGlobalAlpha(alpha); })
         .def_prop_rw("fill_alpha", [](const BLContext &self)
                      { return self.fillAlpha(); }, [](BLContext &self, double alpha)
                      { self.setFillAlpha(alpha); })
         .def_prop_rw("fill_rule", [](const BLContext &self)
                      { return self.fillRule(); }, [](BLContext &self, BLFillRule rule)
                      { self.setFillRule(rule); })
         .def("set_fill_style", [](BLContext &self, const nb::tuple &color)
              {
            uint32_t packed = _get_rgba32_value(color);
            self.setFillStyle(BLRgba32(packed)); }, nb::arg("color"))
         .def("set_fill_style", [](BLContext &self, const BLGradient &gradient)
              { self.setFillStyle(gradient); }, nb::arg("gradient"))
         .def("set_fill_style", [](BLContext &self, const BLPattern &pattern)
              { self.setFillStyle(pattern); }, nb::arg("pattern"))
         .def_prop_rw("stroke_alpha", [](const BLContext &self)
                      { return self.strokeAlpha(); }, [](BLContext &self, double alpha)
                      { self.setStrokeAlpha(alpha); })
         .def("set_stroke_style", [](BLContext &self, const nb::tuple &color)
              {
            uint32_t packed = _get_rgba32_value(color);
            self.setStrokeStyle(BLRgba32(packed)); }, nb::arg("color"))
         .def("set_stroke_style", [](BLContext &self, const BLGradient &gradient)
              { self.setStrokeStyle(gradient); }, nb::arg("gradient"))
         .def("set_stroke_style", [](BLContext &self, const BLPattern &pattern)
              { self.setStrokeStyle(pattern); }, nb::arg("pattern"))
         .def_prop_rw("stroke_width", [](const BLContext &self)
                      { return self.strokeWidth(); }, [](BLContext &self, double width)
                      { self.setStrokeWidth(width); })
         .def_prop_rw("stroke_miter_limit", [](const BLContext &self)
                      { return self.strokeMiterLimit(); }, [](BLContext &self, double limit)
                      { self.setStrokeMiterLimit(limit); })
         .def("set_stroke_cap", [](BLContext &self, BLStrokeCapPosition position, BLStrokeCap cap)
              { self.setStrokeCap(position, cap); }, nb::arg("position"), nb::arg("cap"))
         .def("set_stroke_caps", [](BLContext &self, BLStrokeCap cap)
              { self.setStrokeCaps(cap); }, nb::arg("cap"))
         .def_prop_rw("stroke_join", [](const BLContext &self)
                      { return self.strokeJoin(); }, [](BLContext &self, BLStrokeJoin join)
                      { self.setStrokeJoin(join); })
         .def_prop_rw("stroke_dash_offset", [](const BLContext &self)
                      { return self.strokeDashOffset(); }, [](BLContext &self, double offset)
                      { self.setStrokeDashOffset(offset); })
         .def("set_stroke_dash_array", [](BLContext &self, const BLArray<double> &array)
              { self.setStrokeDashArray(array); }, nb::arg("array"))
         .def("clear_rect", [](BLContext &self, const BLRect &rect)
              { self.clearRect(rect); }, nb::arg("rect"))
         .def("fill_rect", [](BLContext &self, const BLRect &rect)
              { self.fillRect(rect); }, nb::arg("rect"))
         .def("stroke_rect", [](BLContext &self, const BLRect &rect)
              { self.strokeRect(rect); }, nb::arg("rect"))
         .def("fill_circle", [](BLContext &self, double cx, double cy, double r)
              { self.fillCircle(cx, cy, r); }, nb::arg("cx"), nb::arg("cy"), nb::arg("r"))
         .def("stroke_circle", [](BLContext &self, double cx, double cy, double r)
              { self.strokeCircle(cx, cy, r); }, nb::arg("cx"), nb::arg("cy"), nb::arg("r"))
         .def("fill_ellipse", [](BLContext &self, double cx, double cy, double rx, double ry)
              { self.fillEllipse(cx, cy, rx, ry); }, nb::arg("cx"), nb::arg("cy"), nb::arg("rx"), nb::arg("ry"))
         .def("stroke_ellipse", [](BLContext &self, double cx, double cy, double rx, double ry)
              { self.strokeEllipse(cx, cy, rx, ry); }, nb::arg("cx"), nb::arg("cy"), nb::arg("rx"), nb::arg("ry"))
         .def("fill_path", [](BLContext &self, const BLPath &path)
              { self.fillPath(path); }, nb::arg("path"))
         .def("stroke_path", [](BLContext &self, const BLPath &path)
              { self.strokePath(path); }, nb::arg("path"))
         .def("fill_text", [](BLContext &self, const BLPoint &pt, const BLFont &font, const std::string &text)
              { self.fillUtf8Text(pt, font, text.c_str(), text.size()); }, nb::arg("pt"), nb::arg("font"), nb::arg("text"))
         .def("stroke_text", [](BLContext &self, const BLPoint &pt, const BLFont &font, const std::string &text)
              { self.strokeUtf8Text(pt, font, text.c_str(), text.size()); }, nb::arg("pt"), nb::arg("font"), nb::arg("text"))
         .def("blit_image", [](BLContext &self, const BLPoint &pt, const BLImage &image)
              { self.blitImage(pt, image); }, nb::arg("pt"), nb::arg("image"))
         .def("blit_image", [](BLContext &self, const BLPoint &pt, const BLImage &image, const BLRectI &area)
              { self.blitImage(pt, image, area); }, nb::arg("pt"), nb::arg("image"), nb::arg("area"))
         .def("blit_image", [](BLContext &self, const BLRect &rect, const BLImage &image)
              { self.blitImage(rect, image); }, nb::arg("rect"), nb::arg("image"))
         .def("blit_image", [](BLContext &self, const BLRect &rect, const BLImage &image, const BLRectI &area)
              { self.blitImage(rect, image, area); }, nb::arg("rect"), nb::arg("image"), nb::arg("area"));
}