#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 00:53:37 2019

@author: DTroester
"""

import C4Board
import C4Player

class Runner:
    
    def main():
        board = C4Board.Board
        
        p1 = C4Player.Player('b',0)
        p2 = C4Player.Player('r',1)
        p1.assignColor('r')
        p2.assignColor('b')
        x = 'e'
        while 1 == 1:
            while 1 == 1:
                x = p1.ping_RNG(board)
                if x == 's':
                    break
                elif x == 'v':
                    result = board.lastdrop
                    board.reset(board)
                    return result
                elif x == 't':
                    board.reset(board)
                    return [-1,-1,'t']
            while 1 == 1:
                x = p2.ping_RNG(board)
                if x == 's':
                    break
                elif x == 'v':
                    result = board.lastdrop
                    board.reset(board)
                    return result
                elif x == 't':
                    board.reset(board)
                    return [-1,-1,'t']