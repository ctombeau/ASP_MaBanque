using Microsoft.Extensions.Options;

namespace MaBanqueApi.Models
{
    public class Operation
    {
        public int idOperation { get; set; }
        public string typeOp { get; set; }
        public double montant { get; set; }
        public DateTime dateOP { get; set; }

        public string numCompte { get; set; }

        public string numCompteBene { get; set; }
    }
}
