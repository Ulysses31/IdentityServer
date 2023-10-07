using AspWebApp.Services;
using IdentityModel.Client;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;

namespace AspWebApp.Controllers;

public class UserInfoController : Controller
{
  private readonly ILogger<UserInfoController> _logger;
  private readonly IUserInfoService _usrInfService;

  public UserInfoController(
    ILogger<UserInfoController> logger,
    IUserInfoService usrInfService
  )
  {
    _logger = logger;
    _usrInfService = usrInfService;
  }

  // [Authorize(Roles = "Admin")]
  public async Task<IActionResult> Index()
  {
    var usrInfo 
      = await _usrInfService.GetUserInfo(HttpContext);

    foreach (var claim in usrInfo.Claims)
		{
				_logger.LogInformation($"Claim type: {claim.Type} - Claim value: {claim.Value}");
    }

		_logger.LogInformation("\n");


    foreach (var claim in User.Claims)
		{
				_logger.LogInformation($"Claim type: {claim.Type} - Claim value: {claim.Value}");
    }

    return View(usrInfo.Claims);
  }

}
