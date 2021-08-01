library(dplyr)
library(ggplot2)
library(scales)
library(RColorBrewer)
library(stringr)

#### Diversity of opinions by round ###############

#### VALUE SYSTEMS AGGREGATION DATAFRAMES ########
##################################################
##################################################

#### 10 AGENTS ######

#### Dataframes for OTA

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_OTA_0_III_i.csv", header=TRUE, sep=',')
h1['Value_system']='OTA'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_OTA_W_III_i.csv", header=TRUE, sep=',')
l1['Value_system']='OTA'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_OTA_R_III_i.csv", header=TRUE, sep=',')
e1['Value_system']='OTA'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_OTA_0_III_i.csv", header=TRUE, sep=',')
h2['Value_system']='OTA'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_OTA_W_III_i.csv", header=TRUE, sep=',')
l2['Value_system']='OTA'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_OTA_R_III_i.csv", header=TRUE, sep=',')
e2['Value_system']='OTA'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_OTA <- data

#### Dataframes for COMPETITION

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_C_0_III_i.csv", header=TRUE, sep=',')
h1['Value_system']='COMP'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_C_W_III_i.csv", header=TRUE, sep=',')
l1['Value_system']='COMP'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_C_R_III_i.csv", header=TRUE, sep=',')
e1['Value_system']='COMP'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_C_0_III_i.csv", header=TRUE, sep=',')
h2['Value_system']='COMP'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_C_W_III_i.csv", header=TRUE, sep=',')
l2['Value_system']='COMP'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_C_R_III_i.csv", header=TRUE, sep=',')
e2['Value_system']='COMP'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_C <- data

#### Dataframes for RANDOM INITIAL VALUE SYSTEMS

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_PR_0_III_i.csv", header=TRUE, sep=',')
h1['Value_system']='RAND'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_PR_W_III_i.csv", header=TRUE, sep=',')
l1['Value_system']='RAND'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_heterogeneity_PR_R_III_i.csv", header=TRUE, sep=',')
e1['Value_system']='RAND'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_PR_0_III_i.csv", header=TRUE, sep=',')
h2['Value_system']='RAND'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_PR_W_III_i.csv", header=TRUE, sep=',')
l2['Value_system']='RAND'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\100_homogeneity_PR_R_III_i.csv", header=TRUE, sep=',')
e2['Value_system']='RAND'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'


# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_R <- data

#### VALUE SYSTEMS AGGREGATION DATAFRAMES ########
##################################################
##################################################

#### 100 AGENTS ######

#### Dataframes for OTA

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_OTA_0_III_100.csv", header=TRUE, sep=';')
h1<-subset(h1,Agent==1)
h1['Value_system']='OTA'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_OTA_W_III_100.csv", header=TRUE, sep=';')
l1<-subset(l1,Agent==1)
l1['Value_system']='OTA'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_OTA_R_III_100.csv", header=TRUE, sep=';')
e1<-subset(e1,Agent==1)
e1['Value_system']='OTA'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_OTA_0_III_100.csv", header=TRUE, sep=';')
h2<-subset(h2,Agent==1)
h2['Value_system']='OTA'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_OTA_W_III_100.csv", header=TRUE, sep=';')
l2<-subset(l2,Agent==1)
l2['Value_system']='OTA'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_OTA_R_III_100.csv", header=TRUE, sep=';')
e2<-subset(e2,Agent==1)
e2['Value_system']='OTA'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_OTA <- data

#### Dataframes for COMPETITION

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_C_0_III_100.csv", header=TRUE, sep=';')
h1<-subset(h1,Agent==1)
h1['Value_system']='COMP'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_C_W_III_100.csv", header=TRUE, sep=';')
l1<-subset(l1,Agent==1)
l1['Value_system']='COMP'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_C_R_III_100.csv", header=TRUE, sep=';')
e1<-subset(e1,Agent==1)
e1['Value_system']='COMP'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_C_0_III_100.csv", header=TRUE, sep=';')
h2<-subset(h2,Agent==1)
h2['Value_system']='COMP'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_C_W_III_100.csv", header=TRUE, sep=';')
l2<-subset(l2,Agent==1)
l2['Value_system']='COMP'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_C_R_III_100.csv", header=TRUE, sep=';')
e2<-subset(e2,Agent==1)
e2['Value_system']='COMP'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_C <- data

