package main

import (
	"cmp"
	"fmt"
	"log"
	"os"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

func main() {
	scheme, port := "tcp", cmp.Or(os.Getenv("MQTT_PORT"), "1883")
	if port == "8883" {
		scheme = "ssl"
	}
	opts := mqtt.NewClientOptions().
		AddBroker(fmt.Sprintf("%s://%s:%s", scheme, cmp.Or(os.Getenv("MQTT_HOST"), "localhost"), port)).
		SetUsername(cmp.Or(os.Getenv("MQTT_USERNAME"), "guest")).
		SetPassword(cmp.Or(os.Getenv("MQTT_PASSWORD"), "guest"))
	client := mqtt.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		log.Fatal(token.Error())
	}
	defer client.Disconnect(250)

	// QoS 1 waits for the broker's PUBACK
	if token := client.Publish("hello", 1, false, "Hello world!"); token.Wait() && token.Error() != nil {
		log.Fatal(token.Error())
	}
	fmt.Println(" [x] Sent 'Hello world!'")
}
