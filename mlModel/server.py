from flask import Flask, request, jsonify
import torch
import torchvision.transforms as transforms
from PIL import Image
import io
import base64

# Import the model loading function
from load_model import load_trained_model

app = Flask(__name__)

class_labels = {
    0: 'ICs',
    1: 'LEDs',
    2: 'capacitors',
    3: 'pcb_components',
    4: 'resistors',
    5: 'screws',
    6: 'transistors'
}

# Load the trained model
model = load_trained_model()

# Define Image Transform (Resize + Convert to Tensor)
transform = transforms.Compose([
    transforms.Resize((64, 64)),  # Match training size
    transforms.ToTensor(),
])

def preprocess_image(image_bytes):
    """Convert image bytes into a tensor."""
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    image = transform(image)  # Apply transformation
    image = image.unsqueeze(0)  # Add batch dimension
    return image

@app.route('/predict', methods=['POST'])
def predict():
    """Receive image, run model prediction, and return item name."""
    try:
        # Receive base64-encoded image
        data = request.get_json()
        image_data = base64.b64decode(data['image'])
        image_tensor = preprocess_image(image_data)

        # Run prediction
        with torch.no_grad():
            output = model(image_tensor)
            predicted_class = output.argmax().item()
        
        item_name = class_labels.get(predicted_class, "Unknown Item")
        return jsonify({'item': item_name})

        return jsonify({'item': f'Predicted_Item_{predicted_class}'})
    
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)