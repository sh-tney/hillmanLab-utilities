import deeplabcut
from colorama import init, Fore, Style
from datetime import datetime

# init colorama, config path, and global variables
init(autoreset=True)
conf = input("Config Path: ")
print(Fore.BLUE + "Multi-Shuffle Training; Note Variables are " + Fore.RED + "PER-SHUFFLE")
shuffles = []
disits = 0
savits = 0
maxits = 0

# user input of global variables, with a simple confirm loop that restarts anything not "y"
go = False
while go == False:
    shuffles = input("Shuffles to Train: ").split()
    trainset = int(input("Training set to use: "))
    print("Display progress every " + Fore.GREEN + "x" + Style.RESET_ALL + " Iterations;" + Fore.GREEN + " x", end=" = ")
    disits = int(input())
    print("Save weights every " + Fore.GREEN + "y" + Style.RESET_ALL + " Iterations;" + Fore.GREEN + " y", end=" = ")
    savits = int(input())
    print("Run a total of " + Fore.GREEN + "z" + Style.RESET_ALL + " Iterations;" + Fore.GREEN + " z", end=" = ")
    maxits = int(input())
    print(Fore.BLUE + "Preparing to Run Train, Details:")
    print("Shuffles to Run: " + Fore.GREEN + str(shuffles))
    print("Training Set to Use: " + Fore.GREEN + str(trainset))
    print("Display Iterations: " + Fore.GREEN + str(disits))
    print("Save Iterations: " + Fore.GREEN + str(savits))
    print("Total Iterations: " + Fore.GREEN + str(maxits))
    print(Fore.RED + "Confirm? ", end="(y/n): ")
    if input() == "y":
        go = True
        print(Fore.BLUE + "Starting Training at " + str(datetime.now()))

for i in shuffles:
    try:
        deeplabcut.train_network(conf, shuffle=int(i), trainingsetindex=trainset, displayiters=disits, saveiters=savits, maxiters=maxits)
    except:
        print(Fore.RED + "Something broke on shuffle " + i + " at " + str(datetime.now()))
        raise
    else:
        print(Fore.BLUE + "Shuffle " + i + " finished at " + str(datetime.now()))
