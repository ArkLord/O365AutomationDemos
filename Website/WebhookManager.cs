using System;
using System.IO;
using System.Net;
using Newtonsoft.Json.Linq;

namespace WebApplicationBasic
{
    public class WebhookManager
    {
        public string WebhookUrl { get; set; }

        public static string ExecuteWebhook(string url)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.Headers["From"] = "user@contoso.com";
            request.Headers["Date"] = DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss");
            using (Stream requestStream = request.GetRequestStreamAsync().Result)
            using (var writer = new StreamWriter(requestStream))
            {
                writer.Write("[{'Name':  'vm01', 'ServiceName':  'vm01' },{'Name':  'vm02','ServiceName':  'vm02'}]");
            }

            WebResponse response = request.GetResponseAsync().Result;
            var jobId = "0";
            using (Stream responseStream = response.GetResponseStream())
            using (var reader = new StreamReader(responseStream))
            {
                var responseContent = reader.ReadToEnd();
                dynamic result = JObject.Parse(responseContent);
                jobId = result.JobIds[0].Value;
            }

            return jobId;
        }
    }
}
