---
title: Training your own DeepLabCut network
layout: template
filename: dlctrain.md
--- 

# Training your own DeepLabCut network

**links to dlc page**

This is a short guide intended to walk someone through the process of training a new DeepLabCut network to analyze video files. This guide also has the dual purpose of documenting how I trained my own network for use in the Hillman Lab at the University of Otago. For the purposes of this guide, I'll be referring to the network stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut```, and the sample videos stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```. Also worth noting here is that sometimes DLC seems to have issues with using network drives due to permissions and such; So while I'm showing this being used on the network drive for demonstration purposes, I'd reccomend doing most things on your local C:/ drive.

## Getting Started

First we actually need to have an environment that supports DeepLabCut installed. If you've already got this installed, skip ahead to *Opening Things Up*. As much as I'd like to have a 100% comprehensive guide of the installation process, this is somewhat variable based on the actual computer you use; and the DeepLabCut Documentation already covers this in detail ***here***. However for Documentation purposes, I've included the basic outline of the steps (which I followed from them) here, for our lab computer that has a NVIDIA GeForce 1050Ti GPU:
- Install Anaconda ***here***
- Install CUDA ***here***
- Install GPU Drivers ***here***
- Downloaded the *dlc-windowsGPU.yaml* from the DeepLabCut list ***here***
- Open the Anaconda Navigator
- Open the Anaconda Terminal from base(root) and navigate to the *dlc-windowsGPU.yaml*
- ```conda env create -f dlc-windowsGPU.yaml```

## Opening Things Up

First of all, let's open up the Anaconda Prompt as an Administrator. If not sure where to do this, we can search for it in the Start Menu and **right-click** on it, selecting ```Run as Administrator```:

