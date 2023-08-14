using Microsoft.Data.SqlClient;
using System.Data;
using MaBanqueApi.Models;

namespace MaBanqueApi.Dao
{
    public class OperationDao
    {
        string conString = "Data Source=DESKTOP-OORU9G9\\MSSQLSERVER01;Initial Catalog=MaBanque;Integrated Security=True; TrustServerCertificate=True";

        public void addOperation(Operation ope)
        {
            SqlConnection con = new SqlConnection(conString);
            con.Open();
            SqlCommand cmd = new SqlCommand("AjouterOperation", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@type", ope.typeOp));
            cmd.Parameters.Add(new SqlParameter("@montant", ope.montant));
            cmd.Parameters.Add(new SqlParameter("@numCompte", ope.numCompte ));
            cmd.Parameters.Add(new SqlParameter("@numCompteBene", ope.numCompteBene));
            cmd.Parameters.Add(new SqlParameter("@dateOp", ope.dateOP));

            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}
