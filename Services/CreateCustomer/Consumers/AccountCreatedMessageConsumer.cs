using MassTransit;
using CreateCustomer.Messages;
using Microsoft.Extensions.Logging;

namespace CreateCustomer.Consumers
{
    public class AccountCreatedMessageConsumer : IConsumer<AccountCreatedMessage>
    {
        private readonly ILogger<AccountCreatedMessageConsumer> _logger;

        public AccountCreatedMessageConsumer(ILogger<AccountCreatedMessageConsumer> logger)
        {
            _logger = logger;
        }

        public Task Consume(ConsumeContext<AccountCreatedMessage> context)
        {
            _logger.LogInformation($"Received: {context.Message.Message}");
            return Task.CompletedTask;
        }
    }
}
