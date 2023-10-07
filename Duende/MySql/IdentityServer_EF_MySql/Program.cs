using IdentityServer_EF_MsSql;
using Serilog;
using Serilog.Events;

Log.Logger = new LoggerConfiguration()
  .WriteTo.Console()
  .CreateBootstrapLogger();

Log.Information("Starting up");

try
{
  var builder = WebApplication.CreateBuilder(args);

  builder.Host.UseSerilog((ctx, lc) => lc
  .MinimumLevel.Debug()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Debug)
    .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Debug)
    .MinimumLevel.Override("System", LogEventLevel.Debug)
    .MinimumLevel.Override("Microsoft.AspNetCore.Authentication", LogEventLevel.Debug)
    .MinimumLevel.Override("Microsoft.EntityFrameworkCore.Database.Command", LogEventLevel.Information)
    .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level}] {SourceContext}{NewLine}{Message:lj}{NewLine}{Exception}{NewLine}")
    .Enrich.FromLogContext()
    .Enrich.WithProperty("Source", "WebAPI")
    .Enrich.WithProperty("OSVersion", Environment.OSVersion)
    .Enrich.WithProperty("ServerName", System.Net.Dns.GetHostName())
    .Enrich.WithProperty("UserName", Environment.UserName)
    .Enrich.WithProperty("UserDomainName", Environment.UserDomainName)
    .Enrich.WithProperty("Address", new Shared().GetHostIpAddress())
    .ReadFrom.Configuration(ctx.Configuration));

  var app = builder
    .ConfigureServices()
    .ConfigurePipeline();

  // this seeding is only for the template to bootstrap the DB and users.
  // in production you will likely want a different approach.
  if (args.Contains("/seed"))
  {
    Log.Information("Seeding database...");
    SeedData.EnsureSeedData(app);
    Log.Information("Done seeding database. Exiting.");
    return;
  }

  app.Run();
}
catch (Exception ex) when (
    // https://github.com/dotnet/runtime/issues/60600
    ex.GetType().Name is not "StopTheHostException"
    // HostAbortedException was added in .NET 7, but since we target .NET 6 we
    // need to do it this way until we target .NET 8
    && ex.GetType().Name is not "HostAbortedException"
)
{
  Log.Fatal(ex, "Unhandled exception");
}
finally
{
  Log.Information("Shut down complete");
  Log.CloseAndFlush();
}