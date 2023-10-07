using AspWebApp.Services;
using IdentityModel;
using Microsoft.AspNetCore.Authentication;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;

var builder = WebApplication.CreateBuilder(args);

JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear();

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.Configure<IdentityServerSettings>(
    builder.Configuration.GetSection("IdentityServerSettings")
);
builder.Services.AddSingleton<ITokenService, TokenService>();
builder.Services.AddSingleton<IUserInfoService, UserInfoService>();

builder.Services.AddAuthentication(options =>
{
  options.DefaultScheme = "cookie";
  options.DefaultChallengeScheme = "oidc";
})
.AddCookie("cookie", o => {
  o.ExpireTimeSpan = new TimeSpan(0, 2, 0);
  o.SlidingExpiration = true;
})
.AddOpenIdConnect("oidc", options =>
{
  options.SignInScheme = "cookie";
  options.Authority = builder.Configuration["InteractiveServiceSettings:AuthorityUrl"];
  options.ClientId = builder.Configuration["InteractiveServiceSettings:ClientId"];
  options.ClientSecret = builder.Configuration["InteractiveServiceSettings:ClientSecret"];

  options.ResponseType = OpenIdConnectResponseType.Code;
  options.ResponseMode = OpenIdConnectResponseMode.Query;
  options.UsePkce = true;

  options.Events.OnTicketReceived 
    = async (context) =>
  {
    await Task.FromResult(
      context.Properties.ExpiresUtc = DateTime.UtcNow.AddSeconds(120)
    );
  };

  // options.CallbackPath = "/signin-oidc"; // default redirect URI
 
  options.Scope.Add(builder.Configuration["InteractiveServiceSettings:Scopes:0"]);
  options.Scope.Add("address");
  options.Scope.Add("email");
  options.Scope.Add("roles");
  options.ClaimActions.MapJsonKey("role", "role", "roles");

  options.GetClaimsFromUserInfoEndpoint = true;
  options.SaveTokens = true;

  // if you want to remove CLAIMS from the token
  options.ClaimActions.DeleteClaim("sid");
  options.ClaimActions.DeleteClaim("idp");

  // if you want to add CLAIMS into Consent screen
  // options.Scope.Add("oidc"); // default scope
  // options.Scope.Add("profile"); // default scope

  options.TokenValidationParameters = new TokenValidationParameters
  {
    NameClaimType = JwtClaimTypes.Name,
    RoleClaimType = JwtClaimTypes.Role
  };
});
 

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
  app.UseExceptionHandler("/Home/Error");
  // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
  app.UseHsts();
}

// var cookiePolicyOptions = new CookiePolicyOptions
// {
//     MinimumSameSitePolicy = SameSiteMode.Strict,
// };

// app.UseCookiePolicy(cookiePolicyOptions);

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}"
);

app.Run();
