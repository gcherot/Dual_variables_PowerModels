# Procedure to install from scratch on Linux

## 1. Install Python - Julia interface

1. ```conda create -n panda_julia python=3.8```. Later python version are not compatible with the interface.
2. ```conda activate panda_julia```
3. ```conda install pip```. From now on, we will only use ```pip```.
4. Download Julia 1.5.4, place in a folder with **no special caracter**.
5. Add Julia to path : ```export PATH="$PATH:/path/to/julia/bin"``` in ```./.profile``` file. 
6. Follow the instructions given on [this page](https://pandapower.readthedocs.io/en/v2.10.1/opf/powermodels.html).
7. ON LINUX ONLY : In order for the interface to work, you will have to enter these command ```from julia.api import Julia``` and ```jl = Julia(compiled_modules=False)``` (Incidence on the speed ??)

## Install the custom package

PowerModels does not give direct access to dual variables.
Thus, we use a custom package.
It modifies some of the original code.

### Modify Pandapower

1. Change the code on the file.


### Modify PandaModels

1. Copy the file ```Model/recover_dual.py```.
2. Change the code in the other files.

## Possible errors
- Multiple version of Julia installed on the same computer. Python is likely to take the first installed, probably the wrong one.
- Julia should have **no special caracter** in its path. Python will throw an error on ```from julia import ...```.