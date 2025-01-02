import pygame
import os
import sys
from utils import *
os.chdir(os.path.dirname(__file__))
window = pygame.display.set_mode((1500, 800))
mapfile = open("map0.csv", "r")
map = mapfile.read().split("\n")
mapfile.close()
str().isdecimal
map = [list(map[i].split(",")) for i in range(len(map))]
map = [[int(map[i][j])for j in range(len(map[i]))] for i in range(len(map))]

pygame.font.init()
font = pygame.font.Font(None, 30)
pygame.init()

selected_tile = None
buttons = []

def save():
    #process map for lua mod
    tunefile = open("main.lua", "w")
    tunefile.write(luatemplate1)
    for i, row in enumerate(map):
        tunefile.write(f"[{i}] ={"{"}")
        for value in row:
            tunefile.write(f"{value},")
        tunefile.write("},\n")
    metainfofile = open("map0_meta.csv", "r")
    metainfo = metainfofile.read().split("\n")
    metainfofile.close()
    metainfo = [i.split(",") for i in metainfo]
    tunefile.write("['inputs'] = {")
    tunefile.write(metainfo[0][0]+","+metainfo[0][1]+"},")
    tunefile.write("['outputs'] = {")
    tunefile.write(metainfo[0][2]+"},")
    tunefile.write("['scales'] = {")
    tunefile.write(metainfo[0][3]+","+metainfo[0][4]+","+metainfo[0][5]+"},")
    tunefile.write(midportion)
    tunefile.write(f"['size'] = {{{len(map[0])}, {len(map)}}}")
    tunefile.write(tailend)
    tunefile.close()
    #process map out to csv
    mapfile = open("map0.csv", "w")
    for y,row in enumerate(map):
        for i,value in enumerate(row):
            mapfile.write(str(value)+("," if not i == len(row)-1 else ""))
        if not y == len(map)-1:
            mapfile.write("\n")
    mapfile.close()
"""
['inputs'] = {
['outputs'] = {
['scales'] = {
"""
buttons.append(button(1200, 100, 100, 50, "Save", (0, 255, 0), save))



while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.MOUSEBUTTONUP:
            x = event.pos[0] // tile_size
            y = event.pos[1] // tile_size
            if x < len(map[0]) and y < len(map):
                selected_tile = (x, y)
            for button in buttons:
                if button.is_over(event.pos):
                    button.function()

        elif event.type == pygame.KEYDOWN:
            #if the key is a number and we have a selected tile, append the number to the value of the tile
            if event.unicode.isdigit() and selected_tile:
                map[selected_tile[1]][selected_tile[0]] = map[selected_tile[1]][selected_tile[0]] * 10 + int(event.unicode)
            if event.key == pygame.K_BACKSPACE and selected_tile:
                map[selected_tile[1]][selected_tile[0]] = map[selected_tile[1]][selected_tile[0]] // 10
    window.fill((0, 0, 0))
    average_tile_value = sum([sum(i) for i in map]) / (len(map) * len(map[0]))
    for button in buttons:
        button.draw(window)
        if button.is_over(pygame.mouse.get_pos()):
            button.color = (255, 0, 0)
        else:
            button.color = (0, 255, 0)
    tile_size = 50
    min_value = min(min(row) for row in map)
    max_value = max(max(row) for row in map)

    for y in range(len(map)):
        for x in range(len(map[y])):
            distance = map[y][x]
            color = interpolate_color(distance, min_value, max_value)
            #draw the value of the tile on the tile
            text = font.render(str(distance), True, (0, 0, 0))
            pygame.draw.rect(window, color, (x * tile_size, y * tile_size, tile_size, tile_size))
            window.blit(text, (x * tile_size, y * tile_size))
    #draw a hollow box with edgewidth 5 around the selected tile
    if selected_tile:
        pygame.draw.rect(window, (0, 0, 255), (selected_tile[0] * tile_size, selected_tile[1] * tile_size, tile_size, tile_size), 5)
    pygame.display.flip()