#### Dataframes for RANDOM INITIAL VALUE SYSTEMS

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_PR_0_III_100.csv", header=TRUE, sep=';')
h1<-subset(h1,Agent==1)
h1['Value_system']='RAND'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_PR_W_III_100.csv", header=TRUE, sep=';')
l1<-subset(l1,Agent==1)
l1['Value_system']='RAND'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\heterogeneity_PR_R_III_100.csv", header=TRUE, sep=';')
e1<-subset(e1,Agent==1)
e1['Value_system']='RAND'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_PR_0_III_100.csv", header=TRUE, sep=';')
h2<-subset(h2,Agent==1)
h2['Value_system']='RAND'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_PR_W_III_100.csv", header=TRUE, sep=';')
l2<-subset(l2,Agent==1)
l2['Value_system']='RAND'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\homogeneity_PR_R_III_100.csv", header=TRUE, sep=';')
e2<-subset(e2,Agent==1)
e2['Value_system']='RAND'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'


# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_R <- data


#### ACTUAL PRODUCTIONS DATAFRAMES ###############
##################################################
##################################################

##### 10 AGENTS ######

#### Dataframes for OTA

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_OTA_In.csv", header=TRUE, sep=',')
h1['Value_system']='OTA'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_OTA_Im.csv", header=TRUE, sep=',')
l1['Value_system']='OTA'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_OTA_Is.csv", header=TRUE, sep=',')
e1['Value_system']='OTA'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_OTA_In.csv", header=TRUE, sep=',')
h2['Value_system']='OTA'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_OTA_Im.csv", header=TRUE, sep=',')
l2['Value_system']='OTA'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_OTA_Is.csv", header=TRUE, sep=',')
e2['Value_system']='OTA'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'


data_OTA <- data

#### Dataframes for COMPETITION

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_C_In.csv", header=TRUE, sep=',')
h1['Value_system']='COMP'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_C_Im.csv", header=TRUE, sep=',')
l1['Value_system']='COMP'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_C_Is.csv", header=TRUE, sep=',')
e1['Value_system']='COMP'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_C_In.csv", header=TRUE, sep=',')
h2['Value_system']='COMP'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_C_Im.csv", header=TRUE, sep=',')
l2['Value_system']='COMP'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_C_Is.csv", header=TRUE, sep=',')
e2['Value_system']='COMP'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_C <- data

#### Dataframes for RANDOM INITIAL VALUE SYSTEMS

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_R_In.csv", header=TRUE, sep=',')
h1['Value_system']='RAND'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_R_Im.csv", header=TRUE, sep=',')
l1['Value_system']='RAND'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_heterogeneity_R_Is.csv", header=TRUE, sep=',')
e1['Value_system']='RAND'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_R_In.csv", header=TRUE, sep=',')
h2['Value_system']='RAND'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_R_Im.csv", header=TRUE, sep=',')
l2['Value_system']='RAND'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_homogeneity_R_Is.csv", header=TRUE, sep=',')
e2['Value_system']='RAND'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_R <- data

#### ACTUAL PRODUCTIONS DATAFRAMES ###############
##################################################
##################################################

#### 100 AGENTS ######

#### Dataframes for OTA

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_OTA_In.csv", header=TRUE, sep=',')
h1['Value_system']='OTA'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_OTA_Im.csv", header=TRUE, sep=',')
l1['Value_system']='OTA'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_OTA_Is.csv", header=TRUE, sep=',')
e1['Value_system']='OTA'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_OTA_In.csv", header=TRUE, sep=',')
h2['Value_system']='OTA'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_OTA_Im.csv", header=TRUE, sep=',')
l2['Value_system']='OTA'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_OTA_Is.csv", header=TRUE, sep=',')
e2['Value_system']='OTA'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom", "Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'


