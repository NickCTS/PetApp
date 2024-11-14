from flask import request, jsonify, Blueprint
from backend.app import db
from backend.models import User, Pet, AdoptionApplication
from backend.schemas import user_schema, users_schema, pet_schema, pets_schema

# Create a blueprint for your API
api = Blueprint('api', __name__)

# Route to create a new user (POST)
@api.route('/users', methods=['POST'])
def create_user():
    print("Received request headers:", request.headers)
    print("Received request data:", request.data)

    # Check if content type is application/json
    if not request.is_json:
        return jsonify({"error": "Content-Type must be application/json"}), 415

    data = request.get_json()
    print("Parsed JSON data:", data)

    if not data:
        return jsonify({"error": "Invalid input"}), 400

    if 'username' not in data or 'email' not in data:
        return jsonify({"error": "Missing required fields"}), 400

    try:
        new_user = User(username=data['username'], email=data['email'])
        db.session.add(new_user)
        db.session.commit()
        return user_schema.jsonify(new_user), 201
    except Exception as e:
        print("Error while creating user:", str(e))
        return jsonify({"error": str(e)}), 500

# Route to fetch all users (GET)
@api.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return users_schema.jsonify(users), 200

# Route to create a new pet

@api.route('/pets', methods=['GET'])
def get_pets():
    print("Received GET request for /pets")

    pets = Pet.query.all()
    print(f"Queried pets: {pets}")

    if not pets:
        print("No pets found")
        return jsonify([]), 200

    try:
        response = pets_schema.jsonify(pets)
        print("Serialized response:", response.json)
        return response, 200
    except Exception as e:
        print("Error serializing pets:", str(e))
        return jsonify({"error": "Failed to serialize pets"}), 500


@api.route('/applications', methods=['GET'])
def get_user_applications():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({"error": "Missing user_id parameter"}), 400

    applications = AdoptionApplication.query.filter_by(user_id=user_id).all()
    return jsonify([{
        "id": app.id,
        "pet_id": app.pet_id,
        "status": app.status
    } for app in applications]), 200

@api.route('/applications', methods=['POST'])
def create_application():
    data = request.get_json()
    if not data or 'user_id' not in data or 'pet_id' not in data:
        return jsonify({"error": "Invalid input"}), 400
    
    try:
        new_application = AdoptionApplication(user_id=data['user_id'], pet_id=data['pet_id'])
        db.session.add(new_application)
        db.session.commit()
        return jsonify({"message": "Application created successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to register a new user
@api.route('/register', methods=['POST'])
def register_user():
    data = request.get_json()
    new_user = User(username=data['username'], email=data['email'], password=data['password'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify({
        "id": new_user.id,
        "username": new_user.username,
        "email": new_user.email
    }), 201

# Route to login a user
@api.route('/login', methods=['POST'])
def login_user():
    data = request.get_json()
    if not data or 'username' not in data or 'password' not in data:
        return jsonify({"error": "Invalid input"}), 400
    
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        return jsonify({"message": "Login successful"}), 200
    return jsonify({"error": "Invalid username or password"}), 401

@api.route('/api/add_pets', methods=['POST'])
def add_pets():
    try:
        # Load the JSON data from the request
        data = request.get_json()
        
        # Loop through the data and insert each pet into the database
        for item in data:
            pet = Pet(
                name=item.get('name'),
                type=item.get('type'),
                breed=item.get('breed'),
                age=item.get('age'),
                description=item.get('description'),
                imageUrl=item.get('imageUrl')
            )
            db.session.add(pet)

        # Commit the transaction to save the pets in the database
        db.session.commit()
        return jsonify({"message": "Pets added successfully!"}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
api = Blueprint('api', __name__)

# Add a pet to favorites
@api.route('/favorites', methods=['POST'])
def add_favorite():
    data = request.json
    user_id = data.get('user_id')
    pet_id = data.get('pet_id')

    user = User.query.get(user_id)
    pet = Pet.query.get(pet_id)

    if not user or not pet:
        return jsonify({"error": "User or Pet not found"}), 404

    user.favorite_pets.append(pet)
    db.session.commit()
    return jsonify({"message": "Pet added to favorites"}), 200

# Remove a pet from favorites
@api.route('/favorites', methods=['DELETE'])
def remove_favorite():
    data = request.json
    user_id = data.get('user_id')
    pet_id = data.get('pet_id')

    user = User.query.get(user_id)
    pet = Pet.query.get(pet_id)

    if not user or not pet:
        return jsonify({"error": "User or Pet not found"}), 404

    if pet in user.favorite_pets:
        user.favorite_pets.remove(pet)
        db.session.commit()
        return jsonify({"message": "Pet removed from favorites"}), 200
    else:
        return jsonify({"error": "Pet not in favorites"}), 400

# Get all favorite pets for a user
@api.route('/favorites/<int:user_id>', methods=['GET'])
def get_favorites(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    favorite_pets = [{"id": pet.id, "name": pet.name, "type": pet.type, "image_url": pet.image_url} for pet in user.favorite_pets]
    return jsonify(favorite_pets), 200