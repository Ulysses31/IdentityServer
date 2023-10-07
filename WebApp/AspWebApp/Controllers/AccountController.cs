using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using AspWebApp.Models;
using IdentityModel;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace AspWebApp.Controllers
{
  public class AccountController : Controller
  {
    private readonly ILogger<AccountController> _logger;
    // private readonly SignInManager<ApplicationUser> _signInManager;

    public AccountController(
      ILogger<AccountController> logger
    // SignInManager<ApplicationUser> signInManager
    )
    {
      _logger = logger;
      // _signInManager = signInManager;
    }

    public IActionResult Index()
    {
      return View();
    }

    [Authorize]
    public IActionResult Login()
    {
      return RedirectToAction("index", "home");
    }

    public async Task Logout()
    {
      await HttpContext.SignOutAsync("cookie");
      await HttpContext.SignOutAsync("oidc");
    }

    public IActionResult AccessDenied()
    {
      return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
      return View("Error!");
    }
  }
}