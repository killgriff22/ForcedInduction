import pygame
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


class button:
    def __init__(self, x, y, width, height, text, color, function):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.text = text
        self.color = color
        self.function = function

    def draw(self, window):
        pygame.draw.rect(window, self.color, (self.x, self.y, self.width, self.height))
        font = pygame.font.Font(None, 30)
        text = font.render(self.text, True, (0, 0, 0))
        window.blit(text, (self.x + self.width // 2 - text.get_width() // 2, self.y + self.height // 2 - text.get_height() // 2))

    def is_over(self, pos):
        if pos[0] > self.x and pos[0] < self.x + self.width:
            if pos[1] > self.y and pos[1] < self.y + self.height:
                return True
        return False