using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IdentityModel.Client;

namespace AspWebApp.Services
{
  public interface IUserInfoService
  {
    Task<UserInfoResponse> GetUserInfo(HttpContext context);
  }
}