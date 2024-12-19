CREATE TABLE [dbo].[Supplier] (
    [sdSupplier_id]         INT            IDENTITY (1, 1) NOT NULL,
    [supplierName]          NVARCHAR (50)  NOT NULL,
    [supplierStreetAddress] NVARCHAR (255) NOT NULL,
    [supplierCity]          NVARCHAR (50)  NOT NULL,
    [supplierState]         NVARCHAR (2)   NOT NULL,
    [supplierZip]           NVARCHAR (9)   NOT NULL,
    CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([sdSupplier_id] ASC),
    CONSTRAINT [CK_Supplier_State] CHECK (upper([supplierState])=([supplierState]) collate Latin1_General_BIN2),
    CONSTRAINT [CK_Supplier_Zip] CHECK ([supplierZip] like '[0-9][0-9][0-9][0-9][0-9]' OR [supplierZip] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT [AK_Supplier_Name] UNIQUE NONCLUSTERED ([supplierName] ASC)
);


GO

