# Training your own DeepSqueak Network
**links to dsqueak stuff**

This is a short guide intended to walk someone through the process of training a tailored DeepSqueak network, specialized at identifying USVs in whatever unique soundscape you're trying to analyze. This guide also has the dual purpose of documenting how I trained my own network for use in the Hillman Lab at the University of Otago.

## Getting Started
For the purposes of demonstration; I'll be using the HillmanLab_Gen1 network I've already made; which should all already be contained in ```S:\Kristin Hillman\LAB\Lab members\Josh\deepsqueak```; and the sample audio files I'll be looking at are in ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotWAV```. 

First; we'll be looking inside the main deepsqueak folder, and opening up *DeepSqueak.m*. We won't need to be doing any serious coding in here, we're just going straight to the Command Window and entering: ```DeepSqueak```, which should give us a screen something like this:

**img1**

We'll first need to make sure we've got all the folder set up, so we'll be going to to the menu to se----

**selected network folder 2 & 3**

Next is selecting ```File > Select Audio Folder```; in which we'll be picking whatever folder our raw audio files are in, so mine in this case are in *sourceData/pilotWAV*. When we select the folder, it'll update our Audio Files list similarly. Then we're going to do the same for ```File > Select Detection Folder```; Except this time we're making a new folder somewhere to put our first training outputs, which I'm going to name *Date-BaselineHybrid_Recall*, which I'll explain shortly.

## Creating a Baseline Sample

For us to be able to actually train out network, we're going to need to create some sample data for DeepSqueak to use for training; which we'll do by using DeepSqueak's default network to ---

Start by going to the top-right and ***first*** changing the sensitivity of the baseline networks, on the little slider they have: 

**img5**

We're going with ```High Recall``` here (which is why I added the "_Recall_" suffix to the folder name), because we want the most generalisable sample we can get. This means we want to be as sure as possible that our sample includes even the most faint looking USVs. If you're curious, I also took to trying all three of the different settings on this slider, which are viewable in the folders ```S:\Kristin Hillman\LAB\Lab members\Josh\deepsqueak\Detections\31Jan-BaselineHybrid_Middle``` and ```...\31Jan-BaselineHybrid_Precision```: 

**img6**

By opening up any of these folders using ```File > Select Detection Folder```, and loading the different Detected Call Files (on the middle-right of the DeepSqueak window), you can compare and see how sensitive each of these different settings were, despite all being used on the same network. For reference; here's a table that shows the number of calls detected by each sensitivity in each file:

**img7**

While it seems like the more precise network here would make more sense, I've tried to demonstrate here that an untuned "precise" network is actually just going to prune off real calls. The two bracketed numbers on the table represent two files I went through and manually counted how many "real" calls were in the file. While intuitively one might think that the Precise network with 1461 Calls would have found all 1264 of the Recall network's *"true"* calls, actually it cut off many of the true calls as well, leaving us with only 824. 

So because we want the most generalizeable sample, we want to go with the sensitivity that will give us the most "true" calls; ```Recall```. And from there, we're going with ```Multi Detect```. From the window that shows up there, you can select multiple source files from the Audio folder, using the ```Shift``` or ```Ctrl``` keys while clicking on multiple filenames; or just the **Select All** button:

**img8**

After hitting ```Ok```, the next window allows us to select networks to use as a baseline. You can select up to **TWO** (this limit isn't made clear anywhere in the interface), in the same way that you could select multiple audio files just before. While we're intent on creating only a single network for ourselves, for now we want to select the best one (or combination) of the existing networks that suits our audio files, so I went with two: ```Short Rat Call_Network_V2.mat``` & ```Long Rat Call Network_V2.mat```. This is with the aim of getting the most general set of USVs for our sample, both short AND long calls.

**img9**

On the following screen, we can select a few more options regarding our audio files:
- **Total Analysis Length**: How many seconds of each video to scan through; I want the whole clip so I choose ```0```.
- **Analysis Chunk Length**: This allows us to have the network analyse larger chunks at once, but for now we'll stick with the default.
- **Overlap**: How much overlap is between each chunk, go with about the length of the longest call you're expecting, ```1``` is fine here.
- **Frequency Cut Offs**: The upper and lower bounds of the frequency range for your audio files, I just stick with defaults.
- **Score Threshold**: If we wanted to tigten things up to make sure we only get calls when the network is really sure it's a call (giving it a higher score), we could set a custom value, but since we're denoising later anyway, we'd still prefer to minimize **False Negatives** for now.
- **Append Date to Filename**: Because my audio files already have a nice naming convention, I'm going with No; ```0```.

**img10**

After that, you'll be processing for a while. Depending on the computer you're using, how many files you're analyzing, what settings you selected; this could take minutes or hours. On a computer with a Nvidia 1050Ti 4GB, doing the single file I'm using in this example took about 10 minutes. As files complete, you'll see the number of calls detected show up in the Matlab Command Window, like ```2921 Calls found in: filename ```. You'll also notice after all the files are finished processing, your selected Detection folder will now have files in it; and the Detected Call Files list will have things in it now.

## Trimming our Sample Set
