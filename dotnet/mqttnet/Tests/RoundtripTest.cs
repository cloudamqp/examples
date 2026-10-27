using System.Diagnostics;

public class RoundtripTest
{
    static readonly string Root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "../../../.."));

    // Builds and runs the worker and the publisher as a reader would
    [Fact]
    public async Task WorkerReceivesPublishedMessage()
    {
        var cancellationToken = TestContext.Current.CancellationToken;
        var bin = Directory.CreateTempSubdirectory().FullName;
        await Run("dotnet", $"build worker.cs -o {bin}/worker");
        await Run("dotnet", $"build publisher.cs -o {bin}/publisher");

        using var worker = Process.Start(new ProcessStartInfo("dotnet", $"{bin}/worker/worker.dll") { RedirectStandardOutput = true })!;
        try
        {
            Assert.Contains("Waiting for messages", await worker.StandardOutput.ReadLineAsync(cancellationToken));
            await Run("dotnet", $"{bin}/publisher/publisher.dll");
            Assert.Contains("Received 'Hello world!'", await worker.StandardOutput.ReadLineAsync(cancellationToken));
        }
        finally
        {
            worker.Kill();
        }
    }

    static async Task Run(string command, string arguments)
    {
        using var process = Process.Start(new ProcessStartInfo(command, arguments) { WorkingDirectory = Root })!;
        await process.WaitForExitAsync();
        Assert.Equal(0, process.ExitCode);
    }
}
