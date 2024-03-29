﻿// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.


using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using Serilog.Events;
using Serilog.Sinks.SystemConsole.Themes;
using System;
using System.Linq;

namespace IdentityServer_EF
{
  public class Program
  {
    public static int Main(string[] args)
    {
      var host = CreateHostBuilder(args).Build();
      var config = host.Services.GetRequiredService<IConfiguration>();

      Log.Logger = new LoggerConfiguration()
          .MinimumLevel.Debug()
          .MinimumLevel.Override("Microsoft", LogEventLevel.Debug)
          .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Debug)
          .MinimumLevel.Override("System", LogEventLevel.Debug)
          .MinimumLevel.Override("Microsoft.AspNetCore.Authentication", LogEventLevel.Debug)
          .MinimumLevel.Override("Microsoft.EntityFrameworkCore.Database.Command", LogEventLevel.Information)
          // uncomment to write to Azure diagnostics stream
          //.WriteTo.File(
          //    @"D:\home\LogFiles\Application\identityserver.txt",
          //    fileSizeLimitBytes: 1_000_000,
          //    rollOnFileSizeLimit: true,
          //    shared: true,
          //    flushToDiskInterval: TimeSpan.FromSeconds(1))
          .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level}] {SourceContext}{NewLine}{Message:lj}{NewLine}{Exception}{NewLine}", theme: AnsiConsoleTheme.Code)
          .Enrich.WithProperty("Source", "IdentityServer")
          .Enrich.WithProperty("OSVersion", Environment.OSVersion)
          .Enrich.WithProperty("ServerName", System.Net.Dns.GetHostName())
          .Enrich.WithProperty("UserName", Environment.UserName)
          .Enrich.WithProperty("UserDomainName", Environment.UserDomainName)
          .Enrich.WithProperty("Address", new Shared().GetHostIpAddress())
          .Enrich.FromLogContext()
          .ReadFrom.Configuration(config)
          .CreateLogger();

      try
      {
        var seed = args.Contains("/seed");
        if (seed)
        {
          args = args.Except(new[] { "/seed" }).ToArray();
        }

        if (seed)
        {
          Log.Information("Seeding database...");
          // var config = host.Services.GetRequiredService<IConfiguration>();
          var connectionString = config.GetConnectionString("MsSqlConnection");
          SeedData.EnsureSeedData(connectionString);
          Log.Information("Done seeding database.");
          return 0;
        }

        Log.Information("Starting host...");
        host.Run();
        return 0;
      }
      catch (Exception ex)
      {
        Log.Fatal(ex, "Host terminated unexpectedly.");
        return 1;
      }
      finally
      {
        Log.CloseAndFlush();
      }
    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .UseSerilog()
            .ConfigureWebHostDefaults(webBuilder =>
            {
              webBuilder.UseStartup<Startup>();
            });
  }
}