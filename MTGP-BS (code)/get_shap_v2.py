from sklearn.model_selection import train_test_split
import shap
import pandas as pd
import numpy as np
from xgboost.dask import predict
from sklearn.utils import resample
from sklearn.preprocessing import MinMaxScaler

import train_model
import torch
from model import model_element_property

def get_shap_values(num_x, num_models, file_name):

    file_path = file_name + ".xlsx"
    data = pd.read_excel(file_path)
    data = data.to_numpy()

    X = data[:, 0: num_x]
    Y = data[:, num_x:]
    X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

    pt_X_train = torch.tensor(X_train, dtype=torch.float32)
    pt_y_train = torch.tensor(y_train, dtype=torch.float32)

    pt_X_test = torch.tensor(X_test, dtype=torch.float32)
    pt_y_test = torch.tensor(y_test, dtype=torch.float32)

    input_size = X.shape[1]
    hidden_size = num_x
    out_put_size = Y.shape[1]

    # Corresponding to "SHAP-Based Multi-model Attribution" in main paper
    shap_values = []
    for i in range(num_models):
        # Corresponding to "Bootstrap-Based Data Preparation" in main paper (Line 2 in Algorithm S2 in Appendix)
        X_resampled, y_resampled = resample(pt_X_train, pt_y_train, replace=True, n_samples=len(X_train), random_state=np.random.randint(0, 1000))

        temp_X = [x for x in pt_X_train if x.tolist() not in X_resampled.tolist()]
        X_not_resampled = torch.tensor([item.detach().numpy() for item in temp_X], dtype=torch.float32)
        temp_y = [y for y in pt_y_train if y.tolist() not in y_resampled.tolist()]
        y_not_resampled = torch.tensor([item.detach().numpy() for item in temp_y], dtype=torch.float32)

        # Corresponding to Line 5 in Algorithm S2 in Appendix
        model = model_element_property(input_size, hidden_size, out_put_size)
        model = train_model.train(model, X_resampled, y_resampled, X_not_resampled, y_not_resampled)

        # Corresponding to Line 6 in Algorithm S2 in Appendix
        shap.initjs()
        explainer = shap.GradientExplainer(model, pt_X_train)
        shap_values.append(np.mean(explainer.shap_values(pt_X_test), axis=0))

    return shap_values
