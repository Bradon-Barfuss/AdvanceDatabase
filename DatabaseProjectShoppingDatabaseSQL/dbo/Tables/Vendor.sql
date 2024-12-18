CREATE TABLE [dbo].[Vendor] (
    [sdVendor_id]         INT            IDENTITY (1, 1) NOT NULL,
    [vendorEmailAddress]  NVARCHAR (255) NOT NULL,
    [vendorName]          NVARCHAR (50)  NOT NULL,
    [vendorStreetAddress] NVARCHAR (255) NOT NULL,
    [vendorCity]          NVARCHAR (50)  NOT NULL,
    [vendorState]         NVARCHAR (2)   NOT NULL,
    [vendorZip]           NVARCHAR (9)   NOT NULL,
    [vendorPhone]         NVARCHAR (10)  NOT NULL,
    CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED ([sdVendor_id] ASC),
    CONSTRAINT [CK_Vendor_Email] CHECK ([vendorEmailAddress] like '%@%.%'),
    CONSTRAINT [CK_Vendor_Phone] CHECK ([vendorPhone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT [CK_Vendor_State] CHECK (upper([vendorState])=([vendorState]) collate Latin1_General_BIN2),
    CONSTRAINT [CK_Vendor_Zip] CHECK ([vendorZip] like '[0-9][0-9][0-9][0-9][0-9]' OR [vendorZip] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT [AK_Vendor_Name] UNIQUE NONCLUSTERED ([vendorName] ASC)
);


GO

