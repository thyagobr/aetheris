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
level_1 = os.path.join(root_dir, 'level_1.bmp')
try:
    level_surface = pygame.image.load(level_1).convert()
except pygame.error, message:
    print 'Erro'
    raise SystemExit, message
level_x = 0
level_y = 0
radius = 0

while 1:
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
                level_x += 20
            elif pygame.key.get_pressed()[K_LEFT]:
                level_x -= 20
            elif pygame.key.get_pressed()[K_UP]:
                level_y -= 20
            elif pygame.key.get_pressed()[K_DOWN]:
                level_y += 20

    screen.blit(level_surface, (0,0), (level_x, level_y, 640, 480))
    # pygame.draw.rect(screen, (0, 255, 0), (100, 50, 20, 20))
    pygame.draw.circle(screen, (0 ,32, 240), (20, 200), radius, 0)
    pygame.display.flip()
    clock.tick(60)
