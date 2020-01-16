# utilities
Some useful code snips I've made while working in the lab, working with some rat neural data

## proximityFlag
Goes through any provided array of n coordinates, and uses internal variables to detect the distance between each array coordinate and the location variable; Marking the frame. Returns a size n array, containing both a raw distance & either a 0 or 1, indicating being within proximity on a 1.
 - Future update to move internal variables to be full parameters.

## fileFisher (1.2)
Batch Utility for searching complex directory structures, and pulling files matching name criteria into a single organised location.
 - Updated to have multiple options for renaming format.
 
## trainComparison
DeepLabCut (https://github.com/AlexEMG/DeepLabCut) has the ability to create multiple different shuffles in order to compare different augmentation and networking methods on the same training set; However one has to train each of them one-by-one; This script instead allows one to queue up multiple shuffles for back-to-back training; Providing timestamps inbetween for benchmarking purpose. Also uses colour!.
 - Future update to have config path as an argument, and expand queueable functions beyond just training.
