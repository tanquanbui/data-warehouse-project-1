SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [bronze].[load_bronze]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        PRINT '====================';
        PRINT 'Loading bronze layer';
        PRINT '====================';

        SET @batch_start_time = GETDATE();

        BEGIN TRAN;

        PRINT '---------------------';
        PRINT 'Loading CRM tables';
        PRINT '---------------------';

        -- CRM CUST INFO
        PRINT '>>> TRUNCATING CRM CUST INFO';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM '/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED CRM CUST INFO';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';

        -- CRM PRD INFO
        PRINT '>>> TRUNCATING CRM PRD INFO';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM '/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED CRM PRD INFO';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';

        -- CRM SALES DETAILS
        PRINT '>>> TRUNCATING CRM SALES DETAILS';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM '/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED CRM SALES DETAILS';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';

        PRINT '---------------------';
        PRINT 'Loading ERP tables';
        PRINT '---------------------';

        -- ERP CUST AZ12
        PRINT '>>> TRUNCATING ERP CUST AZ12';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_CUST_AZ12;

        BULK INSERT bronze.erp_CUST_AZ12
        FROM '/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED ERP CUST AZ12';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';

        -- ERP LOC A101
        PRINT '>>> TRUNCATING ERP LOC A101';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_LOC_A101;

        BULK INSERT bronze.erp_LOC_A101
        FROM '/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED ERP LOC A101';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';

        -- ERP PX CAT G1V2
        PRINT '>>> TRUNCATING ERP PX CAT G1V2';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM '/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT 'LOADED ERP PX CAT G1V2';
        SET @end_time = GETDATE();
        PRINT '>>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        SET @batch_end_time = GETDATE();
        PRINT '>>> BATCH LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(20)) + 'seconds';
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE
            @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE(),
            @ErrNum INT = ERROR_NUMBER(),
            @ErrSev INT = ERROR_SEVERITY(),
            @ErrSta INT = ERROR_STATE(),
            @ErrLin INT = ERROR_LINE();

        PRINT 'ERROR: ' + @ErrMsg;
        ;THROW @ErrNum, @ErrMsg, @ErrSta;
    END CATCH
END
GO
