# flask server file

import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "This is the website for the backend"

if __name__ == '__main__':
    app.run(
        host=os.getenv('FLASK_HOST', '0.0.0.0'),
        port=int(os.getenv('FLASK_PORT', 5000)),
        debug=os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    )
