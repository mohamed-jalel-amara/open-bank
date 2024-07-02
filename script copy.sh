#!/bin/bash

# Solution name
SOLUTION_NAME="OpenBankProject"

# Create the solution
dotnet new sln -n $SOLUTION_NAME

# Array of microservice names
SERVICES=(
  "CreateAccount"
  "GetAccountsAtAllBanks"
  "UpdateAccountLabel"
  "GetBank"
  "GetTransactionTypesAtBank"
  "GetCardsForCurrentUser"
  "GetCardsForSpecifiedBank"
  "CreateCustomer"
  "CreateCustomerSocialMediaHandlers"
  "CreateCustomerMessage"
  "GetResourceDogs"
  "AddKYCCheck"
  "AddKYCDocument"
  "AddKYCStatus"
  "GetCustomerKYCChecks"
  "GetCustomerKYCDocuments"
  "GetCustomerKYCStatuses"
  "SearchAPIMetrics"
  "GetSwaggerDocumentation"
  "AnswerTransactionRequestChallenge"
  "CreateTransactionRequest"
  "GetTransactionRequestTypesForAccount"
  "GetTransactionRequests"
  "CreateUser"
  "GetUserCurrent"
  "GetUsersByEmailAddress"
  "ViewCustom"
  "DeleteCustomView"
  "GetAccountAccessForUser"
  "GetViewsForAccount"
  "GetAccess"
  "GrantUserAccessToView"
)

# Create a directory for the services and navigate into it
mkdir Services && cd Services

# Create each microservice and add to the solution
for SERVICE in "${SERVICES[@]}"
do
  dotnet new webapi -n $SERVICE
  dotnet sln ../$SOLUTION_NAME.sln add $SERVICE/$SERVICE.csproj
done

cd ..

# Install common packages for each microservice
COMMON_PACKAGES=(
  "MassTransit"
  "MassTransit.RabbitMQ"
  "Swashbuckle.AspNetCore"
)

# Function to add packages to a service
add_packages() {
  local SERVICE_NAME=$1
  cd Services/$SERVICE_NAME
  for PACKAGE in "${COMMON_PACKAGES[@]}"
  do
    dotnet add package $PACKAGE
  done
  cd ../..
}

# Add common packages to each service
for SERVICE in "${SERVICES[@]}"
do
  add_packages $SERVICE
done

# Create YARP API Gateway project
dotnet new web -n APIGateway
dotnet add APIGateway/APIGateway.csproj package Yarp.ReverseProxy
dotnet sln add APIGateway/APIGateway.csproj

