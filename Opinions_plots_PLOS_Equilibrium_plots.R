### Opinion categories at equilibrium

library(stringr)
library(tidyverse)

#Data instantiation (from Opinions_plots_PLOS.R)

OUT <- data

#SELCTING CONTENT BIAS LEVEL
data <- subset(data,Content_bias==0 | Content_bias==0.2 | Content_bias==0.4 | Content_bias==0.6 | Content_bias==0.8 | Content_bias==1)
#data <- subset(data,Content_bias==0 | Content_bias==0.5 | Content_bias==1)



#########INVERTIR DATOS EN COLUMNAS IMPARES PARA QUE EL EJE R - L SEA REALISTA ##############

inverted_data<-data
#inverted_data<-subset(inverted_data,Round==100 | Round==99)
inverted_data %>%
  mutate(pop_invertida = str_remove_all(Population_signals, "\\[|\\]") %>%
           str_split(., ", ") %>%
           map( ~ .x[length(.x):1]) %>%  #Uso el índice para cambiar el orden. Debería funcionar para no numéricos.
           map_chr( ~ paste0(.x, collapse = ", ")) %>%
           paste0("[", ., "]")  #Fin tubería interna
  ) %>%  
  mutate(Population_signals = ifelse(1:n() %% 2 == 0, 
                                     pop_invertida,   #Si es impar uso la columna revertida
                                     Population_signals)) ->inverted_data

#Remove old Population signals
#inverted_data <- subset (inverted_data, select = -Population_signals)
#Rename pop_invertida to Population_signals
#names(inverted_data)[names(inverted_data) == 'pop_invertida'] <- 'Population_signals'
#Assign inverted_data to OUT
OUT<-inverted_data


######ASIGNACIÓN DE CADA UNA DE LAS CATEGORÍAS D, E, I, M, P SEGÚN EL NIVEL DE CONSENSO EN POPULATION SIGNALS

numeros<-data.frame(str_extract_all(OUT$Population_signals,"\\d+",simplify=TRUE),stringsAsFactors = FALSE)


#Cambiamos los valores vacios para NA
names(numeros)<-paste("columna",seq(1:10),sep="_")

#Creamos una columna donde agregaremos las etiquetas
numero_limpio[["Etiqueta"]]<-""

#Convertimos los valores a numericos
numeros_l<-map_df(numeros,as.numeric)

## 100 AGENTS. ASSIGNING ESTATUS AT EQUILIBRIUM (EXTREME CONSENSUS, MODERATE CONSENSUS, POLARIZATION, DIVERSITY, INDETERMINATION)

# numeros_l[["Estatus"]]<-apply(numeros_l,1,function(x){
#   if((sum(x>=85)==1) & (sum(x[1:2]>=85)==1 | sum(x[9:10]>=85)==1)){print("E")
#     
#   }else if((sum(x>=90)==1)){print("M")
#     
#     #}else if((sum(x>=45)==2)){print("P")
#     #}else if((sum(x[1:2]>=20)==1 & sum(x[9:10]>=20)==1)){print("P")
#   }else if((sum(x[1:2]>=23) & sum(x[9:10]>=23))){print("P")
#     
#   }else if((sum(x>10)>=4)){print("D")
#     #}else if((sum(x>10)>=3)){print("D")
#     
#   }else{print("I")}})  
# 
# OUT<-cbind(OUT,numeros_l[,11])  

## 10 AGENTS. ASSIGNING ESTATUS AT EQUILIBRIUM (EXTREME CONSENSUS, MODERATE CONSENSUS, POLARIZATION, DIVERSITY, INDETERMINATION)

numeros_l[["Estatus"]]<-apply(numeros_l,1,function(x){
  if((sum(x>=9)==1) & (sum(x[1:2]>=9)==1 | sum(x[9:10]>=9)==1)){print("E")
    
  }else if((sum(x>=9)==1)){print("M")
    
    #}else if((sum(x>=45)==2)){print("P")
    #}else if((sum(x[1:2]>=20)==1 & sum(x[9:10]>=20)==1)){print("P")
  }else if((sum(x[1:2]>=2) & sum(x[9:10]>=2))){print("P")
    
  }else if((sum(x>=1)>=3)){print("D")
    #}else if((sum(x>10)>=3)){print("D")
    
  }else{print("I")}})  

