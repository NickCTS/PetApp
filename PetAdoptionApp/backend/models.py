from backend.app import db


favorites = db.Table('favorites',
    db.Column('user_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('pet_id', db.Integer, db.ForeignKey('pet.id'))
)

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)  # Added password field
from backend.app import db


class Pet(db.Model):
    __tablename__ = 'pets'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    breed = db.Column(db.String(50), nullable=True)
    age = db.Column(db.Integer, nullable=True)
    description = db.Column(db.Text, nullable=True)
    imageUrl = db.Column(db.String(200), nullable=True)

    def __repr__(self):
        return f'<Pet {self.name}>'




# models.py
class AdoptionApplication(db.Model):
    __tablename__ = 'adoption_application'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    pet_id = db.Column(db.Integer, db.ForeignKey('pet.id'), nullable=False)
    status = db.Column(db.String(20), nullable=False, default='Pending')  # Set a default value
