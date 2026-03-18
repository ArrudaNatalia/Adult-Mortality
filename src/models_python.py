

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score, KFold
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score, classification_report

# 1. Carregamento dos dados (ajuste o nome do arquivo conforme necessário)
df = pd.read_csv('Banco_ML.csv', sep=';', decimal=',')

# 2. Pré-processamento [cite: 121, 128]
# Criando a variável alvo binária (P0 e P50) baseada na média (0.1406)
df['target'] = np.where(df['qx'] < 0.1406, 0, 1)

# Seleção de variáveis preditoras (excluindo IDs e o desfecho contínuo)
X = df.drop(columns=['cod', 'qx', 'target'])
y = df['target']

# Padronização (Média 0 e Variância 1) [cite: 124, 125]
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 3. Modelagem e Validação Cruzada (k=10) [cite: 141]
models = {
    "Random Forest": RandomForestClassifier(n_estimators=100),
    "XGBoost": XGBClassifier(use_label_encoder=False, eval_metric='logloss'),
    "SVM": SVC(probability=True),
    "Naive Bayes": GaussianNB()
}

results = {}
kf = KFold(n_splits=10, shuffle=True, random_state=42)

for name, model in models.items():
    cv_results = cross_val_score(model, X_scaled, y, cv=kf, scoring='accuracy')
    results[name] = cv_results.mean()
    print(f"{name} - Acurácia Média: {cv_results.mean():.4f}")

# Nota: O SVM e Random Forest apresentaram o melhor desempenho geral[cite: 248].
