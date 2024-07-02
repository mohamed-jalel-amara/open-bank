using Polly;
using Polly.Extensions.Http;
using System;
using System.Net.Http;

var builder = WebApplication.CreateBuilder(args);

// Yarp config
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"));

// trio resilient client ( 5 times in 30 sec)
builder.Services.AddHttpClient("yarp-client")
    .AddPolicyHandler(GetCircuitBreakerPolicy());

var app = builder.Build();

// Yarp usage
app.MapReverseProxy();

app.MapGet("/", () => "Hello World!");

app.Run();

//usage trio
static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
