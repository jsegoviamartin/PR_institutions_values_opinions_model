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
                    + ((self.mut / 8))
            )
        else:
            result = (
                    ((0.98) * (1.0 - 0) * (1.0 - self.coord) * shown / r)
                    + ((0.98) * (1.0 - 0) * (self.coord) * observed / r)
                    + ((0.98) * 0 * self.sigma[idx])
                    + ((self.mut / 8))
            )
        return result


    ## CHOOSE FUNCTION (VARIANT SELECTION)
    def choose(self, r, institution):
        # Esta parte del código se extrajo de Partida.generar_senales()
        # y se ha adaptado
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
        #Implementation of institutional influence on value system (sigma)
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
        # yield dict(zip(self.agents, self.signals))
        # Agents initialised with a random variant from the pool of variants (without repetition [with replacement]): Agents might have the same initial varaint
        yield dict(zip(self.agents, choices(self.signals, k=100)))
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
    agents = list(range(1, 101))
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

    with open('heterogeneity_R_100.csv', 'w', newline='') as csvfile:
            writer = csv.writer(csvfile, delimiter=';',
                                quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(['Simulation', 'Sample', 'Agent', 'Memory', 'Generation', 'Condition', 'Content bias',
                             'Coordination bias', 'Mutation rate'] + signals +
                            ['Population signals'] + ['Entropy_population'] + ['Entropy_subpopulation_1'] + [
                                'Entropy_subpopulation_2'] + ['Subpopulation_1 signals'] + ['Subpopulation_2 signals']
                            + ['Brillouin_population'] + ['Margalef_population'] + ['Simpson_population'] + [
                                'Simpson_e_population'] + ['Richness'])

            # Creating lists that contain signals frequencies: for each population (aux) and agent(auxn)
            for agent in agents:
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
                            aux11 = [statistics[sim][11][mu][signal][round - 1] for signal in signals]
                            aux12 = [statistics[sim][12][mu][signal][round - 1] for signal in signals]
                            aux13 = [statistics[sim][13][mu][signal][round - 1] for signal in signals]
                            aux14 = [statistics[sim][14][mu][signal][round - 1] for signal in signals]
                            aux15 = [statistics[sim][15][mu][signal][round - 1] for signal in signals]
                            aux16 = [statistics[sim][16][mu][signal][round - 1] for signal in signals]
                            aux17 = [statistics[sim][17][mu][signal][round - 1] for signal in signals]
                            aux18 = [statistics[sim][18][mu][signal][round - 1] for signal in signals]
                            aux19 = [statistics[sim][19][mu][signal][round - 1] for signal in signals]
                            aux20 = [statistics[sim][20][mu][signal][round - 1] for signal in signals]
                            aux21 = [statistics[sim][21][mu][signal][round - 1] for signal in signals]
                            aux22 = [statistics[sim][22][mu][signal][round - 1] for signal in signals]
                            aux23 = [statistics[sim][23][mu][signal][round - 1] for signal in signals]
                            aux24 = [statistics[sim][24][mu][signal][round - 1] for signal in signals]
                            aux25 = [statistics[sim][25][mu][signal][round - 1] for signal in signals]
                            aux26 = [statistics[sim][26][mu][signal][round - 1] for signal in signals]
                            aux27 = [statistics[sim][27][mu][signal][round - 1] for signal in signals]
                            aux28 = [statistics[sim][28][mu][signal][round - 1] for signal in signals]
                            aux29 = [statistics[sim][29][mu][signal][round - 1] for signal in signals]
                            aux30 = [statistics[sim][30][mu][signal][round - 1] for signal in signals]
                            aux31 = [statistics[sim][31][mu][signal][round - 1] for signal in signals]
                            aux32 = [statistics[sim][32][mu][signal][round - 1] for signal in signals]
                            aux33 = [statistics[sim][33][mu][signal][round - 1] for signal in signals]
                            aux34 = [statistics[sim][34][mu][signal][round - 1] for signal in signals]
                            aux35 = [statistics[sim][35][mu][signal][round - 1] for signal in signals]
                            aux36 = [statistics[sim][36][mu][signal][round - 1] for signal in signals]
                            aux37 = [statistics[sim][37][mu][signal][round - 1] for signal in signals]
                            aux38 = [statistics[sim][38][mu][signal][round - 1] for signal in signals]
                            aux39 = [statistics[sim][39][mu][signal][round - 1] for signal in signals]
                            aux40 = [statistics[sim][40][mu][signal][round - 1] for signal in signals]
                            aux41 = [statistics[sim][41][mu][signal][round - 1] for signal in signals]
                            aux42 = [statistics[sim][42][mu][signal][round - 1] for signal in signals]
                            aux43 = [statistics[sim][43][mu][signal][round - 1] for signal in signals]
                            aux44 = [statistics[sim][44][mu][signal][round - 1] for signal in signals]
                            aux45 = [statistics[sim][45][mu][signal][round - 1] for signal in signals]
                            aux46 = [statistics[sim][46][mu][signal][round - 1] for signal in signals]
                            aux47 = [statistics[sim][47][mu][signal][round - 1] for signal in signals]
                            aux48 = [statistics[sim][48][mu][signal][round - 1] for signal in signals]
                            aux49 = [statistics[sim][49][mu][signal][round - 1] for signal in signals]
                            aux50 = [statistics[sim][50][mu][signal][round - 1] for signal in signals]
                            aux51 = [statistics[sim][51][mu][signal][round - 1] for signal in signals]
                            aux52 = [statistics[sim][52][mu][signal][round - 1] for signal in signals]
                            aux53 = [statistics[sim][53][mu][signal][round - 1] for signal in signals]
                            aux54 = [statistics[sim][54][mu][signal][round - 1] for signal in signals]
                            aux55 = [statistics[sim][55][mu][signal][round - 1] for signal in signals]
                            aux56 = [statistics[sim][56][mu][signal][round - 1] for signal in signals]
                            aux57 = [statistics[sim][57][mu][signal][round - 1] for signal in signals]
                            aux58 = [statistics[sim][58][mu][signal][round - 1] for signal in signals]
                            aux59 = [statistics[sim][59][mu][signal][round - 1] for signal in signals]
                            aux60 = [statistics[sim][50][mu][signal][round - 1] for signal in signals]
                            aux61 = [statistics[sim][61][mu][signal][round - 1] for signal in signals]
                            aux62 = [statistics[sim][62][mu][signal][round - 1] for signal in signals]
                            aux63 = [statistics[sim][63][mu][signal][round - 1] for signal in signals]
                            aux64 = [statistics[sim][64][mu][signal][round - 1] for signal in signals]
                            aux65 = [statistics[sim][65][mu][signal][round - 1] for signal in signals]
                            aux66 = [statistics[sim][66][mu][signal][round - 1] for signal in signals]
                            aux67 = [statistics[sim][67][mu][signal][round - 1] for signal in signals]
                            aux68 = [statistics[sim][68][mu][signal][round - 1] for signal in signals]
                            aux69 = [statistics[sim][69][mu][signal][round - 1] for signal in signals]
                            aux70 = [statistics[sim][70][mu][signal][round - 1] for signal in signals]
                            aux71 = [statistics[sim][71][mu][signal][round - 1] for signal in signals]
                            aux72 = [statistics[sim][72][mu][signal][round - 1] for signal in signals]
                            aux73 = [statistics[sim][73][mu][signal][round - 1] for signal in signals]
                            aux74 = [statistics[sim][74][mu][signal][round - 1] for signal in signals]
                            aux75 = [statistics[sim][75][mu][signal][round - 1] for signal in signals]
                            aux76 = [statistics[sim][76][mu][signal][round - 1] for signal in signals]
                            aux77 = [statistics[sim][77][mu][signal][round - 1] for signal in signals]
                            aux78 = [statistics[sim][78][mu][signal][round - 1] for signal in signals]
                            aux79 = [statistics[sim][79][mu][signal][round - 1] for signal in signals]
                            aux80 = [statistics[sim][80][mu][signal][round - 1] for signal in signals]
                            aux81 = [statistics[sim][81][mu][signal][round - 1] for signal in signals]
                            aux82 = [statistics[sim][82][mu][signal][round - 1] for signal in signals]
                            aux83 = [statistics[sim][83][mu][signal][round - 1] for signal in signals]
                            aux84 = [statistics[sim][84][mu][signal][round - 1] for signal in signals]
                            aux85 = [statistics[sim][85][mu][signal][round - 1] for signal in signals]
                            aux86 = [statistics[sim][86][mu][signal][round - 1] for signal in signals]
                            aux87 = [statistics[sim][87][mu][signal][round - 1] for signal in signals]
                            aux88 = [statistics[sim][88][mu][signal][round - 1] for signal in signals]
                            aux89 = [statistics[sim][89][mu][signal][round - 1] for signal in signals]
                            aux90 = [statistics[sim][90][mu][signal][round - 1] for signal in signals]
                            aux91 = [statistics[sim][91][mu][signal][round - 1] for signal in signals]
                            aux92 = [statistics[sim][92][mu][signal][round - 1] for signal in signals]
                            aux93 = [statistics[sim][93][mu][signal][round - 1] for signal in signals]
                            aux94 = [statistics[sim][94][mu][signal][round - 1] for signal in signals]
                            aux95 = [statistics[sim][95][mu][signal][round - 1] for signal in signals]
                            aux96 = [statistics[sim][96][mu][signal][round - 1] for signal in signals]
                            aux97 = [statistics[sim][97][mu][signal][round - 1] for signal in signals]
                            aux98 = [statistics[sim][98][mu][signal][round - 1] for signal in signals]
                            aux99 = [statistics[sim][99][mu][signal][round - 1] for signal in signals]
                            aux100 = [statistics[sim][100][mu][signal][round - 1] for signal in signals]

                            # Lista que contiene los sumatorios de cada tipo de senales producidas a nivel de la poblacion global en cada muestra y ronda
                            summation_pop = []
                            # Lista que contiene los sumatorios de cada tipo de senales producidas a nivel de subpoblacion en cada muestra y ronda
                            summation_subpop_1 = []
                            summation_subpop_2 = []

                            # Sumando las senales de cada tipo
                            for i in range(len(aux1)):
                                # A nivel de la poblacion
                                summation_pop.append(
                                    aux1[i] + aux2[i] + aux3[i] + aux4[i] + aux5[i] + aux6[i] + aux7[i] + aux8[i] +
                                    aux9[i] + aux10[i] +
                                    aux11[i] + aux12[i] + aux13[i] + aux14[i] + aux15[i] + aux16[i] + aux17[i] + aux18[
                                        i] + aux19[i] + aux20[i] +
                                    aux21[i] + aux22[i] + aux23[i] + aux24[i] + aux25[i] + aux26[i] + aux27[i] + aux28[
                                        i] + aux29[i] + aux30[i] +
                                    aux31[i] + aux32[i] + aux33[i] + aux34[i] + aux35[i] + aux36[i] + aux37[i] + aux38[
                                        i] + aux39[i] + aux40[i] +
                                    aux41[i] + aux42[i] + aux43[i] + aux44[i] + aux45[i] + aux46[i] + aux47[i] + aux48[
                                        i] + aux49[i] + aux50[i] +
                                    aux51[i] + aux52[i] + aux53[i] + aux54[i] + aux55[i] + aux56[i] + aux57[i] + aux58[
                                        i] + aux59[i] + aux60[i] +
                                    aux61[i] + aux62[i] + aux63[i] + aux64[i] + aux65[i] + aux66[i] + aux67[i] + aux68[
                                        i] + aux69[i] + aux70[i] +
                                    aux71[i] + aux72[i] + aux73[i] + aux74[i] + aux75[i] + aux76[i] + aux77[i] + aux78[
                                        i] + aux79[i] + aux80[i] +
                                    aux81[i] + aux82[i] + aux83[i] + aux84[i] + aux85[i] + aux86[i] + aux87[i] + aux88[
                                        i] + aux89[i] + aux90[i] +
                                    aux91[i] + aux92[i] + aux93[i] + aux94[i] + aux95[i] + aux96[i] + aux97[i] + aux98[
                                        i] + aux99[i] + aux100[i])

                            writer.writerow([sim + 1, mu + 1, agent, menLen, round, condition, samples[mu]['cont'],
                                             samples[mu]['coord'],
                                             samples[mu]['mut']] + aux + [summation_pop] + [entropy(summation_pop)] + [
                                                entropy(summation_subpop_1)] + [entropy(summation_subpop_2)] + [
                                                summation_subpop_1] + [summation_subpop_2]
                                            + [brillouin_d(summation_pop)] + [margalef(summation_pop)] + [
                                                simpson(summation_pop)] + [simpson_e(summation_pop)] + [
                                                observed_otus(summation_pop) / 100])
if __name__ == '__main__':
    main()

