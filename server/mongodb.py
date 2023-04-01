# mongodb.py
from bson.objectid import ObjectId 
from dotenv import load_dotenv
import os
from pymongo import MongoClient

load_dotenv()
MONGO_USERNAME = os.getenv("MONGO_USERNAME")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD")

# this function will return the collection for the event list. Any time a functoin needs to connect to the database,
# this function will be called
def get_mongodb_collection():
    # connect to client (mongo user password should be stored in personal .env file)
    mongo_client = MongoClient(f'mongodb+srv://{MONGO_USERNAME}:{MONGO_PASSWORD}@test-cluster1.ljrkvvp.mongodb.net/?retryWrites=true&w=majority')

    # access 'campus_events' database
    db = mongo_client['campus_events']

    # access  and return 'event_list' collection
    return db['event_list']

# this function will query all events from the event_list collection and return all events in json format
def get_mongodb_all():
    collection = get_mongodb_collection()

    # get all event doucments in the collection
    data = collection.find()

    # return a json formatted events list
    return [document for document in data]

# this function is utilized by the chatGPT api call to parse only the information necessary
# for chatGPT to parse  
def get_mongodb_gpt():
    # called from openai.py library for the prompt construction
    data = get_mongodb_all()

    # format the data to only include the titles and descriptions

    partial_data = [{"title": event["title"], 
                     "description": event["description"], 
                     "id": str(event["_id"])}
                    for event in data]

    return partial_data

# this function is called after chatGPT returns the ids of events that match the search results. 
# returns a list of json objects corresponding to the ids
def get_mongodb_events(id_list):
    collection = get_mongodb_collection()

    # itterate through the id list and query all completed collections 
    return [collection.find_one({'_id': ObjectId(id)}) for id in id_list]

# simple api wrapper for returning all data to flutter
def get_mongodb_flutter():
    data = get_mongodb_all()
    return data

def main():
    print(get_mongodb_flutter())
    


if __name__ == '__main__':
    main()
