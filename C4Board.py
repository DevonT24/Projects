#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 01:24:57 2019

@author: DTroester
"""

# e = empty, r = red, b = black
# grid[y][x]

class Board:
    
    #Grid is created
    height = 6
    width = 7
    count = 0 #counts number of valid moves made to check for tie
    grid = ['e'] * height
    for i in range(height):
        grid[i] = ['e']*width
    lastdrop = [0,0,'r']
    
    def reset(self):
        self.grid = ['e'] * self.height
        for i in range(self.height):
            self.grid[i] = ['e']*self.width
        self.lastdrop = [0,0,'r']
        self.count = 0
    
    def drop(self,column,player):
        for i in range(self.height):
            if self.grid[i][column] == 'e':
                self.grid[i][column] = player
                self.lastdrop = [i,column,player]
                self.printBoard(self)
                self.count += 1
                return self.checkWin(self)
        return 'f'
    
    def printBoard(self):
        #for i in range(self.height):
            #print(self.grid[self.height-i-1])
        #print()
        pass
    
    def checkWin(self): #Also checks for tie
        
        #Sets up necessary variables
        width = self.width
        height = self.height
        player = self.lastdrop[2]
        lastx = self.lastdrop[1]
        lasty = self.lastdrop[0]
        count = 1
        
        #Checks for a win along the row
        if lastx + 1 != width and self.grid[lasty][lastx+1] == player:
            count += 1
            if lastx + 2 != width and self.grid[lasty][lastx+2] == player:
                count += 1
                if lastx + 3 != width and self.grid[lasty][lastx+3] == player:
                    self.victory(self)
                    return 'v'
        if lastx - 1 != -1 and self.grid[lasty][lastx-1] == player:
            count += 1
            if lastx - 2 != -1 and self.grid[lasty][lastx-2] == player:
                count += 1
                if lastx - 3 != -1 and self.grid[lasty][lastx-3] == player:
                    self.victory(self)
                    return 'v'
        if count >= 4:
            self.victory(self)
            return 'v'
        
        #Resets count to check new direction
        count = 1  
        
        #Checks for a win along the column
        if lasty >= 3:
            if self.grid[lasty-1][lastx] == player:
                if self.grid[lasty-2][lastx] == player:
                    if self.grid[lasty-3][lastx] == player:
                        self.victory(self)
                        return 'v'
        
        #No count reset necessary as count isn't needed for column check
        
        #Checks for a win along the diagonal y = x
        if lastx + 1 != width and lasty + 1 != height and self.grid[lasty+1][lastx+1] == player:
            count += 1
            if lastx + 2 != width and lasty + 2 != height and self.grid[lasty+2][lastx+2] == player:
                count += 1
                if lastx + 3 != width and lasty + 3 != height and self.grid[lasty+3][lastx+3] == player:
                    self.victory(self)
                    return 'v'
        if lastx - 1 != -1 and lasty - 1 != -1 and self.grid[lasty-1][lastx-1] == player:
            count += 1
            if lastx - 2 != -1 and lasty - 2 != -1 and self.grid[lasty-2][lastx-2] == player:
                count += 1
                if lastx - 3 != -1 and lasty - 3 != -1 and self.grid[lasty-3][lastx-3] == player:
                    self.victory(self)
                    return 'v'
        if count >= 4:
            self.victory(self)
            return 'v'
        
        #Resets count to check new direction
        count = 1
        
        #Checks for a win along the diagonal y = -x
        if lastx - 1 != -1 and lasty + 1 != height and self.grid[lasty+1][lastx-1] == player:
            count += 1
            if lastx - 2 != -1 and lasty + 2 != height and self.grid[lasty+2][lastx-2] == player:
                count += 1
                if lastx - 3 != -1 and lasty + 3 != height and self.grid[lasty+3][lastx-3] == player:
                    self.victory(self)
                    return 'v'
        if lastx + 1 != width and lasty - 1 != -1 and self.grid[lasty-1][lastx+1] == player:
            count += 1
            if lastx + 2 != width and lasty - 2 != -1 and self.grid[lasty-2][lastx+2] == player:
                count += 1
                if lastx + 3 != width and lasty - 3 != -1 and self.grid[lasty-3][lastx+3] == player:
                    self.victory(self)
                    return 'v'
        if count >= 4:
            self.victory(self)
            return 'v'
        
        if self.count == (width * height) :
            self.tie(self)
            return 't'
        return 's'
    
    def victory(self):
        #print("Congratulations player {}".format(self.lastdrop[2]))
        pass
    
    def tie(self):
        #print("It's a tie.")
        pass
        