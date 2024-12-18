CREATE TABLE [dbo].[Customer] (
    [sdCustomer_id]         INT            IDENTITY (1, 1) NOT NULL,
    [customerEmailAddress]  NVARCHAR (255) NOT NULL,
    [customerFirstName]     NVARCHAR (50)  NOT NULL,
    [customerLastName]      NVARCHAR (50)  NOT NULL,
    [customerStreetAddress] NVARCHAR (255) NOT NULL,
    [customerCity]          NVARCHAR (50)  NOT NULL,
    [customerState]         NVARCHAR (2)   NOT NULL,
    [customerZip]           NVARCHAR (9)   NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([sdCustomer_id] ASC),
    CONSTRAINT [CK_Customer_Email] CHECK ([customerEmailAddress] like '%@%.%'),
    CONSTRAINT [CK_Customer_State] CHECK (upper([customerState])=([customerState]) collate Latin1_General_BIN2),
    CONSTRAINT [CK_Customer_Zip] CHECK ([customerZip] like '[0-9][0-9][0-9][0-9][0-9]' OR [customerZip] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT [AK_Customer_Email] UNIQUE NONCLUSTERED ([customerEmailAddress] ASC)
);


GO

