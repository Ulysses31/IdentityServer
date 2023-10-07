CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` NVARCHAR(150) NOT NULL PRIMARY KEY,
    `ProductVersion` NVARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS `ApiResources` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Enabled` INT NOT NULL,
    `Name` NVARCHAR(200) NOT NULL,
    `DisplayName` NVARCHAR(200) NULL,
    `Description` LONGTEXT NULL,
    `AllowedAccessTokenSigningAlgorithms` NVARCHAR(100) NULL,
    `ShowInDiscoveryDocument` TINYINT NOT NULL,
    `Created` DATETIME NOT NULL,
    `Updated` DATETIME NULL,
    `LastAccessed` DATETIME NULL,
    `NonEditable` TINYINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `ApiScopes` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Enabled` TINYINT NOT NULL,
    `Name` NVARCHAR(200) NOT NULL,
    `DisplayName` NVARCHAR(200) NULL,
    `Description` LONGTEXT NULL,
    `Required` TINYINT NOT NULL,
    `Emphasize` TINYINT NOT NULL,
    `ShowInDiscoveryDocument` TINYINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `Clients` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Enabled` TINYINT NOT NULL,
    `ClientId` NVARCHAR(200) NOT NULL,
    `ProtocolType` NVARCHAR(200) NOT NULL,
    `RequireClientSecret` BIT NOT NULL,
    `ClientName` NVARCHAR(200) NULL,
    `Description` LONGTEXT NULL,
    `ClientUri` LONGTEXT NULL,
    `LogoUri` LONGTEXT NULL,
    `RequireConsent` TINYINT NOT NULL,
    `AllowRememberConsent` TINYINT NOT NULL,
    `AlwaysIncludeUserClaimsInIdToken` TINYINT NOT NULL,
    `RequirePkce` TINYINT NOT NULL,
    `AllowPlainTextPkce` TINYINT NOT NULL,
    `RequireRequestObject` TINYINT NOT NULL,
    `AllowAccessTokensViaBrowser` TINYINT NOT NULL,
    `FrontChannelLogoutUri` LONGTEXT NULL,
    `FrontChannelLogoutSessionRequired` TINYINT NOT NULL,
    `BackChannelLogoutUri` LONGTEXT NULL,
    `BackChannelLogoutSessionRequired` TINYINT NOT NULL,
    `AllowOfflineAccess` TINYINT NOT NULL,
    `IdentityTokenLifetime` INT NOT NULL,
    `AllowedIdentityTokenSigningAlgorithms` NVARCHAR(100) NULL,
    `AccessTokenLifetime` INT NOT NULL,
    `AuthorizationCodeLifetime` INT NOT NULL,
    `ConsentLifetime` INT NULL,
    `AbsoluteRefreshTokenLifetime` INT NOT NULL,
    `SlidingRefreshTokenLifetime` INT NOT NULL,
    `RefreshTokenUsage` INT NOT NULL,
    `UpdateAccessTokenClaimsOnRefresh` TINYINT NOT NULL,
    `RefreshTokenExpiration` INT NOT NULL,
    `AccessTokenType` INT NOT NULL,
    `EnableLocalLogin` TINYINT NOT NULL,
    `IncludeJwtId` TINYINT NOT NULL,
    `AlwaysSendClientClaims` TINYINT NOT NULL,
    `ClientClaimsPrefix` NVARCHAR(200) NULL,
    `PairWiseSubjectSalt` NVARCHAR(200) NULL,
    `Created` DATETIME NOT NULL,
    `Updated` DATETIME NULL,
    `LastAccessed` DATETIME NULL,
    `UserSsoLifetime` INT NULL,
    `UserCodeType` NVARCHAR(100) NULL,
    `DeviceCodeLifetime` INT NOT NULL,
    `NonEditable` TINYINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `IdentityResources` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Enabled` TINYINT NOT NULL,
    `Name` NVARCHAR(200) NOT NULL,
    `DisplayName` NVARCHAR(200) NULL,
    `Description` LONGTEXT NULL,
    `Required` TINYINT NOT NULL,
    `Emphasize` TINYINT NOT NULL,
    `ShowInDiscoveryDocument` TINYINT NOT NULL,
    `Created` DATETIME NOT NULL,
    `Updated` DATETIME NULL,
    `NonEditable` TINYINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `ApiResourceClaims` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Type` NVARCHAR(200) NOT NULL,
    `ApiResourceId` INT NOT NULL,
    CONSTRAINT `FK_ApiResourceClaims_ApiResources_ApiResourceId` FOREIGN KEY (`ApiResourceId`) REFERENCES `ApiResources` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ApiResourceProperties` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Key` NVARCHAR(250) NOT NULL,
    `Value` LONGTEXT NOT NULL,
    `ApiResourceId` INT NOT NULL,
    CONSTRAINT `FK_ApiResourceProperties_ApiResources_ApiResourceId` FOREIGN KEY (`ApiResourceId`) REFERENCES `ApiResources` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ApiResourceScopes` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Scope` NVARCHAR(200) NOT NULL,
    `ApiResourceId` INT NOT NULL,
    CONSTRAINT `FK_ApiResourceScopes_ApiResources_ApiResourceId` FOREIGN KEY (`ApiResourceId`) REFERENCES `ApiResources` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ApiResourceSecrets` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Description` LONGTEXT NULL,
    `Value` LONGTEXT NOT NULL,
    `Expiration` DATETIME NULL,
    `Type` NVARCHAR(250) NOT NULL,
    `Created` DATETIME NOT NULL,
    `ApiResourceId` INT NOT NULL,
    CONSTRAINT `FK_ApiResourceSecrets_ApiResources_ApiResourceId` FOREIGN KEY (`ApiResourceId`) REFERENCES `ApiResources` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ApiScopeClaims` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Type` NVARCHAR(200) NOT NULL,
    `ScopeId` INT NOT NULL,
    CONSTRAINT `FK_ApiScopeClaims_ApiScopes_ScopeId` FOREIGN KEY (`ScopeId`) REFERENCES `ApiScopes` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ApiScopeProperties` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Key` NVARCHAR(250) NOT NULL,
    `Value` LONGTEXT NOT NULL,
    `ScopeId` INT NOT NULL,
    CONSTRAINT `FK_ApiScopeProperties_ApiScopes_ScopeId` FOREIGN KEY (`ScopeId`) REFERENCES `ApiScopes` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientClaims` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Type` NVARCHAR(250) NOT NULL,
    `Value` NVARCHAR(250) NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientClaims_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientCorsOrigins` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Origin` NVARCHAR(150) NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientCorsOrigins_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientGrantTypes` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `GrantType` NVARCHAR(250) NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientGrantTypes_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientIdPRestrictions` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Provider` NVARCHAR(200) NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientIdPRestrictions_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientPostLogoutRedirectUris` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `PostLogoutRedirectUri` LONGTEXT NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientPostLogoutRedirectUris_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientProperties` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Key` NVARCHAR(250) NOT NULL,
    `Value` LONGTEXT NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientProperties_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientRedirectUris` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `RedirectUri` LONGTEXT NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientRedirectUris_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientScopes` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Scope` NVARCHAR(200) NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientScopes_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `ClientSecrets` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Description` LONGTEXT NULL,
    `Value` LONGTEXT NOT NULL,
    `Expiration` DATETIME NULL,
    `Type` NVARCHAR(250) NOT NULL,
    `Created` DATETIME NOT NULL,
    `ClientId` INT NOT NULL,
    CONSTRAINT `FK_ClientSecrets_Clients_ClientId` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `IdentityResourceClaims` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Type` NVARCHAR(200) NOT NULL,
    `IdentityResourceId` INT NOT NULL,
    CONSTRAINT `FK_IdentityResourceClaims_IdentityResources_IdentityResourceId` FOREIGN KEY (`IdentityResourceId`) REFERENCES `IdentityResources` (`Id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `IdentityResourceProperties` (
    `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Key` NVARCHAR(250) NOT NULL,
    `Value` LONGTEXT NOT NULL,
    `IdentityResourceId` INT NOT NULL,
    CONSTRAINT `FK_IdentityResourceProperties_IdentityResources_IdentityResourceId` FOREIGN KEY (`IdentityResourceId`) REFERENCES `IdentityResources` (`Id`) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS `IX_ApiResourceClaims_ApiResourceId` ON `ApiResourceClaims` (`ApiResourceId`);

CREATE INDEX IF NOT EXISTS `IX_ApiResourceProperties_ApiResourceId` ON `ApiResourceProperties` (`ApiResourceId`);

CREATE UNIQUE INDEX IF NOT EXISTS `IX_ApiResources_Name` ON `ApiResources` (`Name`);

CREATE INDEX IF NOT EXISTS `IX_ApiResourceScopes_ApiResourceId` ON `ApiResourceScopes` (`ApiResourceId`);

CREATE INDEX IF NOT EXISTS `IX_ApiResourceSecrets_ApiResourceId` ON `ApiResourceSecrets` (`ApiResourceId`);

CREATE INDEX IF NOT EXISTS `IX_ApiScopeClaims_ScopeId` ON `ApiScopeClaims` (`ScopeId`);

CREATE INDEX IF NOT EXISTS `IX_ApiScopeProperties_ScopeId` ON `ApiScopeProperties` (`ScopeId`);

CREATE UNIQUE INDEX IF NOT EXISTS `IX_ApiScopes_Name` ON `ApiScopes` (`Name`);

CREATE INDEX IF NOT EXISTS `IX_ClientClaims_ClientId` ON `ClientClaims` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientCorsOrigins_ClientId` ON `ClientCorsOrigins` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientGrantTypes_ClientId` ON `ClientGrantTypes` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientIdPRestrictions_ClientId` ON `ClientIdPRestrictions` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientPostLogoutRedirectUris_ClientId` ON `ClientPostLogoutRedirectUris` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientProperties_ClientId` ON `ClientProperties` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientRedirectUris_ClientId` ON `ClientRedirectUris` (`ClientId`);

CREATE UNIQUE INDEX IF NOT EXISTS `IX_Clients_ClientId` ON `Clients` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientScopes_ClientId` ON `ClientScopes` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_ClientSecrets_ClientId` ON `ClientSecrets` (`ClientId`);

CREATE INDEX IF NOT EXISTS `IX_IdentityResourceClaims_IdentityResourceId` ON `IdentityResourceClaims` (`IdentityResourceId`);

CREATE INDEX IF NOT EXISTS `IX_IdentityResourceProperties_IdentityResourceId` ON `IdentityResourceProperties` (`IdentityResourceId`);

CREATE UNIQUE INDEX IF NOT EXISTS `IX_IdentityResources_Name` ON `IdentityResources` (`Name`);

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
VALUES ('20200624171023_Config', '3.1.0');