OUT<-cbind(OUT,numeros_l[,11]) 

####################################################
####################################################
#####FREQUENCY (PROPORTION) OF EACH TYPE OF OPINION EQUILIBRIUM BY CONDITION AFTER 2000 SIMULATIONS

OUT <- subset(OUT,Content_bias==0 | Content_bias==0.2 | Content_bias==0.4 | Content_bias==0.6 | Content_bias==0.8 | Content_bias==1)
OUT$Institution = factor(OUT$Institution, levels = c("In", "Im", "Is"))
OUT$Value_system = factor(OUT$Value_system, levels = c("RAND", "COMP", "OTA"))
OUT$Estatus = factor(OUT$Estatus, levels = c("D", "P", "M", "E","I"))

ggplot(OUT) +
  aes(x = Pop_hom , fill = factor(Estatus)) +
  geom_bar(position = "fill", width=0.8)+
  facet_grid(Institution*Value_system~Content_bias, scales = "free")+
  theme_classic()+
  theme(legend.position="right", legend.text=element_text(size=20), legend.title=element_text(size=18))+
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=18))+
  theme(strip.text.x = element_text(size = 18),
        strip.text.y = element_text(size = 18))+
  theme(axis.text.x = element_text(angle = 70, hjust=1))+
  scale_y_continuous(breaks = seq(0,1, by=0.5), limits=c(0,1))

######################################
###### MEAN FREQUENCY OF OPINIONS IN EACH TYPE OF OPINION EQUILIBRIUM BY CONDITION AFTER 2000 SIMULATIONS
library(dplyr)
OUT_B <- OUT
OUT_B <- sample_n(OUT_B,400000)
OUT_B$Institution = factor(OUT_B$Institution, levels = c("In", "Im", "Is"))
OUT_B$Value_system = factor(OUT_B$Value_system, levels = c("RAND", "COMP", "OTA"))


OUT_B %>%
  mutate(Population_signals= gsub('\\]|\\[','', Population_signals)) %>% 
  separate(Population_signals, into = c("S1", "S2", "S3", "S4","S5","S6", "S7", "S8", "S9","S10"), sep=",", convert=TRUE) ->OUT_B

#OUT_B <- subset(OUT_B, select=c("Population_signals", "Institution", "Estatus", "Value_system"))

#Agregamos una columna para agrupar los datos
OUT_B[["Identificador"]]<-c(1:nrow(OUT_B))


#Tranformamos la tabla para poderla usar facilmente con ggplot
datos_ordenados<-OUT_B %>% pivot_longer(cols=starts_with("S"),names_to="Columna_S")

#generamos el orden en el que aparecen los datos
datos_ordenados$Columna_S<- factor(datos_ordenados$Columna_S, levels = 
                                     c("S1","S2", "S3","S4","S5","S6","S7","S8","S9","S10"))


#geom_line
na.omit(datos_ordenados) %>% 
  filter(!is.na(Columna_S)) %>%
  ggplot(aes(x=Columna_S,y=value/10,colour=Estatus)) +
  #geom_point(size=0.1)+
  stat_summary(aes(group=Estatus),fun=mean,geom="line") +
  scale_y_continuous(breaks = seq(0,1, by=0.2))+
  coord_cartesian(
    ylim = c(0,0.6))+
  scale_x_discrete(labels = c("S1" = "L", "S2" =  "", "S3" = "", "S4" = "", "S5" = "", "S6" =  "", "S7" = "", "S8" = "", "S9" = "", "S10" = "R") )+
  theme_classic()+
  facet_grid(Institution*Value_system~Estatus, scales = "free")+
  labs(x = "Opinion spectrum", y = "Mean frequency")+
  guides(fill=guide_legend(title="Equilibrium"))
  











