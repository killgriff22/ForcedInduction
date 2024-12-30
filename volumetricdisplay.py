from pygame.locals import *
import pygame
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

TILESIZE = 50
MAPWIDTH =  5
MAPHEIGHT = 5

isometric_tiles = {}

tile_surf = pygame.Surface((TILESIZE, TILESIZE), pygame.SRCALPHA)
color = (0,0,0)
tile_surf.fill(color)
tile_surf = pygame.transform.rotate(tile_surf, 45)
isometric_size = tile_surf.get_width()
tile_surf = pygame.transform.scale(tile_surf, (isometric_size, isometric_size//2))

pygame.init()
DISPLAYMAP = pygame.display.set_mode((MAPWIDTH*TILESIZE*2,MAPHEIGHT*TILESIZE))

while True:
    f = open("heightmap.py", "r")
    try:
        tilemap = eval(f.read())
    except:
        tilemap = [
                [10,15,25,30,35],
                [40,45,50,55,60],
                [65,70,75,80,95],
                [100,105,110,115,120],
                [125,130,135,140,145]
        ]
    f.close()
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()

        DISPLAYMAP.fill((0, 0, 0))
        average_height = int(sum([sum(row) for row in tilemap]) / (MAPWIDTH * MAPHEIGHT))
        for column in range(MAPWIDTH):
            for row in range(MAPHEIGHT):
                x = (column + (MAPHEIGHT - row)) * isometric_size // 2
                y = 20 + (column + row) * isometric_size // 4 
                color = (0,0,255)
                clr = int(tilemap[row][column]//average_height )* 90
                if clr > 255:
                    clr = 255
                if tilemap[row][column] in range(average_height - 5, average_height + 5):
                    color = (clr, clr, 0)
                elif tilemap[row][column] > average_height:
                    color = (clr, 0, 0)
                elif tilemap[row][column] < average_height:
                    color = (0, clr, 0)
                tile_surf.fill(color)
                DISPLAYMAP.blit(tile_surf, (x, y))
        
    pygame.display.update()