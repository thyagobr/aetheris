#! /usr/bin/env python

import pygame, sys, os
from pygame.locals import *

pygame.init()

class Main():
    
    # Defining constants
    FPS = 60
    WINDOW_WIDTH = 640 # ToDo: verify which multiplier Notch uses
    WINDOW_HEIGHT = 480
    SCREEN_FLAGS = HWSURFACE|DOUBLEBUF

    # Starting variables and checking devices
    def __init__(self):
        # Starting pygame
        self.screen = pygame.display.set_mode((self.WINDOW_WIDTH, self.WINDOW_HEIGHT),
                self.SCREEN_FLAGS)
        self.screen = pygame.display.get_surface()
        pygame.display.set_caption("Aetheris")
        self.clock = pygame.time.Clock()

        # Setting up root directory
        root_dir = os.path.dirname(__file__)

        # Example: how to set up a directory based on root dir
        floor_tile = os.path.join(root_dir, 'wooden_floor32.png')

        # Loading images
        try:
            player = pygame.image.load('crisiscorepeeps.png')
            self.level_surface = pygame.image.load(floor_tile)
            church_bench = pygame.image.load('church_bench.png')
            church_bench_diagonal = pygame.image.load('church_bench_diagonal_mid.png')
            church_bench_diag_leftop= pygame.image.load('church_bench_diag_leftop.png')
        except pygame.error, message:
            print 'Erro'
            raise SystemExit, message

        print "Level Tile: ", self.level_surface

        # Setting up player's initial position
        player_x, player_y = 320, 450
        # Setting up movement vector
        movement = [0, 0]

        # Setting up first dummy level: 20x15
        self.level = [
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
                    if event.key == 275:
                        movement[0] = 0
                    if event.key == 276:
                        movement[0] = 0
                    if event.key == 273:
                        movement[1] = 0
                    if event.key == 274:
                        movement[1] = 0
        
            for y in range(len(self.level)):
                for x in range(len(self.level[y])):
                    if self.level[y][x] == 1:
                        self.screen.blit(self.level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
                    elif self.level[y][x] == 2:
                        self.screen.blit(church_bench, ((32 * x), (32 * y)), (0, 0, 640, 480))
                    elif self.level[y][x] == 3:
                        self.screen.blit(self.level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
                        self.screen.blit(church_bench_diagonal, ((32 * x), (32 * y)), (0, 0, 640, 480))
                    elif self.level[y][x] == 4:
                        self.screen.blit(self.level_surface, ((32 * x), (32 * y)), (0, 0, 640, 480))
                        self.screen.blit(church_bench_diag_leftop, ((32 * x), (32 * y)), (0, 0, 640, 480))
        
        
            player_pos = player_x + movement[0], player_y + movement[1]
            # print "Current Tile: ", player_pos[0] / 32, player_pos[1] / 32
            # problem: it has to be rectangles; its only calculating top-left point
            if (self.level[player_pos[1] / 32][player_pos[0] /32]) == 1:
                player_x, player_y = player_pos
            self.screen.blit(player, player_pos, (0, 0, 32, 32))


            pygame.display.update()
            self.clock.tick(self.FPS)

if __name__ == '__main__':
    Main()
