# Recover dual from PowerModel via PandaPower interface

Related to this [issue](https://github.com/lanl-ansi/PowerModels.jl/issues/409#issuecomment-1232967313) on github.

Dual variables (also know as Lagrange Multipliers) can not be accessed easily in PowerModels v0.19.6.
This code aims at making them easily accessible.

:warning: Warning :warning: 
This code is not part of the official PowerModels nor PandaModels packages.
It is not maintainded and is garanted to work only for these specific versions :
- Julia : v1.5.4
- PowerModels (julia) : v0.19.2
- PandaModels (julia) : v0.5.0
- JuMP (julia) : v0.22.3
- Ipopt (julia) : v0.9.1
- Python : v3.8.13
- PandaPower (python) : 2.10.1

## PandaPower
**Python** file located in ```pandapower/opf/run_powermodels.py```

## PandaModels
**Julia** file located in ```PandaModels/src/```.

## InfrastructureModels
Used to silence OPF results.
**Julia** file located in ```InfrastructureModels/src/core/base.jl```.

*Remark :*
For some reason, the package used by julia was located in ```.julia/dev/PandaModels/``` instead of ```.julia/packages/PandaModels/```.