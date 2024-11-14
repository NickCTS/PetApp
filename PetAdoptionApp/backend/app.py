from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_marshmallow import Marshmallow
from flask_cors import CORS
import os

# Initialize the Flask app
app = Flask(__name__)
CORS(app)

# Define the path to the database file directly in the root directory
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DATABASE_PATH = os.path.join(BASE_DIR, 'pets.db')

# Configure the database
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DATABASE_PATH}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize extensions
db = SQLAlchemy(app)
migrate = Migrate(app, db)
ma = Marshmallow(app)

# Register the blueprint for routes
from backend.routes import api
app.register_blueprint(api, url_prefix='/api')

# Run the app
if __name__ == '__main__':
    app.run(debug=True)
