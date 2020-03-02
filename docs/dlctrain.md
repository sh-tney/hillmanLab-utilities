# Using your DeepLabCut Network

**links to dlc page**

This is a short guide intended to walk someone through the process of using a DeepLabCut network (which has already been prepared) to analyze new video files. To see how to train your own custom network, see ***link***. For the purposes of this guide, I'll be referring to the network stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut```, and the sample videos stored in ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```.

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
 
Now here, before we start opening anything up, we have to check that our config file is set up correctly. If you've moved or copied your deeplabcut folder (with the network stored in it) anywhere (in this instance, anywhere other than ```S:\Kristin Hillman\LAB\Lab members\Josh\deeplabcut\simplePair2-Josh-2019-12-18```), you'll have to update this manually. So let's open up an Explorer window (```Windows Key``` + ```E```), and navigate to our deeplabcut folder. Inside, we want to open up *config.yaml* inside Notepad:

**img5**

As we can see here, my **project_path** variable isn't correct! You'll also notice my **video_sets** variables are also wrong, however this only matters during a training process, not relevant to us here, so we can leave them alone for now. Updating the **project_path**:

**img6**

With this corrected, we can return to the DeepLabCut window, and go to the *Manage Project* tab. Here, we want to select the ```Load existing project``` option. We then want to ```Browse``` to select our config file. Here, we navigate to that *config.yaml* file (the one we just edited):

**img7**

After we confirm the file and hit ```OK```, we should see a few more tabs appear! Most of these are related to training, so we're going to skip right ahead to *Analyze Videos*:

**img8**

First off, we'll hit ```Select videos to analyze```, which will open the video selection dialog. Navigate to wherever all your videos are stored; For this example I used ```S:\Kristin Hillman\LAB\Lab members\Josh\sourceData\pilotMPG```. You can drag a box to select multiple videos at once, or click on multiple while holding ```Ctrl``` or ```Shift```. In this case, I selected just one video:

**img9**

- Note that if you accidentally select videos wrong, and try to change your selection, it'll just keep adding to the list. To fully reset the collection, just go back to the *Manage Project* tab and reopen the project file.

Now we have to select all the options for our analysis, which I've detailed in order below:
- **Specify the videotype**: This suppo

**img10** - redo
