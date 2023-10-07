CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" NVARCHAR(150) NOT NULL CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY,
    "ProductVersion" NVARCHAR(32) NOT NULL
);

CREATE TABLE "ApiResources" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiResources" PRIMARY KEY IDENTITY(1,1),
    "Enabled" INT NOT NULL,
    "Name" NVARCHAR(200) NOT NULL,
    "DisplayName" NVARCHAR(200) NULL,
    "Description" NVARCHAR(MAX) NULL,
    "AllowedAccessTokenSigningAlgorithms" NVARCHAR(100) NULL,
    "ShowInDiscoveryDocument" BIT NOT NULL,
    "Created" DATETIME NOT NULL,
    "Updated" DATETIME NULL,
    "LastAccessed" DATETIME NULL,
    "NonEditable" BIT NOT NULL
);

CREATE TABLE "ApiScopes" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiScopes" PRIMARY KEY IDENTITY(1,1),
    "Enabled" BIT NOT NULL,
    "Name" NVARCHAR(200) NOT NULL,
    "DisplayName" NVARCHAR(200) NULL,
    "Description" NVARCHAR(MAX) NULL,
    "Required" BIT NOT NULL,
    "Emphasize" BIT NOT NULL,
    "ShowInDiscoveryDocument" BIT NOT NULL
);

CREATE TABLE "Clients" (
    "Id" INT NOT NULL CONSTRAINT "PK_Clients" PRIMARY KEY IDENTITY(1,1),
    "Enabled" BIT NOT NULL,
    "ClientId" NVARCHAR(200) NOT NULL,
    "ProtocolType" NVARCHAR(200) NOT NULL,
    "RequireClientSecret" BIT NOT NULL,
    "ClientName" NVARCHAR(200) NULL,
    "Description" NVARCHAR(MAX) NULL,
    "ClientUri" NVARCHAR(MAX) NULL,
    "LogoUri" NVARCHAR(MAX) NULL,
    "RequireConsent" BIT NOT NULL,
    "AllowRememberConsent" BIT NOT NULL,
    "AlwaysIncludeUserClaimsInIdToken" BIT NOT NULL,
    "RequirePkce" BIT NOT NULL,
    "AllowPlainTextPkce" BIT NOT NULL,
    "RequireRequestObject" BIT NOT NULL,
    "AllowAccessTokensViaBrowser" BIT NOT NULL,
    "FrontChannelLogoutUri" NVARCHAR(MAX) NULL,
    "FrontChannelLogoutSessionRequired" BIT NOT NULL,
    "BackChannelLogoutUri" NVARCHAR(MAX) NULL,
    "BackChannelLogoutSessionRequired" BIT NOT NULL,
    "AllowOfflineAccess" BIT NOT NULL,
    "IdentityTokenLifetime" INT NOT NULL,
    "AllowedIdentityTokenSigningAlgorithms" NVARCHAR(100) NULL,
    "AccessTokenLifetime" INT NOT NULL,
    "AuthorizationCodeLifetime" INT NOT NULL,
    "ConsentLifetime" INT NULL,
    "AbsoluteRefreshTokenLifetime" INT NOT NULL,
    "SlidingRefreshTokenLifetime" INT NOT NULL,
    "RefreshTokenUsage" INT NOT NULL,
    "UpdateAccessTokenClaimsOnRefresh" BIT NOT NULL,
    "RefreshTokenExpiration" INT NOT NULL,
    "AccessTokenType" INT NOT NULL,
    "EnableLocalLogin" BIT NOT NULL,
    "IncludeJwtId" BIT NOT NULL,
    "AlwaysSendClientClaims" BIT NOT NULL,
    "ClientClaimsPrefix" NVARCHAR(200) NULL,
    "PairWiseSubjectSalt" NVARCHAR(200) NULL,
    "Created" DATETIME NOT NULL,
    "Updated" DATETIME NULL,
    "LastAccessed" DATETIME NULL,
    "UserSsoLifetime" INT NULL,
    "UserCodeType" NVARCHAR(100) NULL,
    "DeviceCodeLifetime" INT NOT NULL,
    "NonEditable" BIT NOT NULL
);

