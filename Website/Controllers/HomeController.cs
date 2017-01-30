using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace WebApplicationBasic.Controllers
{
    public class HomeController : Controller
    {
        private readonly IOptions<WebhookManager> WebhookManagerObject;

        public HomeController(IOptions<WebhookManager> webhookManager)
        {
            this.WebhookManagerObject = webhookManager;
        }

        public IActionResult Index()
        {
            return View();
        }

       [HttpPost]
        public IActionResult Index(string alias, string license)
        {
            ViewData["JobId"] = WebhookManager.ExecuteWebhook(WebhookManagerObject.Value.WebhookUrl);
            return View();
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
