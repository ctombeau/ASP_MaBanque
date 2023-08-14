using Microsoft.AspNetCore.Mvc;
using MaBanqueApi.Models;
using MaBanqueApi.Dao;
using System.Net;

namespace MaBanqueApi.Controllers
{
    public class OperationController : Controller
    {
        [Route("api/operation/add"),HttpPost]
        [Produces("application/json")]
        public HttpResponseMessage AddOperation([FromBody] Operation operation)
        {
            if(operation != null) 
            {
                try
                {
                
                    OperationDao operationDao = new OperationDao();
                    operationDao.addOperation(operation);

                    var response = new HttpResponseMessage(HttpStatusCode.Created)
                    {
                        Content = new StringContent("Operation ajoutée avec succès"),
                        StatusCode = HttpStatusCode.OK,

                    };

                    return response;
                }
                catch(Exception ex) 
                {
                    var response = new HttpResponseMessage(HttpStatusCode.BadRequest)
                    {
                        Content = new StringContent("L'operation ne peut pas etre insérée dans la base" + ex.Message),
                        StatusCode = HttpStatusCode.BadRequest
                    };
                    return response;
                }
            }
            else
            {
                var response = new HttpResponseMessage(HttpStatusCode.BadRequest)
                {
                    Content = new StringContent("Operation introuvable"),
                    StatusCode = HttpStatusCode.BadRequest
                };

                return response;
            }
        }

    }
}
