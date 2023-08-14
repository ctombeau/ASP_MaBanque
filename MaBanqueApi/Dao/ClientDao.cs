using MaBanqueApi.Models;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Data.Common;

namespace MaBanqueApi.Dao
{
    public class ClientDao
    {
        string conString = "Data Source=DESKTOP-OORU9G9\\MSSQLSERVER01;Initial Catalog=MaBanque;Integrated Security=True; TrustServerCertificate=True";

        public IEnumerable<Client> getClients()
        {
            List<Client> clients = new List<Client>();
            SqlConnection con = new SqlConnection(conString);
            con.Open();
            string sql = "select * from client";
            SqlCommand cmd = new SqlCommand(sql, con);
            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read()) 
            {
                Client client = new Client();
                client.id_client= Convert.ToInt32(dr["id_client"]);
                client.nom = dr["nom"].ToString();
                client.prenom = dr["prenom"].ToString();
                client.username = dr["username"].ToString();
                client.email = dr["email"].ToString();
                client.password = dr["password"].ToString();
                client.phone = dr["phone"].ToString();

                clients.Add(client);
            }
            return clients;
        }

        public void postClient(ClientCompte cli)
        {
            SqlConnection con = new SqlConnection(conString);
            con.Open();
            SqlCommand cmd = new SqlCommand("AddClientWithCompte",con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@nom", cli.nom));
            cmd.Parameters.Add(new SqlParameter("@prenom", cli.prenom));
            cmd.Parameters.Add(new SqlParameter("@username", cli.username));
            cmd.Parameters.Add(new SqlParameter("@email", cli.email));
            cmd.Parameters.Add(new SqlParameter("@password", cli.password));
            cmd.Parameters.Add(new SqlParameter("@phone", cli.phone));
            cmd.Parameters.Add(new SqlParameter("@devise", cli.devise));
            cmd.Parameters.Add(new SqlParameter("@type", cli.type));
            cmd.Parameters.Add(new SqlParameter("@solde", cli.solde));

            cmd.ExecuteNonQuery();
            con.Close();

        }
    }
}
