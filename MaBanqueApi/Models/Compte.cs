namespace MaBanqueApi.Models
{
    public class Compte
    {
        public int idCompte { get; set; }
        public string numeroCompte { get; set; }
        public string devise { get; set; }

        public string type { get; set; }

        public double solde { get; set; }
    }
}
