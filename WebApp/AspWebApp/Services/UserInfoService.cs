using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IdentityModel.Client;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;

namespace AspWebApp.Services
{
  public class UserInfoService : IUserInfoService
  {
    private readonly IOptions<IdentityServerSettings> _identityServerSettings;
    private readonly DiscoveryDocumentResponse _discoveryDocument;

    public UserInfoService(
        IOptions<IdentityServerSettings> identityServerSettings
    )
    {
      _identityServerSettings = identityServerSettings;

      using var httpClient = new HttpClient();

      _discoveryDocument = httpClient.GetDiscoveryDocumentAsync(
        _identityServerSettings.Value.DiscoveryUrl
      ).Result;

      if (_discoveryDocument.IsError)
      {
        throw new Exception(
          "Problem accessing the discovery endpoint.",
          _discoveryDocument.Exception
        );
      };

    }

    public async Task<UserInfoResponse> GetUserInfo(HttpContext context)
    {
      using var httpClient = new HttpClient();
      
      var accessToken = await context.GetTokenAsync(
          OpenIdConnectParameterNames.AccessToken
        );

      var userInfoResponse
        = await httpClient.GetUserInfoAsync(
            new UserInfoRequest()
            {
              Address = _discoveryDocument.UserInfoEndpoint,
              Token = accessToken
            }
        );

      if (userInfoResponse.IsError)
      {
        throw new Exception(
          "Problem accessing the UserInfo endpoint.",
          userInfoResponse.Exception
        );
      };

      return userInfoResponse;
    }
  }
}