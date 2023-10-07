using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using AspWebApp.Models;
using System.Text.Json.Serialization;
using Newtonsoft.Json;
using AspWebApp.Services;
using IdentityModel.Client;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;

namespace AspWebApp.Controllers;

public class HomeController : Controller
{
  private readonly ILogger<HomeController> _logger;
  // private readonly ITokenService _tokenService;

  public HomeController(
    ILogger<HomeController> logger
    // ITokenService tokenService
  )
  {
    _logger = logger;
    //_tokenService = tokenService;
  }

  public IActionResult Index()
  {
    return View();
  }

  public IActionResult Privacy()
  {
    return View();
  }

  [Authorize(Roles = "Admin")]
  public async Task<IActionResult> Weather()
  {
    _logger.LogInformation("Weather view called...");

    using (var client = new HttpClient())
    {
      _logger.LogInformation("Calling API https://localhost:7001/weatherforecast ...");

      // var tokenResponse
      //   = await _tokenService.GetToken("weatherapi.read");

      var tokenResponse
        = await HttpContext.GetTokenAsync("access_token");

      // client.SetBearerToken(tokenResponse.AccessToken);
      
      client.SetBearerToken(tokenResponse);

      var result
        = await client.GetAsync("https://localhost:7001/weatherforecast");

      if (!result.IsSuccessStatusCode)
      {
        throw new Exception($"Unable to get weather content. {result.StatusCode}");
      }

      var model = await result.Content.ReadAsStringAsync();

      List<WeatherData> data
        = JsonConvert.DeserializeObject<List<WeatherData>>(model);

      _logger.LogInformation($"Response: {model}");

      return View(data);
    }
  }

  [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
  public IActionResult Error()
  {
    return View(
        new ErrorViewModel
        {
          RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier
        }
    );
  }
}
