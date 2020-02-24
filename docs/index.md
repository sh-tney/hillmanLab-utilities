## Using your DeepSqueak Network
**links to deepsqueak page**

This is a short guide intended to walk someone through the process of using a DeepSqueak network (which has already been prepared) to analyze new sound clips. To see how to train your own custom network, see ***link***.

### Opening things up
For the purposes of demonstration; I'll be using the HillmanLab_Gen1 network I've already made; which should all already be contained in *S:\Kristin Hillman\LAB\Lab members\Josh\deepsqueak*; and the sample audio files I'll be looking at are in *S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotWAV*. 

First; we'll be looking inside the main deepsqueak folder, and opening up *DeepSqueak.m*. We won't need to be doing any serious coding in here, we're just going straight to the Command Window and entering: ```DeepSqueak```, which should give us a screen something like this:

**img1**

Don't worry too much if the image in the middle or anything else doesn't match; as long as the window shows up. Now we have to set up our folders. Go to menu at the top left; and select ```File > Select Network Folder```. We're going to be navigating to wherever your premade network is stored; I've stored mine conveniently in the default *deepsqueak/Networks* folder along with the default networks. Select the folder, and we'll see our Neural Networks list in the top-right updated with the contents of the folder: 

**img2 & img3**

Next is selecting ```File > Select Audio Folder```; in which we'll be picking whatever folder our raw audio files are in, so mine in this case are in *sourceData/pilotWAV*. When we select the folder, it'll update our Audio Files list similarly. Then we're going to do the same for ```File > Select Detection Folder```; Except this time we're going to make a new folder, which is where all of our analyzed output files are going to go. Personally I wouldn't reccomend dumping all of these in a single folder, organize them a bit and come up with some naming conventions. I'm going to make a new folder and use that:

**img4**

Note that there won't be anything in our Detected Call Files list yet.

### First Detection Sequence

Depending on the type of network you're using; and how sensitive it might be, you'll be setting the precision/recall slider differently; For the HillmanLab_Gen1 network I suggest High Recall. I also reccomend this in general for the first part, as we'll be using a denoiser later anyway, so at this stage we're looking to minimize the number of **False Negatives** we have. Treating each stage of this analysis as a seive, we'd rather be generous with accepting things that are *probably* USVs, and filter out the True Negatives later; rather than try and be oversensitive when trying to pick up calls and missing out many True Positives which we can't get back during denoising.

So now, **before starting detection** we have to select the sensistivty on this little slider bar:

**img5**

It's a little unintuitively placed here and not somewhere in the menus later on in the process, but that's what we have to work with. There's only three settings: High Precision, High Recall, and Middle. We're going with High Recall.

From here we can choose to either ```Detect Calls```, which has some more advanced options for analysing a single file, which may be worth exploring seperately. But for mass data analysis of many files, we're going with ```Multi Detect```
