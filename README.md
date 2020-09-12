# Class Scheduling with MiniZinc

## Pre requisites
- Install python 3 preferably with [anaconda and jupyter notebook](https://www.anaconda.com/)
- Install [minizinc](https://www.minizinc.org/) and add the necessary solvers
    - Method 1(Recommeded): 
        - Download the app bundle from the official [website](https://www.minizinc.org/). [for ubuntu](https://github.com/MiniZinc/MiniZincIDE/releases/download/2.4.3/MiniZincIDE-2.4.3-bundle-linux-x86_64.tgz)
        - Add the executables to the PATH [[help]](https://linuxize.com/post/how-to-add-directory-to-path-in-linux/)
        - The bundle includes all the necessary solvers
    - Method 2: 
        - Install from snapstore or other repositories `sudo apt install minizinc`
        - In this method, solvers need to be installed manually. 
        - Install [Chuffed](https://github.com/chuffed/chuffed) solver.
- Check if Chuffed solver (or any other solver of choice) is available 
    - `minizinc --solvers` from terminal
- Install pymzn
    - `pip install pymzn`
