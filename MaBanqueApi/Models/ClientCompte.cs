namespace MaBanqueApi.Models
{
    public class ClientCompte
    {
        public int idClient { get; set; }
        public string nom { get; set; }

        public string prenom { get; set; }

        public string username { get; set; }
        public string email { get; set; }

        public string password { get; set; }

        public string phone { get; set; }

        public int idCompte { get; set; }
        public string numeroCompte { get; set; }
        public string devise { get; set; }

        public string type { get; set; }

        public double solde { get; set; }
    }
}
