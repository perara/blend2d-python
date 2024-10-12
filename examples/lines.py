import blend2d
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import hsv_to_rgb

if __name__ == "__main__":
    array = np.empty((500, 500, 4), dtype=np.uint8)
    image = blend2d.Image(array)
    canvas = blend2d.Context(image)

    canvas.clear_all()
    canvas.set_stroke_width(20.0)

    path = blend2d.Path()
    path.move_to(100, 0)
    path.quadric_to(125, 25, 250, 0)
    path.quadric_to(375, -25, 400, 0)

    caps = {
        blend2d.StrokeCap.CAP_BUTT,
        blend2d.StrokeCap.CAP_SQUARE,
        blend2d.StrokeCap.CAP_ROUND,
        blend2d.StrokeCap.CAP_ROUND_REV,
        blend2d.StrokeCap.CAP_TRIANGLE,
        blend2d.StrokeCap.CAP_TRIANGLE_REV,
    }

    for i, cap in enumerate(caps):
        with canvas:
            color = hsv_to_rgb([[i / len(caps), 0.75, 0.75]])[0]
            canvas.set_stroke_style(color)
            canvas.set_stroke_caps(cap)
            canvas.translate(0, (i + 1) * 75)
            canvas.stroke_path(path)

    plt.imshow(array)
