using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi.Writers;
using Newtonsoft.Json;

namespace WebApi.Controllers;

[ApiController]
[Route("[controller]")]
// [Authorize("weatherapi.admin")]
[Authorize(Roles = "Admin")]
public class WeatherForecastController : ControllerBase
{
  private static readonly string[] Summaries = new[]
  {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

  private readonly ILogger<WeatherForecastController> _logger;

  public WeatherForecastController(ILogger<WeatherForecastController> logger)
  {
    _logger = logger;
  }

  [HttpGet(Name = "GetWeatherForecast")]
  public IEnumerable<WeatherForecast> Get()
  {
    WeatherForecast[] forecasts
        = Enumerable.Range(1, 5).Select(
            index => new WeatherForecast
            {
              Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
              TemperatureC = Random.Shared.Next(-20, 55),
              Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            }).ToArray();

    _logger.LogInformation($"Response: {JsonConvert.SerializeObject(forecasts)}");

    return forecasts;
  }
}
