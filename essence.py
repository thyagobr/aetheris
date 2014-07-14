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

for i in xrange(20):
        circles.append([(200 + (i * 5)), 300])

while True:

    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == MOUSEMOTION:
            print "Mouse: ", event.pos

    screen.fill((255, 255, 255))
    for circle in circles:
        if circle[1] <= 200:
            circle[1] = 300
        else:
            circle[1] -= 1

        pygame.draw.circle(screen, (0, 255, 0), (circle[0], circle[1]), 1)

    pygame.display.update()
    clock.tick(30)
