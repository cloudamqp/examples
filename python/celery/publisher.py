from tasks import hello

if __name__ == "__main__":
    hello.delay("world")
    print(" [x] Sent hello('world')")
