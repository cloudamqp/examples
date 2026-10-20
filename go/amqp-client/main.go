package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"

	amqp "github.com/cloudamqp/amqp-client.go"
)

func main() {
	if len(os.Args) != 2 || (os.Args[1] != "publish" && os.Args[1] != "worker") {
		fmt.Fprintln(os.Stderr, "Usage: go run . publish|worker")
		os.Exit(2)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	c, err := connect(ctx)
	if err != nil {
		log.Fatal(err)
	}
	defer c.Close()

	if os.Args[1] == "publish" {
		err = runPublisher(ctx, c, "hello", "Hello CloudAMQP!")
	} else {
		err = runWorker(ctx, c, "hello", func(message string) error {
			log.Printf(" [x] Received '%s'", message)
			return nil
		})
	}
	if err != nil {
		log.Fatal(err)
	}
}

// connect connects to CLOUDAMQP_URL, and reconnects if the connection is lost.
func connect(ctx context.Context) (*amqp.Client, error) {
	url := os.Getenv("CLOUDAMQP_URL")
	if url == "" {
		url = "amqp://guest:guest@localhost"
	}
	return amqp.NewClient(ctx, url, nil)
}
