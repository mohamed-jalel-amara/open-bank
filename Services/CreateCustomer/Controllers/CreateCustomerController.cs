using Microsoft.AspNetCore.Mvc;
using CreateCustomer.Models;
using CreateCustomer.Messages;
using MassTransit;

namespace CreateCustomer.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CreateCustomerController : ControllerBase
    {
        private readonly IPublishEndpoint _publishEndpoint;

        public CreateCustomerController(IPublishEndpoint publishEndpoint)
        {
            _publishEndpoint = publishEndpoint;
        }

        [HttpPost]
        public async Task<IActionResult> CreateCustomer([FromBody] CustomerModel customer)
        {
            System.Diagnostics.Debug.WriteLine(customer);

            // Create and publish the message
            var accountCreatedMessage = new AccountCreatedMessage 
            { 
                Message = $"Account created successfully for {customer}" 
            };
            await _publishEndpoint.Publish(accountCreatedMessage);

            return Ok(accountCreatedMessage);
        }
    }
}
