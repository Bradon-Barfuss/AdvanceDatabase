CREATE TABLE [dbo].[ZIPCODES] (
    [Zipcode]   NVARCHAR (5)  NOT NULL,
    [City]      NVARCHAR (50) NOT NULL,
    [State]     NVARCHAR (2)  NOT NULL,
    [Latitude]  FLOAT (53)    NULL,
    [Longitude] FLOAT (53)    NULL,
    CONSTRAINT [PK_Zipcode] PRIMARY KEY CLUSTERED ([Zipcode] ASC)
);


GO

