# utilities
Some useful code snips I've made while working in the lab, working with some rat neural data

## proximityFlag
Goes through any provided array of n coordinates, and uses internal variables to detect the distance between each array coordinate and the location variable; Marking the frame. Returns a size n array, containing both a raw distance & either a 0 or 1, indicating being within proximity on a 1.
 - Future update to move internal variables to be full parameters

## pullVT1
Because Neuralynx always dumps videos and all the other files it creates inside a variety of nested (but timestamped!) folders; but they always name the video VT1.mpg, so this tiny script can sit at any root directory, and will scan through all subdirectories and scan for the VT1.mpg file, and will copy it to a \_data directory in the root. It also renames the file to match the immedeate containing directory, to differentiate them effectively.
 - Future update to take filename & search path as arguments
 
## trainComparison
DeepLabCut (https://github.com/AlexEMG/DeepLabCut) has the ability to create multiple different shuffles in order to compare different augmentation and networking methods on the same training set; However one has to train each of them one-by-one; This script instead allows one to queue up multiple shuffles for back-to-back training; Providing timestamps inbetween for benchmarking purpose. Also uses colour!.
 - Future update to have config path as an argument, and expand queueable functions beyond just training.
