using System.Net;
// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.


using IdentityModel;
using IdentityServer4;
using IdentityServer4.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace IdentityServer_InMem
{
  public static class Config
  {
    public static IEnumerable<IdentityResource> IdentityResources =>
        new IdentityResource[]
        {
             new IdentityResources.OpenId(),
             new IdentityResources.Profile(),
             new IdentityResources.Address(),
             new IdentityResources.Email(),
             new IdentityResource()
             {
               Name = "roles",
               Description = "User roles",
               UserClaims = new List<string> { "role" },
             }
        };

    public static IEnumerable<ApiScope> ApiScopes =>
        new ApiScope[]
        {
            new ApiScope("weatherapi", "The WeatherForecast Web API."),
        };

    public static IEnumerable<ApiResource> ApiResources =>
        new ApiResource[]
        {
          new ApiResource("weatherapi") {
              Scopes = new List<string> { "weatherapi" },
              ApiSecrets = new List<Secret> { new Secret("ScopeSecret".Sha256()) },
              UserClaims = new List<string> { "role" }
          }
        };

    public static IEnumerable<Client> Clients =>
        new Client[]
        {
           // m2m client credentials flow client
           new Client
           {
               ClientId = "m2m.client",
               ClientName = "Client Credentials Client",
               Description = "m2m.client.read",
               AllowedGrantTypes = GrantTypes.ClientCredentials,
               // ClientSecrets = { new Secret("SuperSecretPassword".Sha256()) },
               ClientSecrets = new List<Secret>() {
                new Secret("SuperSecretPassword".Sha256()),
                new Secret("SuperSecretPassword2".Sha256())
               },
               AllowedScopes = {
          	    IdentityServerConstants.StandardScopes.OpenId,
			    IdentityServerConstants.StandardScopes.Profile,
			    IdentityServerConstants.StandardScopes.Address,
			    IdentityServerConstants.StandardScopes.Email,
				"weatherapi"
               },
               AllowAccessTokensViaBrowser = false,
               //AccessTokenType = AccessTokenType.Reference
           },

           // postman
           new Client
           {
               ClientId = "m2m.client.postman",
               ClientName = "Client Credentials Client from Postman",
               Description = "m2m.client.postman",
               AllowedGrantTypes = GrantTypes.ResourceOwnerPasswordAndClientCredentials,
               // ClientSecrets = { new Secret("SuperSecretPassword".Sha256()) },
               ClientSecrets = new List<Secret>() {
                new Secret("SuperSecretPassword".Sha256()),
                new Secret("SuperSecretPassword2".Sha256())
               },
               AllowedScopes = {
          	    IdentityServerConstants.StandardScopes.OpenId,
			    IdentityServerConstants.StandardScopes.Profile,
			    IdentityServerConstants.StandardScopes.Address,
			    IdentityServerConstants.StandardScopes.Email,
				"weatherapi"
               },
               AllowAccessTokensViaBrowser = false,
               
               // refresh token
			   AllowOfflineAccess = true,

               IncludeJwtId = false,
			   AlwaysIncludeUserClaimsInIdToken = true,
			   AlwaysSendClientClaims = true,
			   UpdateAccessTokenClaimsOnRefresh = true,
			   
               IdentityTokenLifetime = 120,
			   AuthorizationCodeLifetime = 120,
			   SlidingRefreshTokenLifetime = 120,
               AccessTokenLifetime = 120,

			   //AccessTokenType = AccessTokenType.Reference
               RefreshTokenExpiration = TokenExpiration.Sliding
           },
       
           // This is for the AspWebApp project
           // interactive client using code flow + pkce
           new Client
           {
               ClientId = "interactive",
               ClientSecrets = { new Secret("SuperSecretPassword".Sha256()) },
               AllowedGrantTypes = GrantTypes.Code,

               RedirectUris = { "https://localhost:8001/signin-oidc" },
               FrontChannelLogoutUri = "https://localhost:8001/signout-oidc",
               PostLogoutRedirectUris = { "https://localhost:8001/signout-callback-oidc" },

               AllowOfflineAccess = true,
               AllowedScopes = {
                   IdentityServerConstants.StandardScopes.OpenId,
                   IdentityServerConstants.StandardScopes.Profile,
                   IdentityServerConstants.StandardScopes.Address,
                   IdentityServerConstants.StandardScopes.Email,
                   "weatherapi",
                   "roles"
               },

               RequirePkce = true,
               RequireConsent = true,
               AllowPlainTextPkce = false,

               IncludeJwtId = false,
			   AlwaysIncludeUserClaimsInIdToken = false,
			   AlwaysSendClientClaims = false,
			   UpdateAccessTokenClaimsOnRefresh = false,
			   
               IdentityTokenLifetime = 120,
			   AuthorizationCodeLifetime = 120,
			   SlidingRefreshTokenLifetime = 120,
               AccessTokenLifetime = 120,

			   //AccessTokenType = AccessTokenType.Reference
               RefreshTokenExpiration = TokenExpiration.Sliding
           }
        };


  }
}