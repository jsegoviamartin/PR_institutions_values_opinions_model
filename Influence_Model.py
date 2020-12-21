from __future__ import division
from random import random, sample
import random as rand
from random import choices
from bisect import bisect
from collections import deque, Counter
from itertools import permutations
import csv
import math
import numpy as np
from skbio.diversity.alpha import brillouin_d, margalef, simpson, simpson_e, observed_otus, shannon

#Output
output=[]

###List that appends institution's value system at each round
institution_history=[]

# CHOICE FUNCTION (CUMMULATIVE PROBABILITIES)

class Agent:
    def __init__(self, name, signals, sigma, cont, coord, mut, menLen, i_power):
        self.name = name
        self.signals = signals
        self.mem_shown = {signal: 0 for signal in signals}
        self.mem_observed = {signal: 0 for signal in signals}
        self.__mem_shown = deque(maxlen=menLen)
        self.__mem_observed = deque(maxlen=menLen)
        self.sigma = sigma[:]  # Make a unique copy of sigma for each agent
        self.cont = cont
        self.coord = coord
        self.mut = mut
        self.i_power = i_power

    def recall(self, v_shown, v_observed):
        self.__mem_shown.append(v_shown)
        self.__mem_observed.append(v_observed)
        v_shown = Counter(self.__mem_shown)
        v_observed = Counter(self.__mem_observed)
        self.mem_shown = {signal: v_shown.get(signal, 0) for signal in self.signals}
        self.mem_observed = {signal: v_observed.get(signal, 0) for signal in self.signals}

    def __str__(self):
        return "Agent_{}".format(self.name)

    #PROBABILISTIC FUNCTION THAT YIELDS THE PROBABILITY OF PRODUCTION OF A SIGNAL FOR A GIVEEN HISTORY
    def with_b(self, shown, observed, r, idx):
        if not (shown == observed == 0):
            result = (
                    ((0.98) * (1.0 - self.cont) * (1.0 - self.coord) * shown / r)
                    + ((0.98) * (1.0 - self.cont) * (self.coord) * observed / r)
                    + ((0.98) * self.cont * self.sigma[idx])
                    + ((self.mut / 10))
            )
        else:
            result = (
                    ((0.98) * (1.0 - 0) * (1.0 - self.coord) * shown / r)
                    + ((0.98) * (1.0 - 0) * (self.coord) * observed / r)
                    + ((0.98) * 0 * self.sigma[idx])
                    + ((self.mut / 10))
            )
        return result


    ## CHOOSE FUNCTION (VARIANT SELECTION)
    def choose(self, r, institution):

        probs = [
            self.with_b(
                self.mem_shown[op], self.mem_observed[op], r, indx
            )
            for indx, op in enumerate(self.signals)
        ]
        # Elecc is a list that returns a randomly selected element from the specified sequence:
        # In our case, we weight the possibility of each result with the probabilities yielded by the model (probs)
        elecc = choices(self.signals, probs)[0]
        # Line to transform choice (e.g. "S1") to a vector representing the choice [1,0,0,0]
        aux = [(elecc == signali) + 0 for signali in self.signals]
        ##Implementation of institutional influence on value system (sigma)
        self.sigma = (self.i_power * np.array(institution) + 0.5*((1 - self.i_power) * np.array(self.sigma) + (1 - self.i_power) * np.array(aux)))
        #else:
            #self.sigma=self.sigma
        return elecc


class Match:
    def __init__(self, agents, pairs, signals, sigmas, cont, coord, mut, menLen, i_power):
        self.pairs = pairs
        self.signals = signals
        self.agents = {
            name: Agent(name, signals, sigmas[name], cont, coord, mut, menLen, i_power)
            for name in agents
        }
        self.institution = np.mean(list(sigmas.values()),0)
        self.memory = list()
        self.entropy = float()
        self.memory_sigmas = list()
        self.i_power = i_power

    def produce_signals(self):
        # Agents initialised with an unique variant
        yield dict(zip(self.agents, self.signals))
        # Agents initialised with a random variant from the pool of variants (without repetition [with replacement]): Agents might have the same initial varaint
        # yield dict(zip(self.agents, choices(self.signals, k=10)))
        r = 1
        while True:
            eleccs = {}
            for agent in self.agents.values():
                eleccs[agent.name] = agent.choose(r, self.institution)
            r += 1
            yield eleccs
            #print(r,self.institution)
            #print(eleccs)


    def play(self):
        gen_sens = self.produce_signals()
        for round in self.pairs:
            signals = next(gen_sens)
            self.memory.append(signals)
            for agent1, agent2 in round:
                self.agents[agent1].recall(v_observed=signals[agent2], v_shown=signals[agent1])
                self.agents[agent2].recall(v_observed=signals[agent1], v_shown=signals[agent2])
            # for name, agent in self.agents.items():
            #     print("{}: sigma={}, content.bias={}".format(name, agent.sigma, agent.cont))
            # Calculate mean of sigmas of the past round. That is, create the institution, which is a mean of agents' value system
            i = [agent.sigma for agent in self.agents.values()]
            self.institution = np.mean(i,0)
            #print(self.institution)
            # Append institution value system (institution) to the history of the institution (institution_history)
            institution_history.append(self.institution)


# Shannon entropy function
def entropy(lista):
    N = sum(lista)
    probs = (freq / N for freq in lista if freq > 0)
    return -sum(x * math.log(x, 2) for x in probs)