CREATE TABLE "IdentityResources" (
    "Id" INT NOT NULL CONSTRAINT "PK_IdentityResources" PRIMARY KEY IDENTITY(1,1),
    "Enabled" BIT NOT NULL,
    "Name" NVARCHAR(200) NOT NULL,
    "DisplayName" NVARCHAR(200) NULL,
    "Description" NVARCHAR(MAX) NULL,
    "Required" BIT NOT NULL,
    "Emphasize" BIT NOT NULL,
    "ShowInDiscoveryDocument" BIT NOT NULL,
    "Created" DATETIME NOT NULL,
    "Updated" DATETIME NULL,
    "NonEditable" BIT NOT NULL
);

CREATE TABLE "ApiResourceClaims" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiResourceClaims" PRIMARY KEY IDENTITY(1,1),
    "Type" NVARCHAR(200) NOT NULL,
    "ApiResourceId" INT NOT NULL,
    CONSTRAINT "FK_ApiResourceClaims_ApiResources_ApiResourceId" FOREIGN KEY ("ApiResourceId") REFERENCES "ApiResources" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ApiResourceProperties" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiResourceProperties" PRIMARY KEY IDENTITY(1,1),
    "Key" NVARCHAR(250) NOT NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "ApiResourceId" INT NOT NULL,
    CONSTRAINT "FK_ApiResourceProperties_ApiResources_ApiResourceId" FOREIGN KEY ("ApiResourceId") REFERENCES "ApiResources" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ApiResourceScopes" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiResourceScopes" PRIMARY KEY IDENTITY(1,1),
    "Scope" NVARCHAR(200) NOT NULL,
    "ApiResourceId" INT NOT NULL,
    CONSTRAINT "FK_ApiResourceScopes_ApiResources_ApiResourceId" FOREIGN KEY ("ApiResourceId") REFERENCES "ApiResources" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ApiResourceSecrets" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiResourceSecrets" PRIMARY KEY IDENTITY(1,1),
    "Description" NVARCHAR(MAX) NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "Expiration" DATETIME NULL,
    "Type" NVARCHAR(250) NOT NULL,
    "Created" DATETIME NOT NULL,
    "ApiResourceId" INT NOT NULL,
    CONSTRAINT "FK_ApiResourceSecrets_ApiResources_ApiResourceId" FOREIGN KEY ("ApiResourceId") REFERENCES "ApiResources" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ApiScopeClaims" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiScopeClaims" PRIMARY KEY IDENTITY(1,1),
    "Type" NVARCHAR(200) NOT NULL,
    "ScopeId" INT NOT NULL,
    CONSTRAINT "FK_ApiScopeClaims_ApiScopes_ScopeId" FOREIGN KEY ("ScopeId") REFERENCES "ApiScopes" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ApiScopeProperties" (
    "Id" INT NOT NULL CONSTRAINT "PK_ApiScopeProperties" PRIMARY KEY IDENTITY(1,1),
    "Key" NVARCHAR(250) NOT NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "ScopeId" INT NOT NULL,
    CONSTRAINT "FK_ApiScopeProperties_ApiScopes_ScopeId" FOREIGN KEY ("ScopeId") REFERENCES "ApiScopes" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientClaims" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientClaims" PRIMARY KEY IDENTITY(1,1),
    "Type" NVARCHAR(250) NOT NULL,
    "Value" NVARCHAR(250) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientClaims_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientCorsOrigins" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientCorsOrigins" PRIMARY KEY IDENTITY(1,1),
    "Origin" NVARCHAR(150) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientCorsOrigins_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientGrantTypes" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientGrantTypes" PRIMARY KEY IDENTITY(1,1),
    "GrantType" NVARCHAR(250) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientGrantTypes_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientIdPRestrictions" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientIdPRestrictions" PRIMARY KEY IDENTITY(1,1),
    "Provider" NVARCHAR(200) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientIdPRestrictions_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientPostLogoutRedirectUris" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientPostLogoutRedirectUris" PRIMARY KEY IDENTITY(1,1),
    "PostLogoutRedirectUri" NVARCHAR(MAX) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientPostLogoutRedirectUris_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientProperties" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientProperties" PRIMARY KEY IDENTITY(1,1),
    "Key" NVARCHAR(250) NOT NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientProperties_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientRedirectUris" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientRedirectUris" PRIMARY KEY IDENTITY(1,1),
    "RedirectUri" NVARCHAR(MAX) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientRedirectUris_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientScopes" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientScopes" PRIMARY KEY IDENTITY(1,1),
    "Scope" NVARCHAR(200) NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientScopes_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ClientSecrets" (
    "Id" INT NOT NULL CONSTRAINT "PK_ClientSecrets" PRIMARY KEY IDENTITY(1,1),
    "Description" NVARCHAR(MAX) NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "Expiration" DATETIME NULL,
    "Type" NVARCHAR(250) NOT NULL,
    "Created" DATETIME NOT NULL,
    "ClientId" INT NOT NULL,
    CONSTRAINT "FK_ClientSecrets_Clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES "Clients" ("Id") ON DELETE CASCADE
);

