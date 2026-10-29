package main

import (
	"cmp"
	"fmt"
	"log"
	"os"
	"os/signal"

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

	// Each message is acked when the handler returns
	token := client.Subscribe("hello", 1, func(_ mqtt.Client, msg mqtt.Message) {
		fmt.Printf(" [x] Received '%s'\n", msg.Payload())
	})
	if token.Wait() && token.Error() != nil {
		log.Fatal(token.Error())
	}
	fmt.Println(" [*] Waiting for messages. To exit press CTRL+C")

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)
	<-interrupt
}
