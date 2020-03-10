# Analyzing Videos with DeepLabCut

### Download DeepLabCut (DLC), and read their documentation here: https://github.com/AlexEMG/DeepLabCut

This is a short guide intended to walk someone through the process of using a DeepLabCut network (which has already been prepared) to analyze new video files. To see how to train your own custom network, see [here](./dlctrain.md). For the purposes of this guide, I'll be referring to the network stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut```, and the sample videos stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```.

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

![img1](./img/dlcbasic/img1.png)

 - Alternatively to this, click ```Open File Location``` from the right-click menu; In the new explorer window, **right-click** the Anaconda Prompt (***not*** Powershell Verision), and select ```Properties```. Inside the Properties window, open ```Advanced```, and tick the *Run as Administrator* option, and click *OK* to save. This means that in the future, Anaconda Prompt will open as Administrator by default.
 
![img2](./img/dlcbasic/img2.png)
 
 Now inside the Anaconda Prompt window we want to enter the following codes, hitting ```Enter``` after each line:
 - ```activate *dlc-windowsGPU*``` - This just puts us in the DeepLabCut environment we already set up
 - ```ipython``` - This puts us in a version of the terminal that recognises Python script
 - ```import deeplabcut``` - Pulls deeplabcut from the online repository
 - ```deeplabcut.launch_dlc()``` - Opens up the DLC user interface
 
![img3](./img/dlcbasic/img3.png)
 
 We should now be greeted with the following screen:
 
![img4](./img/dlcbasic/img4.png)
 
 ## Analyzing our Videos
 
Now here, before we start opening anything up, we have to check that our config file is set up correctly. If you've moved or copied your deeplabcut folder (with the network stored in it) anywhere (in this instance, anywhere other than ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut\simplePair2-Josh-2019-12-18```), you'll have to update this manually. So let's open up an Explorer window (```Windows Key``` + ```E```), and navigate to our deeplabcut folder. Inside, we want to open up *config.yaml* inside Notepad:

![img5](./img/dlcbasic/img5.png)

As we can see here, my **project_path** variable isn't correct! You'll also notice my **video_sets** variables are also wrong, however this only matters during a training process, not relevant to us here, so we can leave them alone for now. Updating the **project_path**:

![img6](./img/dlcbasic/img6.png)

With this corrected, we can return to the DeepLabCut window, and go to the *Manage Project* tab. Here, we want to select the ```Load existing project``` option. We then want to ```Browse``` to select our config file. Here, we navigate to that *config.yaml* file (the one we just edited):

![img7](./img/dlcbasic/img7.png)

After we confirm the file and hit ```OK```, we should see a few more tabs appear! Most of these are related to training, so we're going to skip right ahead to *Analyze Videos*:

![img8](./img/dlcbasic/img8.png)

First off, we'll hit ```Select videos to analyze```, which will open the video selection dialog. Navigate to wherever all your videos are stored; For this example I used ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```. You can drag a box to select multiple videos at once, or click on multiple while holding ```Ctrl``` or ```Shift```. In this case, I selected just one video:

![img9](./img/dlcbasic/img9.png)

- Note that if you accidentally select videos wrong, and try to change your selection, it'll just keep adding to the list. To fully reset the collection, just go back to the *Manage Project* tab and reopen the project file.

