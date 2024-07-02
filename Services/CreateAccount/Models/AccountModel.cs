namespace CreateAccount.Models
{
    public class AccountModel
    {
        //hedhom fields mta3 luser
        
        public int Id { get; set; }
        public required string AccountName { get; set; }
        public decimal Balance { get; set; }
    }
}