# Configure YARP in APIGateway
cat > APIGateway/appsettings.json <<EOL
{
  "ReverseProxy": {
    "Routes": [
      {
        "RouteId": "create_account",
        "ClusterId": "create_account_cluster",
        "Match": {
          "Path": "/createaccount/{**catch-all}"
        }
      },
      {
        "RouteId": "get_accounts_at_all_banks",
        "ClusterId": "get_accounts_at_all_banks_cluster",
        "Match": {
          "Path": "/getaccountsatallbanks/{**catch-all}"
        }
      },
      {
        "RouteId": "update_account_label",
        "ClusterId": "update_account_label_cluster",
        "Match": {
          "Path": "/updateaccountlabel/{**catch-all}"
        }
      },
      {
        "RouteId": "get_bank",
        "ClusterId": "get_bank_cluster",
        "Match": {
          "Path": "/getbank/{**catch-all}"
        }
      },
      {
        "RouteId": "get_transaction_types_at_bank",
        "ClusterId": "get_transaction_types_at_bank_cluster",
        "Match": {
          "Path": "/gettransactiontypesatbank/{**catch-all}"
        }
      },
      {
        "RouteId": "get_cards_for_current_user",
        "ClusterId": "get_cards_for_current_user_cluster",
        "Match": {
          "Path": "/getcardsforcurrentuser/{**catch-all}"
        }
      },
      {
        "RouteId": "get_cards_for_specified_bank",
        "ClusterId": "get_cards_for_specified_bank_cluster",
        "Match": {
          "Path": "/getcardsforspecifiedbank/{**catch-all}"
        }
      },
      {
        "RouteId": "create_customer",
        "ClusterId": "create_customer_cluster",
        "Match": {
          "Path": "/createcustomer/{**catch-all}"
        }
      },
      {
        "RouteId": "create_customer_social_media_handlers",
        "ClusterId": "create_customer_social_media_handlers_cluster",
        "Match": {
          "Path": "/createcustomersocialmediahandlers/{**catch-all}"
        }
      },
      {
        "RouteId": "create_customer_message",
        "ClusterId": "create_customer_message_cluster",
        "Match": {
          "Path": "/createcustomermessage/{**catch-all}"
        }
      },
      {
        "RouteId": "get_resource_dogs",
        "ClusterId": "get_resource_dogs_cluster",
        "Match": {
          "Path": "/getresourcedogs/{**catch-all}"
        }
      },
      {
        "RouteId": "add_kyc_check",
        "ClusterId": "add_kyc_check_cluster",
        "Match": {
          "Path": "/addkyccheck/{**catch-all}"
        }
      },
      {
        "RouteId": "add_kyc_document",
        "ClusterId": "add_kyc_document_cluster",
        "Match": {
          "Path": "/addkycdocument/{**catch-all}"
        }
      },
      {
        "RouteId": "add_kyc_status",
        "ClusterId": "add_kyc_status_cluster",
        "Match": {
          "Path": "/addkycstatus/{**catch-all}"
        }
      },
      {
        "RouteId": "get_customer_kyc_checks",
        "ClusterId": "get_customer_kyc_checks_cluster",
        "Match": {
          "Path": "/getcustomerkycchecks/{**catch-all}"
        }
      },
      {
        "RouteId": "get_customer_kyc_documents",
        "ClusterId": "get_customer_kyc_documents_cluster",
        "Match": {
          "Path": "/getcustomerkycdocuments/{**catch-all}"
        }
      },
      {
        "RouteId": "get_customer_kyc_statuses",
        "ClusterId": "get_customer_kyc_statuses_cluster",
        "Match": {
          "Path": "/getcustomerkycstatuses/{**catch-all}"
        }
      },
      {
        "RouteId": "search_api_metrics",
        "ClusterId": "search_api_metrics_cluster",
        "Match": {
          "Path": "/searchapimetrics/{**catch-all}"
        }
      },
      {
        "RouteId": "get_swagger_documentation",
        "ClusterId": "get_swagger_documentation_cluster",
        "Match": {
          "Path": "/getswaggerdocumentation/{**catch-all}"
        }
      },
      {
        "RouteId": "answer_transaction_request_challenge",
        "ClusterId": "answer_transaction_request_challenge_cluster",
        "Match": {
          "Path": "/answertransactionrequestchallenge/{**catch-all}"
        }
      },
      {
        "RouteId": "create_transaction_request",
        "ClusterId": "create_transaction_request_cluster",
        "Match": {
          "Path": "/createtransactionrequest/{**catch-all}"
        }
      },
      {
        "RouteId": "get_transaction_request_types_for_account",
        "ClusterId": "get_transaction_request_types_for_account_cluster",
        "Match": {
          "Path": "/gettransactionrequesttypesforaccount/{**catch-all}"
        }
      },
      {
        "RouteId": "get_transaction_requests",
        "ClusterId": "get_transaction_requests_cluster",
        "Match": {
          "Path": "/gettransactionrequests/{**catch-all}"
        }
      },
      {
        "RouteId": "create_user",
        "ClusterId": "create_user_cluster",
        "Match": {
          "Path": "/createuser/{**catch-all}"
        }
      },
      {
        "RouteId": "get_user_current",
        "ClusterId": "get_user_current_cluster",
        "Match": {
          "Path": "/getusercurrent/{**catch-all}"
        }
      },
      {
        "RouteId": "get_users_by_email_address",
        "ClusterId": "get_users_by_email_address_cluster",
        "Match": {
          "Path": "/getusersbyemailaddress/{**catch-all}"
        }
      },
      {
        "RouteId": "view_custom",
        "ClusterId": "view_custom_cluster",
        "Match": {
          "Path": "/viewcustom/{**catch-all}"
        }
      },
      {
        "RouteId": "delete_custom_view",
        "ClusterId": "delete_custom_view_cluster",
        "Match": {
          "Path": "/deletecustomview/{**catch-all}"
        }
      },
      {
        "RouteId": "get_account_access_for_user",
        "ClusterId": "get_account_access_for_user_cluster",
        "Match": {
          "Path": "/getaccountaccessforuser/{**catch-all}"
        }
      },
      {
        "RouteId": "get_views_for_account",
        "ClusterId": "get_views_for_account_cluster",
        "Match": {
          "Path": "/getviewsforaccount/{**catch-all}"
        }
      },
      {
        "RouteId": "get_access",
        "ClusterId": "get_access_cluster",
        "Match": {
          "Path": "/getaccess/{**catch-all}"
        }
      },
      {
        "RouteId": "grant_user_access_to_view",
        "ClusterId": "grant_user_access_to_view_cluster",
        "Match": {
          "Path": "/grantuseraccesstoview/{**catch-all}"
        }
      }
    ],
    "Clusters": {
      "create_account_cluster": {
        "Destinations": {
          "create_account_destination": {
            "Address": "http://localhost:5001/"
          }
        }
      },
      "get_accounts_at_all_banks_cluster": {
        "Destinations": {
          "get_accounts_at_all_banks_destination": {
            "Address": "http://localhost:5002/"
          }
        }
      },
      "update_account_label_cluster": {
        "Destinations": {
          "update_account_label_destination": {
            "Address": "http://localhost:5003/"
          }
        }
      },
      "get_bank_cluster": {
        "Destinations": {
          "get_bank_destination": {
            "Address": "http://localhost:5004/"
          }
        }
      },
      "get_transaction_types_at_bank_cluster": {
        "Destinations": {
          "get_transaction_types_at_bank_destination": {
            "Address": "http://localhost:5005/"
          }
        }
      },
      "get_cards_for_current_user_cluster": {
        "Destinations": {
          "get_cards_for_current_user_destination": {
            "Address": "http://localhost:5006/"
          }
        }
      },
      "get_cards_for_specified_bank_cluster": {
        "Destinations": {
          "get_cards_for_specified_bank_destination": {
            "Address": "http://localhost:5007/"
          }
        }
      },
      "create_customer_cluster": {
        "Destinations": {
          "create_customer_destination": {
            "Address": "http://localhost:5008/"
          }
        }
      },
      "create_customer_social_media_handlers_cluster": {
        "Destinations": {
          "create_customer_social_media_handlers_destination": {
            "Address": "http://localhost:5009/"
          }
        }
      },
      "create_customer_message_cluster": {
        "Destinations": {
          "create_customer_message_destination": {
            "Address": "http://localhost:5010/"
          }
        }
      },
      "get_resource_dogs_cluster": {
        "Destinations": {
          "get_resource_dogs_destination": {
            "Address": "http://localhost:5011/"
          }
        }
      },
      "add_kyc_check_cluster": {
        "Destinations": {
          "add_kyc_check_destination": {
            "Address": "http://localhost:5012/"
          }
        }
      },
      "add_kyc_document_cluster": {
        "Destinations": {
          "add_kyc_document_destination": {
            "Address": "http://localhost:5013/"
          }
        }
      },
      "add_kyc_status_cluster": {
        "Destinations": {
          "add_kyc_status_destination": {
            "Address": "http://localhost:5014/"
          }
        }
      },
      "get_customer_kyc_checks_cluster": {
        "Destinations": {
          "get_customer_kyc_checks_destination": {
            "Address": "http://localhost:5015/"
          }
        }
      },
      "get_customer_kyc_documents_cluster": {
        "Destinations": {
          "get_customer_kyc_documents_destination": {
            "Address": "http://localhost:5016/"
          }
        }
      },
      "get_customer_kyc_statuses_cluster": {
        "Destinations": {
          "get_customer_kyc_statuses_destination": {
            "Address": "http://localhost:5017/"
          }
        }
      },
      "search_api_metrics_cluster": {
        "Destinations": {
          "search_api_metrics_destination": {
            "Address": "http://localhost:5018/"
          }
        }
      },
      "get_swagger_documentation_cluster": {
        "Destinations": {
          "get_swagger_documentation_destination": {
            "Address": "http://localhost:5019/"
          }
        }
      },
      "answer_transaction_request_challenge_cluster": {
        "Destinations": {
          "answer_transaction_request_challenge_destination": {
            "Address": "http://localhost:5020/"
          }
        }
      },
      "create_transaction_request_cluster": {
        "Destinations": {
          "create_transaction_request_destination": {
            "Address": "http://localhost:5021/"
          }
        }
      },
      "get_transaction_request_types_for_account_cluster": {
        "Destinations": {
          "get_transaction_request_types_for_account_destination": {
            "Address": "http://localhost:5022/"
          }
        }
      },
      "get_transaction_requests_cluster": {
        "Destinations": {
          "get_transaction_requests_destination": {
            "Address": "http://localhost:5023/"
          }
        }
      },
      "create_user_cluster": {
        "Destinations": {
          "create_user_destination": {
            "Address": "http://localhost:5024/"
          }
        }
      },
      "get_user_current_cluster": {
        "Destinations": {
          "get_user_current_destination": {
            "Address": "http://localhost:5025/"
          }
        }
      },
      "get_users_by_email_address_cluster": {
        "Destinations": {
          "get_users_by_email_address_destination": {
            "Address": "http://localhost:5026/"
          }
        }
      },
      "view_custom_cluster": {
        "Destinations": {
          "view_custom_destination": {
            "Address": "http://localhost:5027/"
          }
        }
      },
      "delete_custom_view_cluster": {
        "Destinations": {
          "delete_custom_view_destination": {
            "Address": "http://localhost:5028/"
          }
        }
      },
      "get_account_access_for_user_cluster": {
        "Destinations": {
          "get_account_access_for_user_destination": {
            "Address": "http://localhost:5029/"
          }
        }
      },
      "get_views_for_account_cluster": {
        "Destinations": {
          "get_views_for_account_destination": {
            "Address": "http://localhost:5030/"
          }
        }
      },
      "get_access_cluster": {
        "Destinations": {
          "get_access_destination": {
            "Address": "http://localhost:5031/"
          }
        }
      },
      "grant_user_access_to_view_cluster": {
        "Destinations": {
          "grant_user_access_to_view_destination": {
            "Address": "http://localhost:5032/"
          }
        }
      }
    }
  }
}
EOL

