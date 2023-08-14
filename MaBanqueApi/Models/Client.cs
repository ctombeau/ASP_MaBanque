namespace MaBanqueApi.Models
{
    public class Client
    {
        public int id_client { get; set; }
        public string nom { get; set; }

        public string prenom { get; set; }

        public string username { get; set; }
        public string email { get; set; }

        public string password { get; set; }

        public string phone { get; set; }
    }
}
