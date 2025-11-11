import torch
import torch.optim as optim
import torch.nn as nn

def do_validation(model, criterion, x_val, y_val):
    model.eval()
    outputs = model(x_val)
    outputs = outputs.view(-1)
    y_val = y_val.view(-1)
    loss_val = criterion(outputs, y_val)
    return loss_val

def train(model, x_train, y_train, x_val, y_val, epochs=1000, lr=0.001):
    device = torch.device("cuda:1" if torch.cuda.is_available() else "cpu")
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=lr)

    best_loss = 999999.0
    best_model = model

    model.train()
    for epoch in range(epochs):
        outputs = model(x_train)
        outputs = outputs.view(-1)
        y_train = y_train.view(-1)
        loss = criterion(outputs, y_train.to(device))

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        loss_val =do_validation(model, criterion, x_val, y_val)

        if loss_val < best_loss:
            best_loss = loss_val
            best_model = model

        if epoch % 100 == 0:
            print(f'Epoch [{epoch}/{epochs}], Loss: {loss.item():.8f}')

    return best_model
