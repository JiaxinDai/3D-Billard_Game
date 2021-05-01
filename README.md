#  ![alt text](https://github.com/JiaxinDai/GomokuAI/blob/master/Gomoku%20AI%20macOS/Resources/Assets.xcassets/AppIcon.appiconset/icon_128x128.png "GomokuAI App Icon") Gomoku AI
An AI program for Gomoku, also known as Five in a Row, a popular board game that is played on the same board as Go.

## Features Snapshot
![alt text](https://github.com/JiaxinDai/GomokuAI/blob/master/Gomoku%20AI%20macOS/Resources/Screenshots/all-features.png "Features Snapshot")

## Algorithms & Data Structures Overview
- Heuristic Evaluation
- Threat Space Search
    - Minimax w/ Alpha-beta Pruning 
        - ZeroMax - an attempt to overcome horizon effect
        - NegaScout (Principal Variation Search)
    - Monte Carlo Tree Search

## Self-Play
In order to figure out the optimal weight assignment for each threat type, Gomoku AI plays against itself. This is currently a work in progress, but starting with zero knowlege about the game except the rules, the algorithm is able to converge toward a reasonable weight assignment given enough time. 

To spawn a customized looped skirmish, use the **GomokuAI Console**. The short-cut for opening the console is `⌃⇧C` (Control-Shift-C). Make sure that `Looped` is checked. You can optionally save the skirmishes to a designated location. To generate stats from saved skirmishes, click `Generate Stats`. 
![alt text](https://github.com/JiaxinDai/GomokuAI/blob/master/Gomoku%20AI%20macOS/Resources/Screenshots/console.png "Console Screenshot")

The following .gif shows a looped play of two heuristic AIs happening in real time:
![alt text](https://github.com/JiaxinDai/GomokuAI/blob/master/Gomoku%20AI%20macOS/Resources/Screenshots/self-play.gif)

Another cool feature is the visualization of the AI. The visualization offers a peek into the inner-workings of the algorithm (i.e. what it is doing, either updating the active map or performing simulations) in real time. To enable visualization, make sure the check box is checked in the console. (Alternatively, use the short cut `⌃⌥A` (Control-Option-A)).


