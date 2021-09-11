# PR_institutions_values_opinions_model

[![GitHub license](https://img.shields.io/github/license/jsegoviamartin/PR_institutions_values_opinions_model)](https://github.com/jsegoviamartin/PR_institutions_values_opinions_model/blob/main/LICENSE) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/jsegoviamartin/PR_institutions_values_opinions_model?color=green)

Model to explore how opinion dynamics evolve under institutions that aggregate information using proportional representation

In this repository you can find the Python scripts to implement my agent-based model of opinion dynamics as described in:
Segovia-Martin, J., Tamariz, M. (2020). Synchronising institutions and value systems: a model of opinion dynamics mediated by proportional representation

Files named *Influence_Model.py* and *Influence_Model_100.py* contain the core classes and functions needed to run the model. The script named with the 100 is coded for simulations of 100 agents, while the one without it is coded for simulations with 10 agents.

Files named *Run_model.py* and *Run_model_100.py* are the two main scripts that import the files mentioned above in order to run the simulation. In these scripts you can manipulate:

- Initial agents' value system
- Institutional influence
- Agents' memory
- Agents' biases
- Number of simulations

By running the model you will obtain a csv file containing the entropy of opinions produced at each time step for each of the conditions examined. Furthermore, you can use the model to investigate the impact of different variables on other alpha indices of diversity.

Please do not hesitate to contact me if you have any questions.

Update 1 Aug 2021: Model_III.py and Run_Model_III.py correspond to the latest versions of the model.

