using MaBanqueApi.Dao;
using MaBanqueApi.Models;
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace MaBanqueApi.Controllers
{
    public class ClientController : Controller
    {
        [Route("api/clients")]
        [HttpGet]
        [Produces("application/json")]
        public List<Client> GetClients()
        {
            List<Client> clients = new List<Client>();
            ClientDao clientDao = new ClientDao();
            clients = (List<Client>) clientDao.getClients();

            return clients;
        }

        [Route("api/client/add"), HttpPost]
        [Produces("application/json")]
        public HttpResponseMessage postClient([FromBody] ClientCompte cli)
        {
            if(cli != null)
            {
                try
                {
                    ClientDao clientDao = new ClientDao();
                    clientDao.postClient(cli);

                    var response = new HttpResponseMessage(HttpStatusCode.Created)
                    {
                        Content = new StringContent("Client ajouté avec succès"),
                        StatusCode = HttpStatusCode.OK,
                       
                    };

                    return response;
                }
                catch (Exception ex)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.BadRequest)
                    {
                        Content = new StringContent("le client ne peut pas etre inséré dans la base" + ex.Message),
                        StatusCode = HttpStatusCode.BadRequest
                    };
                    return response;
                }
            }
            else
            {
                var response = new HttpResponseMessage(HttpStatusCode.BadRequest)
                {
                    Content = new StringContent("Client introuvable"),
                    StatusCode = HttpStatusCode.BadRequest
                };

                return response;
            }
                



        }
    }
}
