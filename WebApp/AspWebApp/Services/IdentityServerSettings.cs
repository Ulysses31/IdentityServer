using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AspWebApp.Services
{
  public class IdentityServerSettings
  {
    public string DiscoveryUrl { get; set; }
    public string ClientName { get; set; }
    public string ClientPassword { get; set; }
    public bool UseHttps { get; set; }

  }
}