# Adult-Mortality
Análise dos determinantes da mortalidade adulta nas microrregiões brasileiras (2010) utilizando algoritmos de Machine Learning (Random Forest, XGBoost, SVM e Naive Bayes)

Este repositório contém os códigos e a metodologia aplicados na dissertação de mestrado de Natália Martins Arruda (PPG-Demografia/UNICAMP). O objetivo central do estudo foi investigar as relações entre fatores socioeconômicos, estruturais, contextuais e de saúde com a probabilidade de morte adulta (15 a 60 anos) no Brasil.

# Destaques Técnicos:
    - Correção de Dados: Utilização do método TOPALS com estimação bayesiana para correção de sub-registros de óbitos em pequenas áreas (microrregiões).
    - Modelagem Supervisionada: Comparação de performance entre quatro algoritmos:
      Random Forest.
      Extreme Gradient Boosting (XGBoost/Extreme Boosted Trees).
      Support Vector Machine (SVM).
      Naive Bayes.
    Análise Exploratória: Implementação de técnicas como ACP (Análise de Componentes Principais), t-SNE e K-Means para entender a interação entre as variáveis preditoras.
    Principais Descobertas:As variáveis com maior poder preditivo para a mortalidade adulta identificadas pelos modelos foram:
            Taxas de mortalidade por causas externas.
            Taxa de desemprego.
            Cobertura de vacinação.
# Ferramentas Utilizadas:
        R/RStudio: Linguagem original da pesquisa (pacotes caret, tidyverse, randomForest, etc.).
        Python: Tradução dos modelos para fins de portabilidade.

        # Determinantes da Mortalidade Adulta nas Microrregiões Brasileiras (2010)

Este projeto é baseado na dissertação de mestrado de **Natália Martins Arruda** (UNICAMP, 2019), que utiliza modelos de **Machine Learning** para investigar os fatores socioeconômicos e de saúde que influenciam a probabilidade de morte adulta (15 a 60 anos) no Brasil.

## 📌 Resumo do Projeto
O objetivo central foi identificar quais fatores mais impactam a mortalidade adulta em nível de microrregiões. Foram utilizados dados do Censo 2010 e do DATASUS, com correção de sub-registros via método TOPALS.

### Principais Variáveis Preditoras:
* Taxas de mortalidade por causas externas.
* Taxa de desemprego.
* Cobertura de vacinação.

## 🛠️ Modelos Utilizados
Foram comparados quatro algoritmos de aprendizado supervisionado:
1. **Support Vector Machine (SVM)** - Apresentou o melhor desempenho geral.
2. **Random Forest (RF)**.
3. **Extreme Gradient Boosting (XGBoost)**.
4. **Naive Bayes (NB)**.

## 🚀 Como Executar
O projeto contém implementações em **R** (original) e **Python** (tradução).

### Python
```bash
pip install -r requirements.txt
python src/model_python.py
