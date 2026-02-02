import json
from time import sleep
import requests
import paho.mqtt.client as mqtt
from datetime import datetime

# ==== JSONBIN KONFIGURATION ====
bin_id = "6900cd62ae596e70832f3318e7"
url = f"https://api.jsonbin.io/v3/b/{bin_id}"
headers = {
    "Content-Type": "application/json",
    "X-Master-Key": "$2a$10$qXdFaebTW2Nv79hs6a5x12sIufLYQ1bNlZKnsRUGPk4E1S2SPJTxBy7S"
}
AW="M21"
RUF="M22"
# ==== MQTT KONFIGURATION ====
BROKER = "192.168.0.50"
PORT = 1883
TOPIC = "pub"
TOPIC_SUB = "sub"
# Hier werden die aktuellen Werte gesammelt
current_data = {}

# ==== MQTT CALLBACK ====
def on_message(client, userdata, message):
    global current_data
    payload = message.payload.decode()
    try:
        data = json.loads(payload)
        reported = data.get("state", {}).get("reported", {})
        print(" Nachricht:", payload)
        
    except Exception as e:
        print("Ungültige Nachricht:", payload)
        print("Fehler:", e)

# ==== MQTT SETUP ====
client = mqtt.Client("PC_Receiver")
client.on_message = on_message
client.connect(BROKER, PORT)
client.subscribe(TOPIC)
client.loop_start()

print("Empfange MQTT-Daten... (Strg+C zum Beenden)")

# ==== HAUPTSCHLEIFE ====




try:
    toggle = 0
    while True:
        
        payload = {"state": {RUF:{"value" :[1]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        payload = {"state": {RUF:{"value" :[0]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        payload = {"state": {AW:{"value" :[1]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        payload = {"state": {AW:{"value" :[0]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        payload = {"state": {AW:{"value" :[1]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        payload = {"state": {AW:{"value" :[0]}}}
        client.publish(TOPIC_SUB, json.dumps(payload))
        sleep(1)
        #print("Sent:", payload)
        
except KeyboardInterrupt:
    pass
finally:
    client.loop_stop()
    client.disconnect()
