using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using IdentityServer4.AccessTokenValidation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
  options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
  {
    Name = "Authorization",
    Type = SecuritySchemeType.ApiKey,
    Scheme = "Bearer",
    BearerFormat = "JWT",
    In = ParameterLocation.Header,
    Description = "Type into the textbox: Bearer {your JWT token}."
  });
  options.AddSecurityRequirement(new OpenApiSecurityRequirement {
    {
    new OpenApiSecurityScheme {
      Reference = new OpenApiReference {
        Id = "Bearer",
        Type = ReferenceType.SecurityScheme
      }
    },
    Array.Empty<string>()
    }
  });
});


// Add Authentication
builder.Services.AddAuthentication(
  IdentityServerAuthenticationDefaults.AuthenticationScheme
)
    .AddIdentityServerAuthentication(
        (options) =>
        {
          options.ApiName = "weatherapi";
          options.Authority = "https://localhost:5001"; // Identity Server Address
          options.ApiSecret = "ScopeSecret";
          options.Validate(); 
        }
    );

// Add Authorization
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy(
      "weatherapi", 
      (policy) =>
    {
        policy.RequireAuthenticatedUser();
        policy.RequireClaim(
          "scope", 
          new string[] { "weatherapi" } 
        );
    });
    // options.AddPolicy("weatherapi.admin", policy =>
    // {
    //     policy.RequireAuthenticatedUser();
    //     policy.RequireClaim(
    //       "scope", 
    //       new string[] { "weatherapi.admin" } 
    //     );
    // });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
  app.UseSwagger();
  app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
//  .RequireAuthorization("weatherapi");

app.Run();
