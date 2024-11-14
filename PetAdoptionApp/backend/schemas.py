from backend.app import ma
from backend.models import User, Pet, AdoptionApplication

class UserSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = User

class PetSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Pet

class AdoptionApplicationSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = AdoptionApplication

user_schema = UserSchema()
users_schema = UserSchema(many=True)
pet_schema = PetSchema()
pets_schema = PetSchema(many=True)
adoption_schema = AdoptionApplicationSchema()
adoptions_schema = AdoptionApplicationSchema(many=True)
