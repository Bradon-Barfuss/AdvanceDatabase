CREATE TABLE [dbo].[OrderTable] (
    [sdOrderTable_id] INT        IDENTITY (1, 1) NOT NULL,
    [sdCustomer_id]   INT        NOT NULL,
    [orderDateTime]   DATETIME   NOT NULL,
    [subTotal]        SMALLMONEY NULL,
    [taxAmount]       SMALLMONEY NULL,
    [shippingCost]    SMALLMONEY NULL,
    [orderTotal]      SMALLMONEY NULL,
    CONSTRAINT [PK_OrderTable] PRIMARY KEY CLUSTERED ([sdOrderTable_id] ASC),
    CONSTRAINT [FK_OrderTable_CustomerID] FOREIGN KEY ([sdCustomer_id]) REFERENCES [dbo].[Customer] ([sdCustomer_id]),
    CONSTRAINT [AK_OrderTable_OrderDateTime_CustomerID] UNIQUE NONCLUSTERED ([orderDateTime] ASC, [sdCustomer_id] ASC)
);


GO

