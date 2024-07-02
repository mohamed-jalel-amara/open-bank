using MassTransit;
using CreateAccount.Messages;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Rabbit MQ config
builder.Services.AddMassTransit(x =>
{
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
        cfg.Message<AccountCreatedMessage>(x => x.SetEntityName("AccountCreation"));
        
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseHttpsRedirection(); 
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
