#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct  2 16:27:10 2019

@author: DTroester
"""

import C4Board
import random as rng

class Player():
    
    height = 6
    width = 7
    
    color = 'e'
    ID = 0
    
    def __init__(self,color,ID):
        self.color = color
        self.ID = ID
    
    def assignColor(self,color):
        self.color = color
    
    def ping_User(self,board):
        if self.color == 'r':
            column = int(input("Red's Turn: input a column between 1 and 7: ")) - 1
        else:
            column = int(input("Black's Turn: input a column between 1 and 7: ")) - 1
        return board.drop(board,column,self.color)
    
    def ping_RNG(self,board):
        column = rng.randrange(self.width)
        return board.drop(board,column,self.color)