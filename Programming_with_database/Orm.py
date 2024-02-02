from sqlalchemy import create_engine, Column, Integer, String, MetaData
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# Replace these variables with your PostgreSQL connection details
DATABASE_URL = "postgresql://User_name:Password@localhost/Database_name"

# SQLAlchemy engine and declarative base
engine = create_engine(DATABASE_URL)
Base = declarative_base()

# Define the model for the table
class Table(Base):
    __tablename__ = 'Students'
    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    age = Column(Integer)
# Create the table
Base.metadata.create_all(engine)

# Create a session
Session = sessionmaker(bind=engine)
session = Session()

# Insert data into the table
def insert_data(name, age):
    new_entry = Table(name=name, age=age)
    session.add(new_entry)
    session.commit()

# Read data from the table
def read_data():
    entries = session.query(Table).all()
    for entry in entries:
        print(entry.id, entry.name, entry.age)

# Update data in the table
def update_data(id, new_name, new_age):
    entry = session.query(Table).filter_by(id=id).first()
    if entry:
        entry.name = new_name
        entry.age = new_age
        session.commit()

# Delete data from the table
def delete_data(id):
    entry = session.query(Table).filter_by(id=id).first()
    if entry:
        session.delete(entry)
        session.commit()

# Close the session
session.close()

#test
# insert_data('amir',20)
# insert_data('zahra',40)
# read_data()
# update_data(2,'amirreza',24)
# delete_data(1)
