import Model_III
import random as rand
import numpy as np
from skbio.diversity.alpha import brillouin_d, margalef, simpson, simpson_e, observed_otus, shannon
import pandas as pd

#Variables

#Condition (labeled as follows: "Population Value_system Ipower")
#Population can be: "Homogeneity or Heterogeneity";
# Value system can be: OTA, C or R;
#Ipower can be: In (I_power = 0), Im (I_power=0.5) or Is (I_power=1);
condition = "Heterogeneity R I005"

#Agents' initial Value systems
# OTA & Homogeneity
# s1 = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# s2 = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# OTA & Heterogeneity
# s1 = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# s2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# Competition & Homogeneity
# s1 = [0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
# s2 = [0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# Competition & Heterogeneity
# s1 = [0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
# s2 = [0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0.5]
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# Random & Homogeneity
# s1 = np.random.dirichlet(np.ones(10),size=1).ravel().tolist()
# s2 = s1
# sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
# Random & Heterogeneity
s1 = np.random.dirichlet(np.ones(10),size=1).ravel().tolist()
s2 = np.random.dirichlet(np.ones(10),size=1).ravel().tolist()
sigmas = {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9:s2, 10:s2}
#Assignment of value systems for populations with 100 agents.
# sigmas =  {1: s1, 2: s1, 3: s1, 4: s1, 5: s1, 6: s2, 7: s2, 8: s2, 9: s2, 10: s2,
#               11: s1, 12: s1, 13: s1, 14: s1, 15: s1, 16: s2, 17: s2, 18: s2, 19: s2, 20: s2,
#               21: s1, 22: s1, 23: s1, 24: s1, 25: s1, 26: s2, 27: s2, 28: s2, 29: s2, 30: s2,
#               31: s1, 32: s1, 33: s1, 34: s1, 35: s1, 36: s2, 37: s2, 38: s2, 39: s2, 40: s2,
#               41: s1, 42: s1, 43: s1, 44: s1, 45: s1, 46: s2, 47: s2, 48: s2, 49: s2, 50: s2,
#               51: s1, 52: s1, 53: s1, 54: s1, 55: s1, 56: s2, 57: s2, 58: s2, 59: s2, 60: s2,
#               61: s1, 62: s1, 63: s1, 64: s1, 65: s1, 66: s2, 67: s2, 68: s2, 69: s2, 70: s2,
#               71: s1, 72: s1, 73: s1, 74: s1, 75: s1, 76: s2, 77: s2, 78: s2, 79: s2, 80: s2,
#               81: s1, 82: s1, 83: s1, 84: s1, 85: s1, 86: s2, 87: s2, 88: s2, 89: s2, 90: s2,
#               91: s1, 92: s1, 93: s1, 94: s1, 95: s1, 96: s2, 97: s2, 98: s2, 99: s2, 100: s2}

#Institutional influence
i_power=0.05

#Agents' Memory
menLen=3

#Number of simulations
simulations=200

#Agents' biases
samples = [
# {'cont': 0.0, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.1, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.2, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.3, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.4, 'coord': 0.5, 'mut': 0.02},
{'cont': 0.5, 'coord': 0.5, 'mut': 0.02}]
# {'cont': 0.6, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.7, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.8, 'coord': 0.5, 'mut': 0.02},
# {'cont': 0.9, 'coord': 0.5, 'mut': 0.02},
# {'cont': 1.0, 'coord': 0.5, 'mut': 0.02}]
samples = [d for d in samples for _ in range(1)]

Model_III.main(menLen, i_power, sigmas, samples, simulations, condition)