**img1**

 - Alternatively to this, click ```Open File Location``` from the right-click menu; In the new explorer window, **right-click** the Anaconda Prompt (***not*** Powershell Verision), and select ```Properties```. Inside the Properties window, open ```Advanced```, and tick the *Run as Administrator* option, and click *OK* to save. This means that in the future, Anaconda Prompt will open as Administrator by default.
 
 **img2**
 
 Now inside the Anaconda Prompt window we want to enter the following codes, hitting ```Enter``` after each line:
 - ```activate *dlc-windowsGPU*``` - This just puts us in the DeepLabCut environment we already set up
 - ```ipython``` - This puts us in a version of the terminal that recognises Python script
 - ```import deeplabcut``` - Pulls deeplabcut from the online repository
 - ```deeplabcut.launch_dlc()``` - Opens up the DLC user interface
 
 **img3**
 
 We should now be greeted with the following screen:
 
 **img4**
 
 ## Creating a Sample
 
 Because we're going straight from scratch, we're going to open up the ```Manage Project``` tab, and fill out the following fields:
  - **Create new project** (obviously)
  - **Name of project**: This will be added on to all the filenames we ever analyze, something short and meaningful
  - **Name of experimenter**: Not actually neccesary; and will be added on to many of our files as well.
  - **Choose the videos**: The ```Load Videos``` button here will open up a dialog where we can navigate to whatever our source folder is, and select all the videos we want to use in our sample. In the original network I made, I used the entire set of *SocialPilot* videos (in ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```), but for this guide I'll just be using a single video. Select multiple videos at once either by dragging over them, or using ```Shift```/```Ctrl```. You'll be able to come back and add more if you want later. If you make a mistake and select a video you don't want after loading them already; you'll have to hit the ```Reset``` button.
  - **Select the directory where project will be created**: Straightforward enough, open the dialog to navigate to a folder where you want to store this network. In my case; ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut```. 
  -**Do you want to copy the videos**: Intuitively I would pick yes here, as this should create a local backup of all the videos, however in the current version this seems to be bugged and doesn't work.
  
**img5**
  
**img6**

We'll see now that in the console window, some progress updates have been displayed. If we also open up an explorer window (```Windows Key``` + ```E```), and navigate to the project directory, we'll see some stuff has been put in there:

**img7**

While we're here, let's set up our markers. Open up the *config.yaml* file in Notepad. In here, we'll see quite a few things going on, and we're here to manually edit the body parts that we want to mark (there's no other way to do this). You'll see here that there's a list called "body parts": bodypart1, 2, etc., and objectA. We want to rename these, or potentially add more. For the purposes of my video, I'm going to add some more points and rename the old ones. I have two rats in the videos; and want to mark the head, tail base, and tail tip of each. I also want to mark the physical marker on one of the rats, and the feeding well. So my points will look like this:

**img8**

We have to make sure that we preserve the formatting of the file, seperating each label with a new line, with a dash & space at the front. You might also notice a similar looking list of labels under *skeleton*, this isn't neccesary to change now, but if you're interested in displaying a skeleton on the video, the DLC documentation covers this in more detail. If you don't have many source videos, now might be a good time to increase the **numframes2pick** field to something larger as well - note this is per video. I'm leaving mine at 20. Between my 12 sample video files, this means I have 480 sample frames.

Now we'll save the config file and close it. Back in the main DLC window; that we have a few more tabs to look at, so we're moving on the the ```Extract Frames``` tab. We're going to go through the settings as follows:

**img9**

- **Select config files**: This should just be the config file in our project directory, we're just leaving this alone.
- **Choose extraction method**: Selecting automatic for now, we'll revisit manual later.
- **Need user Feedback?**: Normally I would go with *No* here, as I'd have checked the videos I wanted before this step. For demonstration purposes though, I'll select yes.
- **Use OpenCV?**: This refers to the particular method for loading the video files, and is covered more in the DLC documentation. We're going to stick with *Yes*.
- **Select Algorithm**: Either method of selecting sample frames here is fine; *uniform* just evenly spreads the chosen frames by time across the video. We're going to select *kmeans*, which clusters together frames, and then tries to pick some from every cluster to try get a more generalisable sample.
- **Specify Cluster Step**: For very long videos this can speed things up, by only reading every *x* frames to generate the sample. This isn't super neccesary for us, so we're sticking with ```1```.
- **Specify Slider Width**: This specifies the percentage of width of the window that a slider will take up in the manual extraction; So not relevant to us.
Now we hit ```OK```, and we'll see these updates in the console:

**img10**

Now because we selected *user feedback*, it'll ask us about whether we want to do each single video; which you can see it doing for the one video I have, near the top. You can type either yes or no into the terminal; obviously "yes" for each video you want to extract frames from. Don't worry about any of the invalid frames you might see either; it's not uncommon for video to have dropped a couple of frames depending on the recording method.

Now back in the main window, we can move on the ```Label Frames``` tab. Inside this tab, we're straight to ```Label Frames```, which should open up this window:

**img11**

We're going to ```Load Frames```, and in the dialog we'll see a new folder for each of the videos we chose to load. Go inside any of these, and just click ```Select Folder``` - you don't need to select any file, just the folder itself. When we select, we'll see the main window update like this, note on the right side is the list of markers we set up:

**img12**

This is where our marking starts. First, I'd reccomend hitting ```Zoom```, and drawing a box around the rat like this:

**img13**

It's not totally neccesary to do this every time, and you can reset the zoom with the ```Home Button```, but it's important that we're precise here. Now take note on the right side of which bodypart is currently selected. Select one from the list, and then back on the main image, **right-click** on the exact point, and you'll see a marker appear:

**img14**

Note that on the sidebar now, the selected bodypart will have automatically moved on to the next item on the list. This is to streamline the process of marking multiple points rapidly; But you have to be careful not to forget this and double-click or something. *If you do* make a mistake, you can always use the **middle-mouse-click** on the point again to remove it. So now, we'll go over the whole image. If the marker size is too large/small, you can tick the *Adjust marker size* and adjust it on the slider above - this change is **purely cosmetic** for the marker's benefit, and has no bearing on results.

**img15**

Before we move on to further images, it's important that we establish guidelines for how we're marking:
- Always try to mark the same place, as accurately as possible, on the animal every time. The more consistent our marking is, the stronger the associations our network forms will be; If our nosetip markers are all over the general head area, then the markers in our videos will be all over the head area (and likely other places). Ambiguity in our marking will mean more ambiguity in our output.
- No "guessing" where something is, if something isn't there, or just isn't visible due to being occluded by something else; don't mark it. Even if inuitively, we know that the rat's head is under the beam (for example) due to the general context of the video; the network doesn't know this. The network analyzes each frame independantly of the others in the output, and so trying to teach it to look for body parts that it can't see, is just us teach it to look for things where they aren't. This will lead to random markers showing up all over the place. 
- When marking multiple animals (like I am), stay consistent with which animal's markers are which. In my case, the rat with the marker on it's back is always rat B. Somewhat counterinuitively to the last point, even which the "markerB" mark on the rat's back isn't visible, I still mark the rat as rat B (rather than rat A, which the missing markerB would indicate). This is because the network can also use other cues from the frame to figure out which rat is which, for example each of the rats in my videos have a different coloured mark on their tail, red on A & blue on B. So even if the "markerB" isn't visible, the network can infer that information from other cues in the same frame.
With these in mind, hit ```Next``` and start marking the rest of the frames. After that's done, hit ```Save```, and ```Quit```; and most likley ```Yes``` to repeat this process for marking other videos. After the final video, in the main DLC window, go ahead and hit ```Check Labeled Frames```. The console should update like this:

**img16** 

Now if we go to our explorer window, and go to our project folder, and then ```labeled data```. We'll now see in here that each of the folders have been duplicated; but with a "labeled" suffix. Inside the original folder, there's a new *CollectedData.csv*, which contains all the coordinates we just marked out. But in the "labeled" folder, are images showing crosshairs of each of the frames we marked. It's worth going through these now just to double check that everything looks okay; before we get into traning, as these frames will act as our sample:

**img17**

For the purposes of documentation, all of the original markings I did to generate the *simplePair2* network are viewable in ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut\simplePair2-Josh-2019-12-18\labeled-data```.

## Training our Network

If anything looks wrong, you can go back and ```Label``` frames again, and edit over the top of your existing markings; But assuming everything is fine, we can move on to the ```Create Training Dataset``` tab:

**img18**

On this set of options, we have:
- **Select Network**: A variety of different networks here are available for use, including MobileNets of various versions (suited for low-power computers like laptops, trading off a lot of accuracy & power for efficiency) and ResNets. The number after the resnet refers to how many "layers" it has, with higher numbers being more suited to more complex tasks (like multiple animals).
- **Select Augmentation**: These each represent different ways of "augmenting" each frame that we process - each with their own spin on things like auto-cropping or contrast-heightening etc; to make our training & detection better.
- **Shuffle Index**: Each time we train a new network (our project can house multiple), it's given a number - the Shuffle number, to differentiate it. We can specify the number we want this network to be "named" here, or if not set, will just set the next available number; in this case: ```1```.
- **Trainingset Index**: I haven't personally played around with developing multiple different training sets, so for now the default of 0 is the only one we have.
- **Need User Feedback**: Similar to the Extract Frames window, if we choose yes, we'll be asked in console to confirm somethings. I chose "No" this time.
- **Compare Models?**: I didn't say which Network or Augmentation I used earlier, because for our first time training a network, we should try a few out and see what performs best. Select ```Yes```.

**img19** 

Now our window will have updated to look like this. Note the grayed out fields, as they are only applied to "single network" mode. In comparing mode, we're going to set up multiple different networks to train, so that we can compare the results. Select a few different networks and augmentations, and a dataset will be set up for each different Network + Augmentation combination. I went with all three ResNets, and Default & Imgaug (tensorpack wouldn't work for me).

Now if we open up our explorer window and look at the project folder again, we'll see a new ```training_model_comparison.log``` file. Open it up in Notepad:

**img20**

This shows us the list of each network dataset that was created, and the **index** field indicates which shuffle number each is referred by. Now back in the main DLC window; let's move on to the ```Train Network``` tab; with the following fields:
- **Specify Shuffle**: We have to actually train each of our networks one-by-one, and this is where we select which one to train from the list we just looked at. For now let's go with number one.
- **Trainingset Index**: Again, we only have one of these, and it's number ```0```.
- **Edit pose_cfg.yaml**: This contains a whole lot of way more advanced configurations, which I haven't personally explored, but are well documented in the DLC documentation.
- **Display Iterations**: This just sets a variable that says "every *x* iterations of training, display an update". This is a purely cosmetic field. Sometimes it's just nice to see the progress numbers tick up. For this example I set it to 1000.
- **Save Iterations**: This is similar to display iterations; except this says how many iterations apart to save the weights - a new file is created for each of these, so not too many. I went with 50,000.
- **Max Iterations**: This is the only number that actually matters, as this is how many iterations of training the network will be put through. More iterations = more training = better results; although we encounter diminishing returns with minimal gains generally occuring after 200,000 iterations. 
- **Snapshots to keep**: I haven't played around much with this either, but I believe it's similar to Save Iterations in terms of it storing a snapshot that can be started from later.

For the purposes of this demonstration, I'd reccomend doing a quick test with **Display Iterations = 10** and **Max Iterations = 100*:

**img21**

As soon as we hit ```OK```, we can start to look for progress on the console, this will take a while to get going:

**img22**

This is our iteration updates, every 10 iterations, across a total of 100 iterations; like we asked for.

**img23**

Now, I did this super tiny train as just an example, but if you're looking to actually compare the networks operating for real, I'd reccomend something like 10,000-50,000 total iterations, on each network, which could take hours or even days depending on the computer. The other problem with this is that you (using the UI at least) have to wait for each to finish before starting the next train. This is a good example of a place where using the extensive Python API that DLC has; I have an example script ***Here*** that I wrote up, which, when ran will chain-train the selected networks back-to-back - this is useful for batch comparing many models like this over a weekend.

## Evalutaing our Network

While we could stop here and go straight to using our network; it probably isn't quite that great yet, and we also made all those different networks to compare, so which one do we even want to be using? First, moving over to the ```Evaluate Network``` tab:

**img24**

This tab's fields are pretty straightfoward:
- **Specify Shuffle**: Like with training, we can only evaluate a single network at a time. Luckily, this takes nowhere near as long as training, and we can just do that. Pick the shuffle (which you've already trained).
- **Specify Trainingset Index**: Again, we only have ```0```.
- **Want to plot predictions?**: asdasd
- **Compare all Bodyparts?**: Selecting no here will allow us to select which bodyparts to use; But that requires a somewhat niche use case. I selected *Yes*.

After hitting ```OK```, our console will update again:

**img25**

Now in our explorer window looking at our project folder, we should be able to go into the new ```Evaluation-results/iteration-0/shuffle``` folder, and see an Excel Spreadsheet. Opening it up looks like this:

**img26**

These values are based off the 10/100 network made in the earlier example. What each column means:
- **Training Iterations**: The number of iterations this network went through.
- **%Training Dataset**: The number of frames in the sample used for training. 100-x here is the number saved to be used purely as "tests" which are novel - as the network wasn't trained on them. Not super important to us.
- **Shuffle Number**: Useful if you forgot which one you were in.
- **Train Error**: The average pixel-distance error between the network's estimated values, and our handmarked values on the trainingset (the 95% of the frames).
- **Test Error**: The average pixel-distance error between the network's estimated values, and our handmarked values on the tesetset (the 5% of the frames).
- **p-cuttoff**: When using a network to evaulate anything, the network actually generates multiple "guesses" at the location of each point, each with their own "likelihood", reflecting how certain the network is that the point it's looking for is there. Then, from the list of guesses, the network chooses the highest likelihood one, and that becomes the decided value for that point. **p-cutoff** here refers to a cutoff below which a point is ignored - this is because even if the "most certain" the network is of a point is like 5% certain, it's still selected as technically the "most likely" place. But a likelihood this low means that it's likely not actually there, or occluded by something else. So this cutoff helps us remove these from the "averaging" data - if the likelihood of a given point is below this, it's ignored.
- **Train Error with p-cutoff**: The average pixel-distance error between the network's estimated values, and our handmarked values on the trainingset (the 95% of the frames); but this time ignoring the values that are below the likelihood cutoff.
- **Test Errror with p-cutoff**: The average pixel-distance error between the network's estimated values, and our handmarked values on the trainingset (the 5% of the frames). but this time ignoring the values that are below the likelihood cutoff.

Basically, we want all of these values to be as low as possible, we are trying to minimise the error (the delta between the network's predictions, and our own "correct" markings). I find it useful to collect up these spreadsheets and add them together into one, which you can see in my deeplabcut project folder as ***shuffles.xlsx**:

**img27**

As you can see on the table, I included a bit of extra data on each shuffle as well, but the last four columns are just the same as the evaluation results of each shuffle. There's also a couple of earlier training results that I did, amongst the 6 different Network/Augmentations I tried the combinations of. If you ticked the **Plot Trajectories** box earlier, we can also go back in explorer to the evaluation results folder, and into the relevant shuffle's results again, but this time going into the subfolder next to the spreadsheet; and in here are some visual representations of the test results:

**img28**

These can be helpful for trying to figure out what our network is actually doing, as well as getting a feel for how well the training is going. The different symbols on each image here are:
- **+** is for the markings that we made ourselves
- **.** for confident predictions (likelihood above the cutoff)
- **x** for unconfident predictions (likelihood below cutoff)

## Refining our Network

So collecting up our table, and maybe reviewing some of the visual data, we should have an idea of which of our networks performed the best - shuffle 6 - which used Resnet_152 & imgaug. So let's try it out and put an actual video on it: go into the ```Analyze Videos``` tab. I cover this tab in a bit more detail in the Analysis guide ***here***, so for now I'll just give the settings I used right here:
- **Select Videos to Analyze**: I picked a single one of the videos I used for the original sample
- **Specify Videotype**: mp4
- **Shuffle**: 6 (the one that performed the best)
- **Trainingset Index**: 0
- **Destination Folder**: None (This doesn't work in the current version I'm using)
- **Save Results as CSV**: No
- **Filter Predictions**: No
- **Plot Trajectories**: No
- **Crop Videos?**: No
- **Dynamically Crop Bodyparts**: No
- **Create Labeled Video**: Yes (This opens up more options)
- **Include Skeleton?**: No
- **Number of Trailpoints**: 1

**img29**

This'll take a minute, we're actually generating a marked video! We're only doing one though, and it's one we've already sampled from. This is because the 20 frames per video, are quite likely to have a few gaps in how generalizable they are. When the video finishes building, you'll be able to find it in the same folder as your video source:

**img30**

We want to open up the new video here, and frankly just watch it. You'll undoubtedly come into contact with a few bad looking frames here and there - awkward jumping, double-marking, etc. We want to take note of these, if you have a frame counter method of any kind, take down the frame number. 
 - If you don't have a frame counter in any of your video players, this can be estimated instead via converting the timestamp to seconds ((Minutes: * 6)) + Seconds), and then multiplying by 25 (The FPS of your camera used to record, mine with 25 FPS). In any way, as long you can sdfghjkasahsufhaisduhaisudhaisudhai
 
 Back to extract frames asdhgajshdjahsbdjahsbdjahsbdjahbds - manual & update slider width
 
 **img31** - extract frames manual opening window
 **img32** - crop frames?
 **img33** - Select frame 10000, 20l, 30k
 **img34** - new list of frames
 **img35** - label frames with new frame
 **img36** - label frames with new labels - explain that in real thing we went up to 
 
 **img37** - Training Dataset tab for shuffle 7
 **img38** - Collected Data in dlc/training-datasets/iteration-0/DataSet spreadsheet updated
 **img39** - Train network for "final" network
 **img40** - Evaluate 7 tab
 **img41** - shuffles updated - amazing woo
 
 --- extract ourlier frames doesn't work!!!!!!!!

Now that I have this in mind, I can go back and set up a fresh network which I'll use as the "real" version (with a much larger set of iterations), to briefly recap steps:
- ```Create training dataset```
- - **Network**: resnet_152
- - **Augmentation**: imgaug
- - **Specific Shuffle Index**: 7 (after 6, our last network)
- - **Trainingset**: 0
- - **Compare Models**: No (we already know the one we want)
- - ```OK```
- ```Train Network```
- - **Shuffle**: 7
- - **Trainingset Index**: 0
- - **Edit pose_cfg.yaml**: No
- - **Display Iterations**: 10k
- - **Save Iterations**: 10k
- - **Maximum Iterations**: 200k
- - **Snapshots**: 5
- - ```OK``` (this step took 21 Hours on a decent PC)

