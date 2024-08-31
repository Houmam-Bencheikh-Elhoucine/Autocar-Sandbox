import socket
import json
import tensorflow as tf
from tensorflow.keras.models import load_model
import numpy as np
import sys

def open_model(path):# modify this with a function to load a model
	return load_model(path)

nn = open_model("nn.keras")

def preprocess(data):# Modify this with a function to delete irrelevant columns
	data["Speed"] = data["Speed"]/1000
	data.pop("Collided")
	data.pop("Distance")
	data.pop("Last_cp")
	return data

def predict(model, data):# modify this with code to predict output (the function takes a dictionary as input and returns a list of two values as output)
	x = np.array(list(data.values())).reshape(1, -1)
	y = nn.predict(x)
	return y[0].tolist()


HOST = sys.argv[1]
PORT = int(sys.argv[2]) 
nn = open_model(sys.argv[3])

buffer_size = 1024 **2
with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
	s.bind((HOST, PORT))
	print("Bind successfully")
	while True:
		pair = s.recvfrom(buffer_size)
		message = pair[0].decode(encoding="utf-8")
		#print("message:", message.decode(encoding="utf-32"))
		adr = pair[1]
		data = json.loads(message)
		x = preprocess(data)
		y = predict(nn, x)
		out = json.dumps(y)
		print(out)
		s.sendto(out.encode(encoding="utf-8"), adr)

