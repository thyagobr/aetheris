#! /usr/bin/env python

import pygame, sys, os, random
from pygame.locals import *
from random import *

# Initialize modules
pygame.init()

screen = pygame.display.set_mode((640, 480), HWSURFACE|DOUBLEBUF)
pygame.display.set_caption("Aetheris")
screen = pygame.display.get_surface()
clock = pygame.time.Clock()

root_dir = os.path.dirname(__file__)

level_x = 0
level_y = 0
radius = 1
circles = []
rand = Random()
pos_x, pos_y = (0, 0)

for i in xrange(20):
        circles.append([((i * 10)), ((rand.randrange(1, 10+1) *
            10))])

while True:

    if (radius % 10) == 0:
        radius = 1
    else:
        radius += 1

    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == MOUSEMOTION:
            pos_x, pos_y = event.pos

    screen.fill((255, 255, 255))
    for circle in circles:
        rand_radius = radius * rand.randrange(1, 3+1)
        pygame.draw.circle(screen, (255, 0, 0), (pos_x + circle[0], pos_y + circle[1]),
               rand_radius, rand_radius / 9)

    pygame.time.wait(100)
    pygame.display.update()
    clock.tick(30)