CREATE TABLE "IdentityResourceClaims" (
    "Id" INT NOT NULL CONSTRAINT "PK_IdentityResourceClaims" PRIMARY KEY IDENTITY(1,1),
    "Type" NVARCHAR(200) NOT NULL,
    "IdentityResourceId" INT NOT NULL,
    CONSTRAINT "FK_IdentityResourceClaims_IdentityResources_IdentityResourceId" FOREIGN KEY ("IdentityResourceId") REFERENCES "IdentityResources" ("Id") ON DELETE CASCADE
);

CREATE TABLE "IdentityResourceProperties" (
    "Id" INT NOT NULL CONSTRAINT "PK_IdentityResourceProperties" PRIMARY KEY IDENTITY(1,1),
    "Key" NVARCHAR(250) NOT NULL,
    "Value" NVARCHAR(MAX) NOT NULL,
    "IdentityResourceId" INT NOT NULL,
    CONSTRAINT "FK_IdentityResourceProperties_IdentityResources_IdentityResourceId" FOREIGN KEY ("IdentityResourceId") REFERENCES "IdentityResources" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_ApiResourceClaims_ApiResourceId" ON "ApiResourceClaims" ("ApiResourceId");

CREATE INDEX "IX_ApiResourceProperties_ApiResourceId" ON "ApiResourceProperties" ("ApiResourceId");

CREATE UNIQUE INDEX "IX_ApiResources_Name" ON "ApiResources" ("Name");

CREATE INDEX "IX_ApiResourceScopes_ApiResourceId" ON "ApiResourceScopes" ("ApiResourceId");

CREATE INDEX "IX_ApiResourceSecrets_ApiResourceId" ON "ApiResourceSecrets" ("ApiResourceId");

CREATE INDEX "IX_ApiScopeClaims_ScopeId" ON "ApiScopeClaims" ("ScopeId");

CREATE INDEX "IX_ApiScopeProperties_ScopeId" ON "ApiScopeProperties" ("ScopeId");

CREATE UNIQUE INDEX "IX_ApiScopes_Name" ON "ApiScopes" ("Name");

CREATE INDEX "IX_ClientClaims_ClientId" ON "ClientClaims" ("ClientId");

CREATE INDEX "IX_ClientCorsOrigins_ClientId" ON "ClientCorsOrigins" ("ClientId");

CREATE INDEX "IX_ClientGrantTypes_ClientId" ON "ClientGrantTypes" ("ClientId");

CREATE INDEX "IX_ClientIdPRestrictions_ClientId" ON "ClientIdPRestrictions" ("ClientId");

CREATE INDEX "IX_ClientPostLogoutRedirectUris_ClientId" ON "ClientPostLogoutRedirectUris" ("ClientId");

CREATE INDEX "IX_ClientProperties_ClientId" ON "ClientProperties" ("ClientId");

CREATE INDEX "IX_ClientRedirectUris_ClientId" ON "ClientRedirectUris" ("ClientId");

CREATE UNIQUE INDEX "IX_Clients_ClientId" ON "Clients" ("ClientId");

CREATE INDEX "IX_ClientScopes_ClientId" ON "ClientScopes" ("ClientId");

CREATE INDEX "IX_ClientSecrets_ClientId" ON "ClientSecrets" ("ClientId");

CREATE INDEX "IX_IdentityResourceClaims_IdentityResourceId" ON "IdentityResourceClaims" ("IdentityResourceId");

CREATE INDEX "IX_IdentityResourceProperties_IdentityResourceId" ON "IdentityResourceProperties" ("IdentityResourceId");

CREATE UNIQUE INDEX "IX_IdentityResources_Name" ON "IdentityResources" ("Name");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20200624171023_Config', '3.1.0');

