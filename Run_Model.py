import Reinforcement_Model_III
import random as rand
#Variables

#Conditions
condition = "Homogeneity C 0"

#Agents' Value systems
# Competition and homogeneity:
# s1 = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
# s2 = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# Random and heterogeneity
s1 = rand.sample([0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0], 10)
s2 = rand.sample([0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0], 10)
sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}

#Institutional influence
i_power=0

#Agents' Memory
menLen=3

#Number of simulations
simulations=2000

#Agents' biases
samples = [
{'cont': 0.0, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.1, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.2, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.3, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.4, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.5, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.6, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.7, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.8, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.9, 'coord': 0.5, 'mut': 0.02},
{'cont': 1.0, 'coord': 0.5, 'mut': 0.02}]
samples = [d for d in samples for _ in range(1)]

Reinforcement_Model_III.main(menLen, i_power, sigmas, samples, simulations, condition)









