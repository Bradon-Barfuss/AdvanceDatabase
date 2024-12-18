CREATE TABLE [dbo].[VendorProduct] (
    [sdVendor_id]        INT        NOT NULL,
    [sdProduct_id]       INT        NOT NULL,
    [quantityOnHand]     INT        NOT NULL,
    [vendorProductPrice] SMALLMONEY NOT NULL,
    CONSTRAINT [PK_VendorProduct] PRIMARY KEY CLUSTERED ([sdVendor_id] ASC, [sdProduct_id] ASC),
    CONSTRAINT [FK_VendorProduct_ProductID] FOREIGN KEY ([sdProduct_id]) REFERENCES [dbo].[Product] ([sdProduct_id]),
    CONSTRAINT [FK_VendorProduct_VendorID] FOREIGN KEY ([sdVendor_id]) REFERENCES [dbo].[Vendor] ([sdVendor_id])
);


GO

