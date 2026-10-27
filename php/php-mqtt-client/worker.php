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

// php-mqtt/client acks each QoS 1 message before calling the handler
$client->subscribe('hello', function (string $topic, string $message) {
    echo " [x] Received '$message'\n";
}, MqttClient::QOS_AT_LEAST_ONCE);
echo " [*] Waiting for messages. To exit press CTRL+C\n";
$client->loop();
