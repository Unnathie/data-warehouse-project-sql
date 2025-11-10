/*
Procedure: Bronze.load_bronze
Purpose:   Loads CRM and ERP data into Bronze layer tables using BULK INSERT
Author:    Unnathi E Naik
Date:      2025-11-10
Notes:     Ensure the file paths exist and SQL Server has BULK INSERT permissions
*/
CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
    BEGIN TRY
        DECLARE @start_time DATETIME,@end_time DATETIME,@bronze_start DATETIME,@bronze_end DATETIME
        SET @bronze_start=GETDATE()
        PRINT'=========================';
        PRINT 'LOADING THE BRONZE DATA';
        PRINT '========================';

        PRINT '------------------------';
        PRINT 'LOADING CRM Tables';
        PRINT '-------------------------';
        ----------FOR CRM--------------
        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.crm_cust_info';
        TRUNCATE TABLE Bronze.crm_cust_info;
        PRINT '>>INSERTING TABLE Bronze.crm_cust_info';
        BULK INSERT Bronze.crm_cust_info
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_crm\\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds'
        PRINT '--------------------------------------'

        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.crm_prd_info';
        TRUNCATE TABLE Bronze.crm_prd_info;
        PRINT '>>INSERTING TABLE Bronze.crm_prd_info';
        BULK INSERT Bronze.crm_prd_info
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_crm\\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds'
        PRINT '--------------------------------------'


        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.crm_sales_details';
        TRUNCATE TABLE Bronze.crm_sales_details;
        PRINT '>>INSERTING TABLE Bronze.crm_sales_details';
        BULK INSERT Bronze.crm_sales_details
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_crm\\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds'
        PRINT '--------------------------------------'


        PRINT '------------------------';
        PRINT 'LOADING ERP Tables';
        PRINT '-------------------------';
    ---------------ERP-------------------------
        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.erp_cust_az12';
        TRUNCATE TABLE Bronze.erp_cust_az12;
        PRINT '>>INSERTING TABLE Bronze.erp_cust_az12';
        BULK INSERT Bronze.erp_cust_az12
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_erp\\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds'
        PRINT '--------------------------------------'

        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.erp_loc_a101';
        TRUNCATE TABLE Bronze.erp_loc_a101;
        PRINT '>>INSERTING TABLE Bronze.erp_loc_a101';
        BULK INSERT Bronze.erp_loc_a101
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_erp\\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds'
        PRINT '--------------------------------------'

        SET @start_time=GETDATE()
        PRINT '>>TRUNCATING TABLE Bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
        PRINT '>>INSERTING TABLE Bronze.erp_px_cat_g1v2';
        BULK INSERT Bronze.erp_px_cat_g1v2
        FROM 'C:\\Users\\hp\\Desktop\\sql-ultimate-course\\sql-data-warehouse-project-main\\datasets\\source_erp\\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT 'TIME DURATION:'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
        PRINT '--------------------------------------';
        SET @bronze_end=GETDATE();
        PRINT'===================================';
        PRINT 'COMPLETION OF BRONZE DATA LOADING'
        PRINT '     -COMPLETE DURATION: '+CAST(DATEDIFF(SECOND,@bronze_start,@bronze_end) AS NVARCHAR)+' SECONDS';
        PRINT'==================================';
    END TRY
    BEGIN CATCH
    PRINT '--------------------------------------------'
    PRINT 'ERROR OCCURED WHILE LOADING BRONZE-DATA!';
    PRINT 'ERROR MESSAGE:'+ ERROR_MESSAGE();
    PRINT 'ERROR NUMBER:'+CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'ERROR STATUS:'+CAST(ERROR_STATE() AS NVARCHAR);
    PRINT '---------------------------------------------'
    END CATCH
END
