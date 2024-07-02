using MassTransit;
using CreateCustomer.Consumers;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddMassTransit(x =>
{
    x.AddConsumer<AccountCreatedMessageConsumer>();

    x.UsingRabbitMq((context, cfg) =>
    {
        var rabbitMqHost = builder.Configuration["MassTransit:RabbitMq:Host"];
        var username = builder.Configuration["MassTransit:RabbitMq:Username"];
        var password = builder.Configuration["MassTransit:RabbitMq:Password"];

        if (string.IsNullOrEmpty(rabbitMqHost))
        {
            rabbitMqHost = "rabbitmq://localhost";
        }
        if (string.IsNullOrEmpty(username))
        {
            username = "guest";
        }
        if (string.IsNullOrEmpty(password))
        {
            password = "guest";
        }

        cfg.Host(rabbitMqHost, h =>
        {
            h.Username(username);
            h.Password(password);
        });

        cfg.ReceiveEndpoint("AccountCreation", e =>
        {
            e.ConfigureConsumer<AccountCreatedMessageConsumer>(context);
        });
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
