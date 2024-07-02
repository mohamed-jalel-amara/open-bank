using Microsoft.AspNetCore.Mvc;
using CreateAccount.Models;
using MassTransit;
using CreateAccount.Messages;

namespace CreateAccount.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CreateAccountController : ControllerBase
    {
        private readonly IPublishEndpoint _publishEndpoint;

        public CreateAccountController(IPublishEndpoint publishEndpoint)
        {
            _publishEndpoint = publishEndpoint;
        }

        [HttpPost]
        public async Task<IActionResult> CreateAccount([FromBody] AccountModel account)
        {
            // Implement your account creation logic here
            System.Diagnostics.Debug.WriteLine(account);

            // Examle of using Rabbit MQ : Publish a message to RabbitMQ
            var message = new AccountCreatedMessage { Message = "Account created" };
            await _publishEndpoint.Publish(message);

            return Ok(account);
        }
    }
}