data_OTA <- data

#### Dataframes for COMPETITION

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_C_In.csv", header=TRUE, sep=',')
h1['Value_system']='COMP'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_C_Im.csv", header=TRUE, sep=',')
l1['Value_system']='COMP'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_C_Is.csv", header=TRUE, sep=',')
e1['Value_system']='COMP'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_C_In.csv", header=TRUE, sep=',')
h2['Value_system']='COMP'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_C_Im.csv", header=TRUE, sep=',')
l2['Value_system']='COMP'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_C_Is.csv", header=TRUE, sep=',')
e2['Value_system']='COMP'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_C <- data

#### Dataframes for RANDOM INITIAL VALUE SYSTEMS

h1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_R_In.csv", header=TRUE, sep=',')
h1['Value_system']='RAND'
h1['Pop_hom']='heterogeneity'
h1['Institution']='In'

l1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_R_Im.csv", header=TRUE, sep=',')
l1['Value_system']='RAND'
l1['Pop_hom']='heterogeneity'
l1['Institution']='Im'

e1 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_heterogeneity_R_Is.csv", header=TRUE, sep=',')
e1['Value_system']='RAND'
e1['Pop_hom']='heterogeneity'
e1['Institution']='Is'

h2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_R_In.csv", header=TRUE, sep=',')
h2['Value_system']='RAND'
h2['Pop_hom']='homogeneity'
h2['Institution']='In'

l2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_R_Im.csv", header=TRUE, sep=',')
l2['Value_system']='RAND'
l2['Pop_hom']='homogeneity'
l2['Institution']='Im'

e2 <- read.csv("C:\\Users\\Jose\\Documents\\PyCharmProjects\\Model\\Fixed_institutions_model\\PRep_100agents_homogeneity_R_Is.csv", header=TRUE, sep=',')
e2['Value_system']='RAND'
e2['Pop_hom']='homogeneity'
e2['Institution']='Is'

# h1 <- subset(h1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l1 <- subset(l1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e1 <- subset(e1, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# h2 <- subset(h2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# l2 <- subset(l2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))
# e2 <- subset(e2, select=c("Generation", "Condition", "Content.bias", "Simpson_e_population", "Entropy_population", "Value_system", "Pop_hom","Institution"))

ps <- merge(h1, l1, all = TRUE)
ps <- merge(ps, h2, all = TRUE)
ps <- merge(ps, l2, all = TRUE)
ps <- merge(ps, e1, all = TRUE)
ps <- merge(ps, e2, all = TRUE)

data <- data.frame(ps$Generation, ps$Condition, ps$Entropy_population, ps$Content.bias, ps$Simpson_e_population, ps$Value_system, ps$Pop_hom, ps$Institution, ps$Population.signals)
names(data)[names(data) == 'ps.Generation'] <- 'Round'
names(data)[names(data) == 'ps.Condition'] <- 'Condition'
names(data)[names(data) == 'ps.Entropy_population'] <- 'Entropy_population'
names(data)[names(data) == 'ps.Content.bias'] <- 'Content_bias'
names(data)[names(data) == 'ps.Simpson_e_population'] <- 'Simpson_e_population'
names(data)[names(data) == 'ps.Value_system'] <- 'Value_system'
names(data)[names(data) == 'ps.Pop_hom'] <- 'Pop_hom'
names(data)[names(data) == 'ps.Institution'] <- 'Institution'
names(data)[names(data) == 'ps.Population.signals'] <- 'Population_signals'

data_R <- data

###MERGING DATAFRAMES
rm(data)

data <- merge(data_OTA, data_C, all = TRUE)
data <- merge(data, data_R, all = TRUE)


#SELECTING LEVELS OF CONTENT BIAS
data <- subset(data,Content_bias==0 | Content_bias==0.2 | Content_bias==0.4 | Content_bias==0.6 | Content_bias==0.8 | Content_bias==1)
#data <- subset(data,Content_bias==0 | Content_bias==0.5 | Content_bias==1)


