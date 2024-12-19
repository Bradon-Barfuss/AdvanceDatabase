CREATE TABLE [dbo].[Product] (
    [sdProduct_id]  INT            IDENTITY (1, 1) NOT NULL,
    [sdSupplier_id] INT            NOT NULL,
    [productName]   NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([sdProduct_id] ASC),
    CONSTRAINT [FK_Product_SupplierID] FOREIGN KEY ([sdSupplier_id]) REFERENCES [dbo].[Supplier] ([sdSupplier_id]),
    CONSTRAINT [AK_Product_Name] UNIQUE NONCLUSTERED ([productName] ASC)
);


GO

