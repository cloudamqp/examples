<?php

require __DIR__ . '/vendor/autoload.php';

use PhpMqtt\Client\ConnectionSettings;
use PhpMqtt\Client\MqttClient;

$port = (int) (getenv('MQTT_PORT') ?: 1883);
$client = new MqttClient(getenv('MQTT_HOST') ?: 'localhost', $port, null, MqttClient::MQTT_3_1_1);
$client->connect((new ConnectionSettings())
    ->setUsername(getenv('MQTT_USERNAME') ?: 'guest')
    ->setPassword(getenv('MQTT_PASSWORD') ?: 'guest')
    ->setUseTls($port === 8883));

// QoS 1, and the loop runs until the broker has sent its PUBACK
$client->publish('hello', 'Hello world!', MqttClient::QOS_AT_LEAST_ONCE);
$client->loop(true, true);
echo " [x] Sent 'Hello world!'\n";
$client->disconnect();
