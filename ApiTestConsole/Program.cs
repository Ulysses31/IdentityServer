using System.Runtime.InteropServices;
using IdentityModel.Client;
using Newtonsoft.Json.Linq;

internal class Program
{
  private static void Main(string[] args)
  {

    string tokenEndPoint = GetTokenEndPoint().GetAwaiter().GetResult();

    System.Text.Json.JsonElement clientsCredTokenObj 
      = RequestClientCredentialsToken(tokenEndPoint).GetAwaiter().GetResult();

    JArray result = ApiCall(clientsCredTokenObj).GetAwaiter().GetResult();

    Console.WriteLine(result);
  }

  private async static Task<string> GetTokenEndPoint()
  {
    Console.WriteLine("Getting Discovery Document...\n");

    var client = new HttpClient();

    DiscoveryDocumentResponse disco 
      = await client.GetDiscoveryDocumentAsync("https://localhost:5001");

    if (disco.IsError)
    {
      //Console.WriteLine($"IsError: {disco.GetAwaiter().GetResult().IsError}\n");
      //Console.WriteLine($"Error: {disco.GetAwaiter().GetResult().Error}\n");
      throw new Exception(disco.Error);
    }

    Console.WriteLine($"Token Endpoint: {disco.TokenEndpoint}\n");

    return disco.TokenEndpoint;
  }


  private async static Task<System.Text.Json.JsonElement> RequestClientCredentialsToken(string tokenEndPoint)
  {
    Console.WriteLine("Getting Client Credentials Token from Identity Server...\n");

    var client = new HttpClient();

    TokenResponse tokenResponse 
      = await client.RequestClientCredentialsTokenAsync(
        new ClientCredentialsTokenRequest()
        {
          Address = tokenEndPoint,
          ClientId = "m2m.client",
          ClientSecret = "SuperSecretPassword",
          Scope = "weatherapi.read weatherapi.write"
        });


    if (tokenResponse.IsError)
    {
      //Console.WriteLine($"IsError: {tokenResponse.GetAwaiter().GetResult().IsError}\n");
      //Console.WriteLine($"Error: {tokenResponse.GetAwaiter().GetResult().Error}\n");
      throw new Exception(tokenResponse.Error);
    }

    Console.WriteLine($"Token Response: {tokenResponse.Json} \n");

    // var dict 
    //  = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, object>>(
    //   tokenResponse.Json
    // );

    return tokenResponse.Json;
  }


  private async static Task<JArray> ApiCall(
    System.Text.Json.JsonElement clientsCredTokenObj
  )
  {
    Dictionary<string, object> dict
        = System.Text.Json.JsonSerializer
          .Deserialize<Dictionary<string, object>>(clientsCredTokenObj);

    string access_token = dict["access_token"].ToString();

    // Console.WriteLine($"{access_token}\n");

    var client = new HttpClient();

    client.SetBearerToken(access_token);

    Console.WriteLine("Calling the Web API...\n");

    HttpResponseMessage response 
      = await client.GetAsync("https://localhost:7001/weatherforecast");

    if (!response.IsSuccessStatusCode)
    {
      // Console.WriteLine($"IsSuccessStatusCode: {response.IsSuccessStatusCode}\n");
      // Console.WriteLine($"Error: {response.StatusCode}\n");
      throw new Exception(response.StatusCode.ToString());
    }

    var content = await response.Content.ReadAsStringAsync();

    return JArray.Parse(content);
  }
}