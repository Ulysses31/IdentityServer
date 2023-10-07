ALTER TABLE clients
ADD COLUMN IF NOT EXISTS DPoPClockSkew TIME NOT NULL;

ALTER TABLE clients
ADD COLUMN IF NOT exists DPoPValidationMode INT NOT NULL;

ALTER TABLE clients
ADD COLUMN IF NOT exists InitiateLoginUri LONGTEXT;

ALTER TABLE clients
ADD COLUMN IF NOT exists RequireDPoP BIT NOT NULL;

UPDATE clients
SET 
	DPoPClockSkew = 5,
	DPoPValidationMode = 0,
	RequireDPoP = 0
WHERE Id = 1
	
