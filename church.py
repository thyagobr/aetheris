#! /usr/bin/env python

import pygame, sys, os
from pygame.locals import *

# Initialize modules
pygame.init()

screen = pygame.display.set_mode((640, 480), HWSURFACE|DOUBLEBUF)
pygame.display.set_caption("Aetheris")
screen = pygame.display.get_surface()
clock = pygame.time.Clock()

root_dir = os.path.dirname(__file__)
floor_tile = os.path.join(root_dir, 'wooden_floor32.png')
# church_bench = os.path.join(root_dir, 'church_bench.png')
try:
    player = pygame.image.load('crisiscorepeeps.png')
    level_surface = pygame.image.load(floor_tile)
    church_bench = pygame.image.load('church_bench.png')
    church_bench_diagonal = pygame.image.load('church_bench_diagonal_mid.png')
    church_bench_diag_leftop= pygame.image.load('church_bench_diag_leftop.png')
except pygame.error, message:
    print 'Erro'
    raise SystemExit, message
player_x = 320
player_y = 450
movement = [0, 0]
radius = 0

level = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 3, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        ]

while True:
    if radius > 20:
        radius = 0
    else:
        radius += 1

    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == KEYDOWN:
            if pygame.key.get_pressed()[K_RIGHT]:
                movement[0] = 3
            if pygame.key.get_pressed()[K_LEFT]:
                movement[0] = -3
            if pygame.key.get_pressed()[K_UP]:
                movement[1] = -3
            if pygame.key.get_pressed()[K_DOWN]:
                movement[1] = 3
        elif event.type == KEYUP:
            print event.key
            if event.key == 275:
                movement[0] = 0
            if event.key == 276:
                movement[0] = 0
            if event.key == 273:
                movement[1] = 0
            if event.key == 274:
                movement[1] = 0

    for y in range(len(level)):
        for x in range(len(level[y])):
            if level[y][x] == 1:
                screen.blit(level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
            elif level[y][x] == 2:
                screen.blit(church_bench, ((32 * x), (32 * y)), (0, 0, 640, 480))
            elif level[y][x] == 3:
                screen.blit(level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
                screen.blit(church_bench_diagonal, ((32 * x), (32 * y)), (0, 0, 640, 480))
            elif level[y][x] == 4:
                screen.blit(level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
                screen.blit(church_bench_diag_leftop, ((32 * x), (32 * y)), (0, 0, 640, 480))


    player_pos = player_x + movement[0], player_y + movement[1]
    player_x, player_y = player_pos
    screen.blit(player, player_pos, (0, 0, 32, 32))


    pygame.display.update()
    clock.tick(30)
