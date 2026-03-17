# Adult-Mortality
Análise dos determinantes da mortalidade adulta nas microrregiões brasileiras (2010) utilizando algoritmos de Machine Learning (Random Forest, XGBoost, SVM e Naive Bayes)

Este repositório contém os códigos e a metodologia aplicados na dissertação de mestrado de Natália Martins Arruda (PPG-Demografia/UNICAMP). O objetivo central do estudo foi investigar as relações entre fatores socioeconômicos, estruturais, contextuais e de saúde com a probabilidade de morte adulta (15 a 60 anos) no Brasil.

Destaques Técnicos:
    Correção de Dados: Utilização do método TOPALS com estimação bayesiana para correção de sub-registros de óbitos em pequenas áreas (microrregiões).
    Modelagem Supervisionada: Comparação de performance entre quatro algoritmos:
      Random Forest.
      Extreme Gradient Boosting (XGBoost/Extreme Boosted Trees).
      Support Vector Machine (SVM).
      Naive Bayes.
    Análise Exploratória: Implementação de técnicas como ACP (Análise de Componentes Principais), t-SNE e K-Means para entender a interação entre as variáveis preditoras.
    Principais Descobertas:As variáveis com maior poder preditivo para a mortalidade adulta identificadas pelos modelos foram:
            Taxas de mortalidade por causas externas.
            Taxa de desemprego.
            Cobertura de vacinação.
Ferramentas Utilizadas:
        R/RStudio: Linguagem original da pesquisa (pacotes caret, tidyverse, randomForest, etc.).
        Python: Tradução dos modelos para fins de portabilidade.
