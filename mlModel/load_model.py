# Importing all used liberaries
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torchvision import datasets, transforms
from torch.utils.data import DataLoader
from PIL import Image
from torch.utils.tensorboard import SummaryWriter
import torchvision.transforms as transforms


# CNN Model Arch. is defindw here
class LabItemClassifier(nn.Module):
    def __init__(self, num_classes):
        super(LabItemClassifier, self).__init__()
        # Convolutional layers (3)
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, stride=1, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, stride=1, padding=1)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, stride=1, padding=1)
        
        # connected layers (2 linear layers)
        self.fc1 = nn.Linear(128 * 8 * 8, 256)  # Assuming input images are 64x64
        self.fc2 = nn.Linear(256, num_classes)
        
        # Pooling layer (1)
        self.pool = nn.MaxPool2d(2, 2)

        # Dropout layers (1)
        self.dropout = nn.Dropout(p=0.5)  # Drop 50% during training
        
    def forward(self, x):
        # layers w/ ReLU and pooling
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = self.pool(F.relu(self.conv3(x)))
        
        # Flatten feature maps before passing through connected layers
        x = x.view(-1, 128 * 8 * 8)
        
        # connected layers
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        
        return x

# Define the number of classes (screws, resistors, pcb comps, transistors, LEds, ICs, capacitors)
num_classes = 7

# Def transformations for the images (resize,convert to tensor)
transform = transforms.Compose([
    transforms.Resize((64, 64)),  # Resize to 64x64 pixels
    transforms.ToTensor()         # Convert to PyTorch tensors
])

# Load the trained model
model = LabItemClassifier(num_classes)  # Adjust class count if needed
model.load_state_dict(torch.load("ML_Model.pth"))
model.eval()

print("Model loaded successfully!")