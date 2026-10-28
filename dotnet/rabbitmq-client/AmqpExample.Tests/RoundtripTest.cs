using AmqpExample;

public class RoundtripTest
{
    [Fact]
    public async Task WorkerReceivesPublishedMessage()
    {
        var queue = $"roundtrip-{Guid.NewGuid()}";
        var received = new TaskCompletionSource<string>();
        var cancellationToken = TestContext.Current.CancellationToken;

        await using var connection = await Amqp.ConnectAsync();
        await using var consumerChannel = await connection.CreateChannelAsync(cancellationToken: cancellationToken);
        await Worker.ConsumeAsync(consumerChannel, queue, message =>
        {
            received.TrySetResult(message);
            return Task.CompletedTask;
        });

        await Publisher.PublishAsync(connection, queue, "Hello world!");

        Assert.Equal("Hello world!", await received.Task.WaitAsync(TimeSpan.FromSeconds(5), cancellationToken));
        await consumerChannel.QueueDeleteAsync(queue, ifUnused: false, ifEmpty: false, cancellationToken: cancellationToken);
    }
}
