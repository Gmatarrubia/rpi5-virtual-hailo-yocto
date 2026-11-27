#!/usr/bin/env python3
import time
import json
import paho.mqtt.client as mqtt

# Configuration
MQTT_BROKER = "127.0.0.1"
MQTT_PORT = 1883
MQTT_USER = "ha-user"
MQTT_PASSWORD = "your_mqtt_password"
ENV_FILE_PATH = "/data/homeassistant/env"

def load_mqtt_password(path=ENV_FILE_PATH):
    try:
        with open(path, encoding="utf-8") as env_file:
            for line in env_file:
                name, separator, value = line.partition("=")
                if separator and name.strip() == "MQTT_PASSWORD":
                    return value.rstrip("\r\n")
    except FileNotFoundError:
        pass
    return MQTT_PASSWORD

MQTT_PASSWORD = load_mqtt_password(ENV_FILE_PATH)

TOPIC_TEMP_STATE = "homeassistant/sensor/rpi_thermal/temperature/state"
TOPIC_TEMP_CONFIG = "homeassistant/sensor/rpi_thermal/temperature/config"

TOPIC_COOLING_STATE = "homeassistant/sensor/rpi_cooling/state/state"
TOPIC_COOLING_CONFIG = "homeassistant/sensor/rpi_cooling/state/config"

def read_sysfs(path):
    try:
        with open(path, "r") as f:
            return f.read().strip()
    except Exception:
        return None

def get_temp():
    val = read_sysfs("/sys/class/thermal/thermal_zone0/temp")
    return round(int(val) / 1000.0, 1) if val else None

def get_cooling_state():
    val = read_sysfs("/sys/class/thermal/cooling_device0/cur_state")
    return int(val) if val else None

def on_connect(client, userdata, flags, rc):
    device_info = {
        'identifiers': ['raspberry_pi_host'],
        'name': 'Raspberry Pi Host',
        'model': 'Raspberry Pi 5'
    }

    # Temperature Sensor Discovery Payload
    temp_config = {
        'name': 'Raspberry Pi Thermal Sensor',
        'unique_id': 'rpi_host_thermal_temp',
        'state_topic': TOPIC_TEMP_STATE,
        'unit_of_measurement': '°C',
        'device_class': 'temperature',
        'state_class': 'measurement',
        'device': device_info
    }
    client.publish(TOPIC_TEMP_CONFIG, json.dumps(temp_config), retain=True)

    # Cooling Device State Discovery Payload
    cooling_config = {
        'name': 'Raspberry Pi Cooling State',
        'unique_id': 'rpi_host_cooling_state',
        'state_topic': TOPIC_COOLING_STATE,
        'state_class': 'measurement',
        'device': device_info
    }
    client.publish(TOPIC_COOLING_CONFIG, json.dumps(cooling_config), retain=True)

client = mqtt.Client()
if MQTT_USER:
    client.username_pw_set(MQTT_USER, MQTT_PASSWORD)
client.on_connect = on_connect
client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

try:
    while True:
        temp = get_temp()
        if temp is not None:
            client.publish(TOPIC_TEMP_STATE, temp)

        cooling_state = get_cooling_state()
        if cooling_state is not None:
            client.publish(TOPIC_COOLING_STATE, cooling_state)

        time.sleep(30)
except KeyboardInterrupt:
    client.loop_stop()
