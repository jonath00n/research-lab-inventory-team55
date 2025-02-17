import torch
import torch.nn as nn
import torchvision.transforms as transforms

# Define Model Architecture
class LabItemClassifier(nn.Module):
    def __init__(self, num_classes):
        super(LabItemClassifier, self).__init__()

        # Convolutional layers
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, stride=1, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, stride=1, padding=1)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, stride=1, padding=1)

        # Fully connected layers
        self.fc1 = nn.Linear(128 * 8 * 8, 256)  # Adjust for input size
        self.fc2 = nn.Linear(256, num_classes)

        # Pooling layer
        self.pool = nn.MaxPool2d(2, 2)

        # Dropout layer
        self.dropout = nn.Dropout(p=0.5)  # Drop 50% during training

    def forward(self, x):
        x = self.pool(torch.relu(self.conv1(x)))
        x = self.pool(torch.relu(self.conv2(x)))
        x = self.pool(torch.relu(self.conv3(x)))

        x = x.view(-1, 128 * 8 * 8)  # Flatten layer
        x = torch.relu(self.fc1(x))
        x = self.fc2(x)

        return x

# Define function to load trained model
def load_trained_model():
    num_classes = 7  # Update if the number of classes changes
    model = LabItemClassifier(num_classes)
    
    # Load the saved weights
    model.load_state_dict(torch.load("ML_Model.pth", map_location=torch.device('cpu')))
    model.eval()  # Set to evaluation mode
    
    return model