# Function to randomize connectivity dynamic with replacement
def group(agents, n=100):
  caso = agents[:]
  result = []
  for _ in range(n):
    rand.shuffle(caso)
    gen = list(zip(*[iter(caso)] * 2))
    result.append(gen)
  return result


# main function
def main(menLen, i_power, sigmas, samples, simulations, condition):
    agents = [1,2,3,4,5,6,7,8,9,10]
    signals = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10']

    network = group(agents)
    pairs = [list(elem) for elem in network]


    statistics = {
        sim: {
            agent: {
                sample: {
                    signal: [0 for round in range(1, len(pairs) + 1)]
                    for signal in signals
                }
                for sample in range(len(samples))
            }
            for agent in agents
        }
        for sim in range(simulations)
    }

    for sim in range(simulations):
        #network = group(agents)
        #pairs = [list(elem) for elem in network]
        for mu in range(len(samples)):
            game = Match(
                agents,
                pairs,
                signals,
                sigmas,
                samples[mu]["cont"],
                samples[mu]["coord"],
                samples[mu]["mut"],
                menLen,
                i_power
            )
            game.play()
            for n, round in enumerate(game.memory):
                for agent, signal in round.items():
                    statistics[sim][agent][mu][signal][n] += 1

    with open('homogeneity_C_0.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',',
                            quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerow(['Simulation', 'Sample', 'Agent', 'Memory', 'Generation', 'Condition', 'Inst_power','Content bias',
                         'Coordination bias','Mutation rate'] + signals +
                        ['Population signals'] + ['Entropy_population'] + ['Entropy_subpopulation_1'] + [
                            'Entropy_subpopulation_2'] + ['Subpopulation_1 signals'] + ['Subpopulation_2 signals']
                        + ['Brillouin_population'] + ['Margalef_population'] + ['Simpson_population'] + [
                            'Simpson_e_population'] + ['Richness'])

        # Creando listas que contienen la produccion de cada senal: para toda la poblacion (aux) y para cada jugador (auxn)
        #for agent in agents:
        for sim in range(simulations):
                for mu in range(len(samples)):
                    for round in range(1, len(pairs) + 1):
                        aux = [statistics[sim][agent][mu][signal][round - 1] for signal in signals]
                        aux1 = [statistics[sim][1][mu][signal][round - 1] for signal in signals]
                        aux2 = [statistics[sim][2][mu][signal][round - 1] for signal in signals]
                        aux3 = [statistics[sim][3][mu][signal][round - 1] for signal in signals]
                        aux4 = [statistics[sim][4][mu][signal][round - 1] for signal in signals]
                        aux5 = [statistics[sim][5][mu][signal][round - 1] for signal in signals]
                        aux6 = [statistics[sim][6][mu][signal][round - 1] for signal in signals]
                        aux7 = [statistics[sim][7][mu][signal][round - 1] for signal in signals]
                        aux8 = [statistics[sim][8][mu][signal][round - 1] for signal in signals]
                        aux9 = [statistics[sim][9][mu][signal][round - 1] for signal in signals]
                        aux10 = [statistics[sim][10][mu][signal][round - 1] for signal in signals]


                        # Lista que contiene los sumatorios de cada tipo de senales producidas a nivel de la poblacion global en cada muestra y ronda
                        summation_pop = []
                        # Lista que contiene los sumatorios de cada tipo de senales producidas a nivel de subpoblacion en cada muestra y ronda
                        summation_subpop_1 = []
                        summation_subpop_2 = []

                        # Sumando las senales de cada tipo
                        for i in range(len(aux1)):
                            # A nivel de la poblacion
                            summation_pop.append(
                                aux1[i] + aux2[i] + aux3[i] + aux4[i] + aux5[i] + aux6[i] + aux7[i] + aux8[i] + aux9[i] + aux10[i])
                            # A nivel de las subpoblaciones
                        for i in range(len(aux1)):
                            summation_subpop_1.append(aux1[i] + aux2[i] + aux3[i] + aux4[i] + aux5[i])
                            summation_subpop_2.append(+ aux6[i] + aux7[i] + aux8[i] + aux9[i] + aux10[i])

                        #print(aux1)
                        #output.append(shannon(summation_pop))
        #print(output)

                        writer.writerow([sim + 1, mu + 1, agent, menLen, round, condition, i_power, samples[mu]['cont'],
                                         samples[mu]['coord'],
                                         samples[mu]['mut']] + aux + [summation_pop] + [shannon(summation_pop)] + [
                                            shannon(summation_subpop_1)] + [shannon(summation_subpop_2)] + [
                                            summation_subpop_1] + [summation_subpop_2]
                                        + [brillouin_d(summation_pop)] + [margalef(summation_pop)] + [
                                            simpson(summation_pop)] + [simpson_e(summation_pop)] + [
                                            observed_otus(summation_pop) / 10])


if __name__ == '__main__':
    main()

#Two new columns
# import pandas as pd
# df = pd.read_csv('homogeneity_OTA_I10_III.csv')
# df['Institution'] = pd.Series(institution_history)
# df['Entropy_Institution'] = pd.Series(entropy(i) for i in institution_history)
# df = df.drop(df[df.Agent > 1].index)
# df.to_csv('homogeneity_OTA_I10_III.csv')