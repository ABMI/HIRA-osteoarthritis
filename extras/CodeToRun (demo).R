

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
outputFolder <- "/home/gansujin/storage/21/output/2024/osteoarthritis/drn/demo/T03"

# Specify where the temporary files (used by the ff package) will be created:
options(andromedaTempFolder="~/temp")

maxCores <- 128

# Details for connecting to the server:
DATABASECONNECTOR_JAR_FOLDER<- '~/Users/gansujin/path/mssql' 
Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = '~/Users/gansujin/path/mssql')
connectionDetails<-DatabaseConnector::createConnectionDetails (dbms="sql server",
                                                               server="10.5.99.50",
                                                               user="gansujin",
                                                               password="sujin30401@",
                                                               port="1433",
                                                               pathToDriver=
                                                                 DATABASECONNECTOR_JAR_FOLDER)
# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- "CDMPv535_ABMI.dbo"
# Add a sharebale name for the database containing the OMOP CDM data
cdmDatabaseName <- "AUSOM"
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- "cohortDb.dbo"

cohortTable <- 'sooj_drn_demo_oa_240610_T03'

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

databaseId = 'AUSOM'

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        databaseId = databaseId,
        #databaseName = databaseName,
        #databaseDescription = databaseDescription,
        verifyDependencies = F,
        createCohorts = T ,
        synthesizePositiveControls = F,
        runAnalyses = T,
        packageResults = T,
        maxCores = maxCores)

databaseId = 'AUSOM'

resultsZipFile <- file.path(outputFolder, "export", paste0("Results_", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")

# You can inspect the results if you want:
prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)
launchEvidenceExplorer(dataFolder = dataFolder, blind = FALSE, launch.browser = FALSE)

# Upload the results to the OHDSI SFTP server:
privateKeyFileName <- ""
userName <- ""
uploadResults(outputFolder, privateKeyFileName, userName)