# Add RabbitMQ configuration to each service
add_rabbitmq_configuration() {
  local SERVICE_NAME=$1
  cd Services/$SERVICE_NAME
  cat >> appsettings.json <<EOL
{
  "MassTransit": {
    "RabbitMq": {
      "Host": "rabbitmq://localhost",
      "VirtualHost": "/",
      "Username": "guest",
      "Password": "guest"
    }
  }
}
EOL

  # Add MassTransit configuration to Program.cs
  sed -i 's/public static IHostBuilder CreateHostBuilder(string[] args) =>/public static IHostBuilder CreateHostBuilder(string[] args) =>\n            Host.CreateDefaultBuilder(args)\n                .ConfigureServices((context, services) =>\n                {\n                    services.AddMassTransit(x =>\n                    {\n                        x.UsingRabbitMq((context, cfg) =>\n                        {\n                            cfg.Host(context.Configuration["MassTransit:RabbitMq:Host"], h =>\n                            {\n                                h.Username(context.Configuration["MassTransit:RabbitMq:Username"]);\n                                h.Password(context.Configuration["MassTransit:RabbitMq:Password"]);\n                            });\n                        });\n                    });\n                    services.AddMassTransitHostedService();\n                })\n                .ConfigureWebHostDefaults(webBuilder =>/g' Program.cs
  cd ../..
}

# Add RabbitMQ configuration to each service
for SERVICE in "${SERVICES[@]}"
do
  add_rabbitmq_configuration $SERVICE
done

echo "Microservices and API Gateway created and configured successfully."