Now we have to select all the options for our analysis, which I've detailed in order below:
- **Specify the videotype**: This specifies the output format of the video you'll be creating.
- **Specify the shuffle**: This is where we select the network from the list of networks in the project. If you've made your own network, you'll hopefully know which of your shuffles/networks are the ones you want. For the purposes of the my project, the network shuffle that performs the best is ```7```.
- **Specify the trainingset index**: I haven't personally experimented that much with different trainingsets, and so again if you experimented with creating these, you'll know which one to choose. In this project, we're just sticking with ```0```.
- **Specify destination folder**: *In theory* this would allow us to pick a folder that all our analysis files would be put in automatically, however in the version of DLC I'm using; this feature seems to be broken. All of the output files created are going to end up in the same folder as the source material (*sourceData/pilotMPG*).
- **Save results as csv**: Selecting yes on this will produce a Comma-Seperated-Value spreadsheet (useable in Excel & Matlab), containing the frame-by-frame x/y coordinates of each body part, as well as some other useful numbers. This is probably the most useful setting to have ticked on if you're doing numerical mass data analysis.
- **Filter the predictions**: *In theory* this creates an additional **.h5** file in output, which is openable in Matlab (https://au.mathworks.com/help/matlab/ref/h5f.open.html) or Python (http://docs.h5py.org/en/latest/index.html). For me, while it did actually create the file, I wasn't able to open it up, and am yet unsure if that's a problem with the file or the way I tried to open it. The documentation suggests that using the **Save as CSV** functionality might be overriding this?.
- **Plot trajectories**: Selecting this will create some interesting looking graphs that visually display positional data about the video in general. This can be interesting to look at, but seems more useful to a more in-depth single-video analysis; rather than a numerical mass-data analysis.
- **Crop the videos?** & **Dynamically crop bodyparts**: These both use settings in the config files, and are much more throroughly covered in the DLC documentation; But generally these are both features intended for cropping the video dynamically to follow the animal being tracked - this is mainly useful if we're just interested in analysing the "pose" of the animal alone. If we're interested in the position of the animal inside the environment however (like I am), we'd rather leave these off.
- **Create labeled videos?**: This refers to whether or not we actually want to output a real video that we can watch; with the marker circles on it. While it does seem intuitive that this would be defaultly on, being able to select "no" on this is useful for saving a lot of proccessing time & storage space when we're mass analyzing hundreds of videos that we aren't going to be watching anyway. If we're just interested in the CSV for the numbers, we can leave this off. For demonstration though, we'll put this on.
- **Include the skeleton:**: This option will only appear if you ticked "yes" on making a video. If you set up a skeleton in the training process, you'll be able to turn this on; I didn't however, so I'll leave it off.
- **Specify number of trail points**: Like the previous option, this only shows up if we're making a video. This tells the video processor how many frames worth of "ghost" markers to have at a time. Setting this to just ```1``` will make a normal marked video, but setting it higher will leave a trail behind each marker of the previous positions, creating a visual trajectory plot.

![img10](./img/dlcbasic/img10.png)

After we've set all our options, like I have above, we can hit ```RUN```. This will take quite a while (like, hours for multiple videos), and we'll see progress in the Anaconda Prompt window. There are some scary looking errors here with dead frames in the video, but this shouldn't be much to worry about:

![img11](./img/dlcbasic/img11.png)

![img12](./img/dlcbasic/img12.png)

And that's it. Video Analysis done! It's probably worth taking tour through what we actually made though.

## Interpreting our Data

Open up an explorer window (```Windows Key``` + ```E```), and navigate to whatever our destination folder was set to (*in my case, the sourceData/pilotMPG folder*):

![img13](./img/dlcbasic/img13.png)

In here, we can see the original source videos (.mpg), and right next to the one video I actually analyzed, are all the output files. These are all clearly named the same as the original video, but followed by the name & details of the network used to analyze it. First we might as well open up the video, **.mp4** (you can also view a video I made here: https://youtu.be/1OT02HF8IUE) 

![img14](./img/dlcbasic/img14.png)

We can also open up the **.csv** file, which is a little less intuitive:

![img15](./img/dlcbasic/img15.png)

This is likely the most important of the files to understand; so I'll try and detail what it all means:
- First, the **top** row in this case is mostly useless to us, as we scored all our body parts with the same network
- The **second** row indicates which body part is being indicated in the column below it; In this case I have 8 body parts: Three for "rat A", Four for "rat B (including a colour marker to differentiate)", and a single marker for a fixed food well. Each body part will have three sub-columns, indicated in the **third** row: 
- **x & y axis**: Measured in actual pixels from the origin ((0, 0) is at the top-right corner of the video), per body part.
- **likelihood**: This is the more unintuitive column of them all. When the neural network is estimating where it "thinks" each body part is, it actually creates a number of different guesses, each with their own "likeliehood", from 0 to 1 - and then selects the highest, which becomes the coordinate it actually places in this table. So the likelihood is the network's way of indicating how "certain" it is that it's actually the correct placement. Points that have a likelihood below 95% aren't marked in the video, but are nonetheless shown in the CSV file; so it's important to consider this when doing numerical analysis. We can use this to our advantage during our analysis, if we want to either tighten or loosen the strictness of the "acceptable" threshold for example; or make sure that our averaging can be weighted to discount "uncertain" points.
- Each row from this point on is the values of each coordinate/likelihood ***per frame***. So my video had around 30000 frames, and as such has 30000 rows.

The remaining files we can see here (**.h5** and **.pickle**) aren't that useful to us, only containing some small metadata; and can be safely deleted. Let's also take a look in the*plot-poses* folder though, and the per-video subfolder in there:

![img16](./img/dlcbasic/img16.png)

These are all purely visual graphs, which are generated by the **Plot trajectories** option, which aren't super useful for mass-video analysis, and individually are rather difficult to interperet, but I've included them here for completeness:

**hist.png**: Graphing the total pixel distance between each marker, per frame:

![hist](./img/dlcbasic/hist.png)

**plot.png**: Graphing the X & Y of each marker over time:

![plot](./img/dlcbasic/plot.png)

**plot-likelihood.png**: Certainty of each marker over time:

![plot-likelihood](./img/dlcbasic/plot-likelihood.png)

**trajectory.png**: Map of every single marker placed in the entire video. Probably the most useful graph.

![trajectory](./img/dlcbasic/trajectory.png)

## If you made it this far

Thanks for actually reading all of that, I hope it's enough to get people going with the basics of running video files through DeepLabCut. There'll be another guide ***here*** on how to train your own network, and if there are any errors or clarifications needed, I'm almost always available by email at joshwhitney789@gmail.com.
