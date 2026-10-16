from tasks import hello

if __name__ == "__main__":
    hello.delay("CloudAMQP")
    print(" [x] Sent hello('CloudAMQP')")
