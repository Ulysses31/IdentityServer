CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" NVARCHAR(150) NOT NULL CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY,
    "ProductVersion" NVARCHAR(32) NOT NULL
);

CREATE TABLE "DeviceCodes" (
    "UserCode" NVARCHAR(200) NOT NULL CONSTRAINT "PK_DeviceCodes" PRIMARY KEY,
    "DeviceCode" NVARCHAR(200) NOT NULL,
    "SubjectId" NVARCHAR(200) NULL,
    "SessionId" NVARCHAR(100) NULL,
    "ClientId" NVARCHAR(200) NOT NULL,
    "Description" NVARCHAR(200) NULL,
    "CreationTime" DATETIME NOT NULL,
    "Expiration" DATETIME NOT NULL,
    "Data" NVARCHAR(MAX) NOT NULL
);

CREATE TABLE "PersistedGrants" (
    "Key" NVARCHAR(200) NOT NULL CONSTRAINT "PK_PersistedGrants" PRIMARY KEY,
    "Type" NVARCHAR(50) NOT NULL,
    "SubjectId" NVARCHAR(200) NULL,
    "SessionId" NVARCHAR(100) NULL,
    "ClientId" NVARCHAR(200) NOT NULL,
    "Description" NVARCHAR(200) NULL,
    "CreationTime" DATETIME NOT NULL,
    "Expiration" DATETIME NULL,
    "ConsumedTime" DATETIME NULL,
    "Data" NVARCHAR(MAX) NOT NULL
);

CREATE UNIQUE INDEX "IX_DeviceCodes_DeviceCode" ON "DeviceCodes" ("DeviceCode");

CREATE INDEX "IX_DeviceCodes_Expiration" ON "DeviceCodes" ("Expiration");

CREATE INDEX "IX_PersistedGrants_Expiration" ON "PersistedGrants" ("Expiration");

CREATE INDEX "IX_PersistedGrants_SubjectId_ClientId_Type" ON "PersistedGrants" ("SubjectId", "ClientId", "Type");

CREATE INDEX "IX_PersistedGrants_SubjectId_SessionId_Type" ON "PersistedGrants" ("SubjectId", "SessionId", "Type");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20200624171018_Grants', '3.1.0');

