## Rotina com as funções utilizadas na Seção 3.1.1: 
# - ACP
# - t-SNE
# - K-Means
#### Pacotes utilizados ####
library(caret); library(tidyverse); library(data.table); library(pROC); library(ROCR);
library(klaR); library(corrplot); library(e1071); library(readxl); library(hydroGOF);
library(lattice); library(psych); library(reshape); library(rpart.plot); library(rpart);
library(MLmetrics); library(ggRandomForests); library(dplyr); library(mclust);
library(gbm); library(ipred); library(randomForest); library(Rtsne); library(FactoMineR)
library(pdp); library(ALEPlot)
################################## ACP #########################
# Análise de Componentes Principais
### função ACP ###
res.pca <- PCA(banco[3:23], graph = FALSE, scale.unit = TRUE) #gerando ACP
eig.val <- get_eigenvalue(res.pca) ### eigenvalues (autovalores)
data_eig<-as.matrix(res.pca$eig)
var <- get_pca_var(res.pca) #### Principal Component Analysis Results for variables
## Gráfico 7 – Porcentagem da variância total explicada por cada componente
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
## Gráfico 8 – Contribuição das variáveis para cada componente principal
# Contributions of variables to PC1
dim1<-fviz_contrib(res.pca, choice = "var", axes = 1, top = 15)+ggtitle("A) Componen
te Principal 1")+
ylab("Contribuições (%)")+theme(axis.text=element_text(size=9))
# Contributions of variables to PC2
dim2<-fviz_contrib(res.pca, choice = "var", axes = 2, top = 15)+ggtitle("B) Componen
te Principal 2")+ ylab("Contribuições (%)")+theme(axis.text=element_text(size=9))
# Contributions of variables to PC3
dim3<-fviz_contrib(res.pca, choice = "var", axes = 3, top = 15)+ggtitle("C) Componen
te Principal 3")+ylab("Contribuições (%)")+theme(axis.text=element_text(size=9))
# Contributions of variables to PC4
dim4<-fviz_contrib(res.pca, choice = "var", axes = 4, top = 15)+ggtitle("D) Componen
te Principal 4")+ylab("Contribuições (%)")+theme(axis.text=element_text(size=9))
################################## t-SNE #############################
data <- read.table ("(Corrigido)Banco_ML.csv", header = T ,sep=';', dec=',')
data_filter <- dplyr::select(banco,-cod, -qx) #Retirar variavel de codigo para o t-SNE
#Padronizar(calcular o z escore para todas as variaveis)
quantis_scale<- as.data.frame(scale(data_filter))
106
qx<-banco$qx
cod<-banco$cod
data <- cbind(cod, qx, quantis_scale)
tsne<- Rtsne(data[3:23], dims=2, theta=0.5, perplexity=100, iterations=100000, learning=
10000) ## algoritmo t-SNE
plot(tsne$Y, t='n', main="tSNE", xlab="Dimensão 1", ylab="Dimensão 2", "cex.main"=2,
"cex.lab"=1.5)
points(tsne$Y) ## coordenadas criadas pelo t-SNE
#### função para K-means usando as coordenadas criadas pelo algoritmo t-SNE
d_tsne_1 = as.data.frame(tsne$Y)
d_tsne_1_original=d_tsne_1
fit_cluster_kmeans=kmeans(scale(d_tsne_1), 2)
d_tsne_1_original$cl_kmeans = factor(fit_cluster_kmeans$cluster)
plot_cluster=function(data, var_cluster, palette)
{
ggplot(data, aes_string(x="V1", y="V2", color=var_cluster)) +
geom_point(size=2, show.legend = TRUE) +
guides(colour=guide_legend(override.aes=list(size=6))) +
xlab("") + ylab("") +
ggtitle("") +
theme_light(base_size=20) +
theme(axis.text.x=element_blank(),
axis.text.y=element_blank(),
legend.direction = "horizontal",
legend.position = "bottom",
legend.box = "horizontal") +
scale_colour_brewer(palette = palette)
}
## Gráfico 9 – Divisão dos dados em dois grupos, K= 2 usando K-Means
plot_k=plot_cluster(d_tsne_1_original, "cl_kmeans", "Accent")
######## Rotina com as funções usadas na Seção 3.2: - Random Forest
# - Extreme Boosted Trees
# - Naive Bayes
# - Support Vector Machine
########################## PRÉ-PROCESSAMENTO ########################
#Treinamento de modelos preditivos
##Tecnica de reamostragem (para evitar sobreajuste)
#to obtain different performance measures (accuracy, Kappa, area under ROC curve, s
ensitivity, specificity)
fiveStats <- function(...)c(twoClassSummary(...),defaultSummary(...),prSummary(...),m

nLogLoss(...))
#função controle usada para os quatro algoritmos
set.seed(123)
ctrl<- trainControl(method = "cv", #validação cruzada 10 subamostras
number = 10, #número de subamostras
savePredictions = TRUE, # salva as informações da reamostragem
classProbs = TRUE, #calcula a prob de cada classe
summaryFunction = fiveStats, #sumariza as informações
verboseIter = TRUE) #A logical for printing a training log
############################ 1. RANDOM FOREST ########################
#objeto (rfqx) com a função gerada para o método Random Forest (method=”rf”)
rfqx <- train(qx ~
., data=banco,
method="rf",
trControl=ctrl,
ntree=1000,
preProc=c("center", "scale"),
metric="ROC",
importance=T, proximity = TRUE)
rfqxPred<-as.data.frame(rfqx$pred[,1:2]) #cria como data frame os valores preditos e
observados usando k-fold cross validation
### calculca matriz de confusão e principais medidas de desempenho
confMatRF <- confusionMatrix(rfqxPred$pred, rfqxPred$obs, mode="prec_recall")
## Gráfico de Importância para o modelo Random Forest
varimp_RF<-varImp(rfqx, scale=TRUE)
plot(varimp_RF, top=20,scales=list(y=list(cex=.95)))
################ 2. EXTREME BOOSTED GRADIENT TREES ###############
#objeto (xgbqx) com a função gerada para o método XBG (method=”xgbTree”)
set.seed(134)
xgbqx <- train(qx ~
., data=banco,
method="xgbTree",
trControl=ctrl,
preProcess=c("center","scale"),
metric="ROC", plot=TRUE,importance=TRUE)
plot(xgbqx)
boosted<-xgbqx$finalModel$params
xgb.plot.tree(model = xgbqx$finalModel, trees = 0:10)
xgbqxPred<-as.data.frame(xgbqx$pred[,1:2]) #create as data frame the observed and p
redicted values
### calcula matriz de confusão e principais medidas de desempenho

confMatXGB <- confusionMatrix(xgbqxPred$pred, xgbqxPred$obs,mode = "prec_recall")
## Gráfico de Importância para o modelo XGB
varimp_XGB<-varImp(xgbqx, scale=FALSE)
plot(varimp_XGB, top=20)
############################ 3. NAIVE BAYES ###########################
#objeto (NBqx) com a função gerada para o método NB (method=”naive_bayes”)
set.seed(134)
NBqx <- train(qx ~
., data=banco,
method="naive_bayes",
trControl=ctrl,
preProcess=c("center","scale"),
metric="ROC",
importance=TRUE)
plot.train(NBqx)
NBqxPred<-as.data.frame(NBqx$pred[,1:2]) #cria como data frame os valores preditos
e observados usando k-fold cross validation
### calculca matriz de confusão e principais medidas de desempenho
confMatNB <- confusionMatrix(NBqxPred$pred, NBqxPred$obs,mode = "prec_recall")
## Gráfico de Importância para o modelo NB
varimp_NB<-varImp(NBqx, scale=TRUE)
plot(varimp_NB, top=21)
##################### 4. SUPPORT VECTOR MACHINE ################
library(kernlab)
set.seed(202)
sigmaRangeReduced <- sigest(as.matrix(banco[2:22]))
svmRGridReduced <- expand.grid(.sigma = sigmaRangeReduced[1],
.C = 2^(seq(-4, 4)))
set.seed(476)
svmRModel <- train(qx ~., banco,
method = "svmRadial",
metric = "ROC",
preProc = c("center", "scale"),
tune = svmRGridReduced,
fit = FALSE,
trControl = ctrl)

svmPred<-as.data.frame(svmRModel$pred[,1:2]) #cria como data frame os valores pre
ditos e observados usando k-fold cross validation
### calculca matriz de confusão e principais medidas de desempenho
confMatSVM <- confusionMatrix(svmPred$pred, svmPred$obs, mode = "prec_recall")
## Gráfico de Importância para o modelo SVM
varimp_SVM<-varImp(svmRModel, scale=TRUE)
plot(varimp_SVM, top=20)
########### GRÁFICOS COMPARAÇÃO - REAMOSTRAGEM ##############
resamp <- resamples(list(RF = rfqx,
SVM = svmRModel,
XGB = xgbqx,
NB = NBqx))
summary(resamp)
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 2
trellis.par.set(theme1)
bwplot(resamp, layout = c(5, 1))
splom(resamp)
