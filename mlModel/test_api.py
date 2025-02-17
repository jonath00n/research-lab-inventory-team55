import requests
import base64
# Convert an image to base64 (make sure you have an image in the same folder)
with open("test_image.jpg", "rb") as img_file:
    image_base64 = base64.b64encode(img_file.read()).decode('utf-8')

# Send POST request to your Flask API
response = requests.post("http://127.0.0.1:5001/predict", json={"image": image_base64})

# Print the response
print(response.json())
