using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace IdentityServer_EF_SQLite.Pages.Admin;

[SecurityHeaders]
[Authorize]
public class IndexModel : PageModel
{
    public void OnGet()
    {

    }
}