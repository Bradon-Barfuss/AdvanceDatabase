CREATE TABLE [dbo].[OrderItem] (
    [sdOrderTable_id] INT      NOT NULL,
    [sdProduct_id]    INT      NOT NULL,
    [sdVendor_id]     INT      NOT NULL,
    [quantity]        SMALLINT NOT NULL,
    CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED ([sdOrderTable_id] ASC, [sdProduct_id] ASC, [sdVendor_id] ASC),
    CONSTRAINT [FK_OrderItem_OrderTableID] FOREIGN KEY ([sdOrderTable_id]) REFERENCES [dbo].[OrderTable] ([sdOrderTable_id]),
    CONSTRAINT [FK_OrderItem_ProductID] FOREIGN KEY ([sdProduct_id]) REFERENCES [dbo].[Product] ([sdProduct_id]),
    CONSTRAINT [FK_OrderItem_VendorID] FOREIGN KEY ([sdVendor_id]) REFERENCES [dbo].[Vendor] ([sdVendor_id])
);


GO

