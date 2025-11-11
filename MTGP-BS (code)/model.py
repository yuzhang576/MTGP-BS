import torch
import torch.nn as nn

class model_element_property(nn.Module):
    def __init__(self, input_size, hidden_size, out_put_size):
        super(model_element_property, self).__init__()
        self.hidden1 = nn.Linear(input_size, hidden_size)
        self.output = nn.Linear(hidden_size, out_put_size)

    def forward(self, x):
        x = torch.relu(self.hidden1(x))
        x = self.output(x)
        return x
