import logging
import time
import json
import random
import uuid
import os
from datetime import datetime, timezone

from confluent_kafka import Producer

PRODUCER_CONFIG = {"bootstrap.servers": "kafka:29092"}
KAFKA_TOPIC = ""

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

log = logging.getLogger(__name__)

# Definimos alguns dispositivos fixos para tornar a simulação mais realista.
DEVICES = [
    {
        "id": str(uuid.uuid4()), 
        "location": {"name": "Rio de Janeiro", "lat": -22.9068, "lon": -43.1729},
        "base_temp": 28.0, # Temperatura média no verão
        "base_pressure": 1013.25 # Pressão ao nível do mar
    },
    {
        "id": str(uuid.uuid4()), 
        "location": {"name": "São Paulo", "lat": -23.5505, "lon": -46.6333},
        "base_temp": 22.0,
        "base_pressure": 930.0 # SP é mais alta, então a pressão base é menor
    },
    {
        "id": str(uuid.uuid4()),
        "location": {"name": "Poste Remoto", "lat": -22.9999, "lon": -43.2222},
        "base_temp": 25.0,
        "base_pressure": 1010.0
    }
]

def generate_iot_data():
    """
    Gera uma leitura de sensor IoT simulada a partir de um dispositivo aleatório.
    """
    device = random.choice(DEVICES)
    
    # 1. Simula leituras de sensores com pequenas variações
    temp = device["base_temp"] + random.uniform(-1.5, 1.5)
    # Adiciona uma chance de anomalia de temperatura
    if random.random() < 0.05: # 5% de chance
        temp += random.uniform(10, 20) 
        
    pressure = device["base_pressure"] + random.uniform(-5.0, 5.0)
    humidity = max(0, min(100, 60 + random.uniform(-20, 20))) # Garante que fique entre 0-100

    # 2. Gera dados derivados (a parte "inteligente")
    
    # Fórmula barométrica simplificada para estimar a altitude
    # P0 = Pressão padrão ao nível do mar (1013.25 hPa)
    # P = Pressão medida
    try:
        altitude = 44330 * (1 - (pressure / 1013.25) ** (1 / 5.255))
    except (ValueError, ZeroDivisionError):
        altitude = 0.0

    # Lógica de status baseada em regras
    status = "OK"
    if temp > 40.0:
        status = "ALERT_HIGH_TEMP"
    elif pressure < 900.0:
        status = "ALERT_LOW_PRESSURE"

    # 3. Monta o payload final
    iot_event = {
        "device_id": device["id"],
        "location": device["location"],
        "timestamp": datetime.now(timezone.utc).isoformat().replace('+00:00', 'Z'),
        "sensors": {
            "temperature_celsius": round(temp, 2),
            "pressure_hpa": round(pressure, 2),
            "humidity_percent": round(humidity, 2)
        },
        "derived": {
            "altitude_meters": round(altitude, 2),
            "status": status
        }
    }
    return iot_event

def delivery_report(err, msg):
    """ Callback de entrega da mensagem. """
    if err is not None:
        log.error(f"Falha ao entregar mensagem: {err}")
    else:
        log.info(f"Mensagem entregue ao tópico '{msg.topic()}' [partição {msg.partition()}]")

def main():
    """ Loop principal do producer. """
    log.info(f"Iniciando producer para o Kafka em '{PRODUCER_CONFIG}'...")
    
    producer = Producer(PRODUCER_CONFIG)

    log.info(f"Enviando mensagens para o tópico '{KAFKA_TOPIC}'. Pressione Ctrl+C para sair.")
    
    try:
        while True:
            iot_data = generate_iot_data()
            
            key = iot_data['device_id']
            value = json.dumps(iot_data)
            
            log.info(f"Produzindo evento: Key='{key}', Value={value}")

            producer.produce(
                KAFKA_TOPIC, 
                key=key.encode('utf-8'), 
                value=value.encode('utf-8'), 
                callback=delivery_report
            )
            
            producer.poll(0)
            time.sleep(1) # Envia um evento por segundo

    except KeyboardInterrupt:
        log.info("Encerrando...")
    finally:
        producer.flush()
        log.info("Producer encerrado.")

if __name__ == "__main__":
    main()