###LOADING VARIABLES
y <- data$Entropy_population
ymax <- max(y, na.rm = TRUE)
z <- data$Value_system
Value_system = factor(z, levels = c("OTA", "COMP", "RAND"))
k <- data$Pop_hom
Pop_hom = factor(k, levels = c("homogeneity", "heterogeneity"))
j <- data$Institution
Institutional_influence = factor(j, levels = c("In", "Im", "Is"))
g <- data$Round
Content_bias <- data$Content_bias

data <- data.frame(y,Value_system,Pop_hom, Institutional_influence, g,Content_bias)

#Seleccionamos colores
colores<-brewer.pal(n = 11, name = "Spectral")[c(9,11,1)]

#Preparamos los datos
# data %>%
#   group_by(Value_system,Pop_hom, Institutional_influence, g,Content_bias) %>%
#   summarise(media = mean(y),
#             #Tube que simular la desvio sd() arrojaba NaN
#             desvio = rnorm(1),
#             error_est = desvio / sqrt(n()),
#             intervalo_sup = media + (2*error_est),
#             intervalo_inf = media - (2*error_est))%>%
# 
#   #Hacemos el grafico
#   ggplot(aes(x = g, y = media/ymax, color = Institutional_influence)) +
#   geom_line(size=0.2)+
#   scale_color_manual(values=colores) +
#   scale_x_continuous(breaks = seq(0,100, by=25), limits=c(0,100)) +
#   scale_y_continuous(breaks = seq(0,1, by=0.25), limits=c(0,1)) +
#   labs(x = "Round", y = expression('Normalised entropy '*' (H'[n]*')')) +
#   theme_classic()+
#   theme(legend.position="bottom", legend.text=element_text(size=20), legend.title=element_text(size=20))+
#   theme(axis.text=element_text(size=20),
#         axis.title=element_text(size=20))+
#   facet_grid(Pop_hom*Value_system~Content_bias)+
#   theme(strip.text.x = element_text(size = 20))


########################################################
########################################################
####ALTERNATIVE PLOT DASHED LINES
#Preparamos los datos
data %>%
  group_by(Value_system,Pop_hom, Institutional_influence, g,Content_bias) %>%
  summarise(media = mean(y),
            #Tube que simular la desvio sd() arrojaba NaN
            desvio = rnorm(1),
            error_est = desvio / sqrt(n()),
            intervalo_sup = media + (2*error_est),
            intervalo_inf = media - (2*error_est))%>%
  #Hacemos el grafico
  
  ggplot(aes(x = g, y = media/ymax, color = Institutional_influence)) +
  geom_line(aes(linetype=Pop_hom, color=Institutional_influence),size=0.2)+
  # geom_errorbar(aes(x = g, color = Condicion,
  #                    ymax = intervalo_sup,               
  #                    ymin = intervalo_inf),
  #               width=0.3)+
  scale_linetype_manual(values=c("solid", "dashed")) +
  scale_color_manual(values=colores) +
  scale_x_continuous(breaks = seq(0,100, by=25), limits=c(0,100)) +
  scale_y_continuous(breaks = seq(0,1, by=0.25), limits=c(0,1)) +
  labs(x = "Round", y = expression('Normalised entropy '*' (H'[n]*')')) +
  theme_classic()+
  theme(legend.position="bottom", legend.text=element_text(size=20), legend.title=element_text(size=20))+
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=20))+
  facet_wrap(Value_system~Content_bias)+
  theme(strip.text.x = element_text(size = 20),strip.text.y = element_text(size = 20) )+
  # Modifica el titulo de las leyendas
  guides(color=guide_legend("Institutional influence", ncol=1, order=1),
         linetype=guide_legend("Population condition", ncol=1)) +
  facer_grid(Value_system~Content_bias)







  #facet_grid(Value_system~.)->plot_2

plot_2

#Combined plot for 100 agents
library(ggpubr)
ggarrange(plot_1, plot_2, 
          labels = c("A", "B"),
          ncol = 2, nrow = 1,
          common.legend = TRUE, legend = "bottom")



























