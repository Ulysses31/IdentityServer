using System.Collections.Immutable;
using Duende.IdentityServer;
using IdentityServer_EF_SQLite;
using IdentityServer_EF_SQLite.Database;
using IdentityServer_EF_SQLite.Pages.Admin.ApiScopes;
using IdentityServer_EF_SQLite.Pages.Admin.Clients;
using IdentityServer_EF_SQLite.Pages.Admin.IdentityScopes;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Serilog;

namespace IdentityServer_EF_SQLite;

internal static class HostingExtensions
{
  public static WebApplication ConfigureServices(this WebApplicationBuilder builder)
  {
    builder.Services.AddRazorPages();

    var connectionString = builder.Configuration.GetConnectionString("SqlLiteConnection");

    builder.Services.AddDbContext<ApplicationDbContext>(options =>
      {
        options.UseSqlite(
          connectionString,
          sqlOptions => sqlOptions.MigrationsAssembly(typeof(Program).Assembly.FullName)
        )
        .EnableDetailedErrors()
        .EnableSensitiveDataLogging();
      });

    builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
     {
       options.User.RequireUniqueEmail = true;
     })
       .AddEntityFrameworkStores<ApplicationDbContext>();

    var isBuilder = builder.Services
      .AddIdentityServer(options =>
      {
        options.Events.RaiseErrorEvents = true;
        options.Events.RaiseInformationEvents = true;
        options.Events.RaiseFailureEvents = true;
        options.Events.RaiseSuccessEvents = true;

        // see https://docs.duendesoftware.com/identityserver/v5/fundamentals/resources/
        options.EmitStaticAudienceClaim = true;
      })
      .AddTestUsers(TestUsers.Users)
      // this adds the config data from DB (clients, resources, CORS)
      .AddConfigurationStore(options =>
      {
        options.ConfigureDbContext = b =>
          b.UseSqlite(
            connectionString,
            dbOpts => dbOpts.MigrationsAssembly(typeof(Program).Assembly.FullName)
          )
          .EnableDetailedErrors()
          .EnableSensitiveDataLogging();
      })
      // this is something you will want in production to reduce load on and requests to the DB
      //.AddConfigurationStoreCache()
      //
      // this adds the operational data from DB (codes, tokens, consents)
      .AddOperationalStore(options =>
      {
        options.ConfigureDbContext = b =>
          b.UseSqlite(
            connectionString,
            dbOpts => dbOpts.MigrationsAssembly(typeof(Program).Assembly.FullName)
          )
          .EnableDetailedErrors()
          .EnableSensitiveDataLogging();

        // this enables automatic token cleanup. this is optional.
        options.EnableTokenCleanup = true;
      });

    builder.Services.AddAuthentication()
      .AddGoogle(options =>
      {
        options.SignInScheme = IdentityServerConstants.ExternalCookieAuthenticationScheme;

        // register your IdentityServer with Google at https://console.developers.google.com
        // enable the Google+ API
        // set the redirect URI to https://localhost:5001/signin-google
        options.ClientId = "copy client ID from Google here";
        options.ClientSecret = "copy client secret from Google here";
      });


    // this adds the necessary config for the simple admin/config pages
    {
      builder.Services.AddAuthorization(options =>
          options.AddPolicy("admin",
              policy => policy.RequireClaim("sub", "1"))
      );

      builder.Services.Configure<RazorPagesOptions>(options =>
          options.Conventions.AuthorizeFolder("/Admin", "admin"));

      builder.Services.AddTransient<IdentityServer_EF_SQLite.Pages.Portal.ClientRepository>();
      builder.Services.AddTransient<ClientRepository>();
      builder.Services.AddTransient<IdentityScopeRepository>();
      builder.Services.AddTransient<ApiScopeRepository>();
    }

    // if you want to use server-side sessions: https://blog.duendesoftware.com/posts/20220406_session_management/
    // then enable it
    //isBuilder.AddServerSideSessions();
    //
    // and put some authorization on the admin/management pages using the same policy created above
    //builder.Services.Configure<RazorPagesOptions>(options =>
    //    options.Conventions.AuthorizeFolder("/ServerSideSessions", "admin"));

    return builder.Build();
  }

  public static WebApplication ConfigurePipeline(this WebApplication app)
  {
    app.UseSerilogRequestLogging();

    if (app.Environment.IsDevelopment())
    {
      app.UseDeveloperExceptionPage();
    }

    app.UseStaticFiles();
    app.UseRouting();
    app.UseIdentityServer();
    app.UseAuthorization();

    app.MapRazorPages()
        .RequireAuthorization();

    return app;
  }
}