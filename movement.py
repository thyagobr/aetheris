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
try:
    char_still = pygame.image.load('char1.png')
    char_right = pygame.image.load('char2.png')
except pygame.error, message:
    print 'Erro'
    raise SystemExit, message

character = char_still
char_x, char_y = 0, 0

while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == KEYDOWN:
            print "down!"
            if pygame.key.get_pressed()[K_RIGHT] and (char_x + 20) <= 1220:
                char_x += 20
                character = char_right
            elif pygame.key.get_pressed()[K_LEFT] and (char_x - 20) >= 0:
                char_x -= 20
            elif pygame.key.get_pressed()[K_UP]:
                char_y -= 20
            elif pygame.key.get_pressed()[K_DOWN]:
                char_y += 20

    screen.fill((255, 255, 255))
    screen.blit(character, (char_x, char_y, 640, 480))
    character = char_still
    pygame.display.update()
    clock.tick(31)
