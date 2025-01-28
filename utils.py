from templates import *
def interpolate_color(value, min_value, max_value):
    # Normalize the value to be between 0 and 1
    normalized = (value - min_value) / (max_value - min_value)
    # Interpolate between green (0, 255, 0), yellow (255, 255, 0), and red (255, 0, 0)
    if normalized < 0.5:
        # Interpolate between green and yellow
        r = int(255 * (normalized * 2))
        g = 255
        b = 0
    else:
        # Interpolate between yellow and red
        r = 255
        g = int(255 * (1 - (normalized - 0.5) * 2))
        b = 0
    return (r, g, b)

def rgb_to_hex(rgb):
    return '#%02x%02x%02x' % rgb