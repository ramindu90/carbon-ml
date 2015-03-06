# DATASET
CREATE TABLE IF NOT EXISTS ML_DATASET(
DATASET_ID BIGINT AUTO_INCREMENT,
NAME VARCHAR(50),
TENANT_ID INT,
USERNAME VARCHAR(50),
COMMENTS TEXT,
SOURCE_TYPE VARCHAR(50),
TARGET_TYPE VARCHAR(50),
DATA_TYPE VARCHAR(50),
CONSTRAINT PK_DATASET PRIMARY KEY(DATASET_ID)
);

# DATASET_VERSION
CREATE TABLE IF NOT EXISTS ML_DATASET_VERSION(
DATASET_VERSION_ID BIGINT AUTO_INCREMENT,
DATASET_ID BIGINT,
TENANT_ID INT,
USERNAME VARCHAR(50),
VERSION VARCHAR(50),
CONSTRAINT PK_DATASET_VERSION PRIMARY KEY(DATASET_VERSION_ID),
CONSTRAINT FK_DATASET_DATASET_VERSION FOREIGN KEY(DATASET_ID) REFERENCES ML_DATASET(DATASET_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# FEATURE_DEFAULTS
CREATE TABLE IF NOT EXISTS ML_FEATURE_DEFAULTS(
DATASET_VERSION_ID BIGINT,
FEATURE_INDEX INT,
FEATURE_NAME VARCHAR(100) NOT NULL,
SUMMARY TEXT,
TYPE VARCHAR(20),
CONSTRAINT FK_DATASET_VERSION_FEATURE_DEFAULTS FOREIGN KEY(DATASET_VERSION_ID) REFERENCES ML_DATASET_VERSION(DATASET_VERSION_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# VALUE_SET
CREATE TABLE IF NOT EXISTS ML_VALUE_SET(
VALUE_SET_ID BIGINT AUTO_INCREMENT,
DATASET_VERSION_ID BIGINT,
NAME VARCHAR(50),
TENANT_ID INT,
USERNAME VARCHAR(50),
URI VARCHAR(300),
SAMPLE_POINTS BLOB,
CONSTRAINT PK_VALUE_SET PRIMARY KEY(VALUE_SET_ID),
CONSTRAINT FK_DATASET_VERSION_VALUE_SET FOREIGN KEY(DATASET_VERSION_ID) REFERENCES ML_DATASET_VERSION(DATASET_VERSION_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# DATA_SOURCE
CREATE TABLE IF NOT EXISTS ML_DATA_SOURCE(
VALUE_SET_ID BIGINT,
TENANT_ID INT,
USERNAME VARCHAR(50),
`KEY` VARCHAR(50),
VALUE VARCHAR(50),
CONSTRAINT FK_VALUE_SET_DATA_SOURCE FOREIGN KEY(VALUE_SET_ID) REFERENCES ML_VALUE_SET(VALUE_SET_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# PROJECT
CREATE TABLE IF NOT EXISTS ML_PROJECT(
PROJECT_ID BIGINT AUTO_INCREMENT,
NAME VARCHAR(50),
DESCRIPTION VARCHAR(100),
TENANT_ID INT,
USERNAME VARCHAR(5),
CREATED_TIME TIMESTAMP,
CONSTRAINT PK_PROJECT PRIMARY KEY(PROJECT_ID,TENANT_ID)
);

# ANALYSIS
CREATE TABLE IF NOT EXISTS ML_ANALYSIS(
ANALYSIS_ID BIGINT AUTO_INCREMENT,
PROJECT_ID BIGINT,
NAME VARCHAR(50),
TENANT_ID INT,
COMMENTS TEXT,
CONSTRAINT PK_ANALYSIS PRIMARY KEY(ANALYSIS_ID),
CONSTRAINT FK_PROJECT_ANALYSIS FOREIGN KEY(PROJECT_ID) REFERENCES ML_PROJECT(PROJECT_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# MODEL
CREATE TABLE IF NOT EXISTS ML_MODEL(
MODEL_ID BIGINT AUTO_INCREMENT,
ANALYSIS_ID BIGINT,
VALUE_SET_ID BIGINT,
TENANT_ID INT,
OUTPUT_MODEL VARCHAR(50),
USERNAME VARCHAR(50),
CREATED_TIME TIMESTAMP,
CONSTRAINT PK_MODEL PRIMARY KEY(MODEL_ID),
CONSTRAINT FK_ANALYSIS_MODEL FOREIGN KEY(ANALYSIS_ID) REFERENCES ML_ANALYSIS(ANALYSIS_ID),
CONSTRAINT FK_VALUE_SET_MODEL FOREIGN KEY(VALUE_SET_ID) REFERENCES ML_VALUE_SET(VALUE_SET_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# MODEL_CONFIGURATION
CREATE TABLE IF NOT EXISTS ML_MODEL_CONFIGURATION(
MODEL_ID BIGINT,
TENANT_ID INT,
USERNAME VARCHAR(50),
`KEY` VARCHAR(50),
VALUE VARCHAR(50),
TYPE VARCHAR(50),
CONSTRAINT FK_MODEL_MODEL_CONFIGURATION FOREIGN KEY(MODEL_ID) REFERENCES ML_MODEL(MODEL_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# FEATURE_CUSTOMIZED
CREATE TABLE IF NOT EXISTS ML_FEATURE_CUSTOMIZED(
MODEL_ID BIGINT,
TENANT_ID INT,
FEATURE_NAME VARCHAR(50),
IMPUTE_OPTION VARCHAR(50),
INCLUSION BOOLEAN,
LAST_MODIFIED_USER VARCHAR(50),
LAST_MODIFIED_TIME TIMESTAMP,
CONSTRAINT FK_MODEL_FEATURE_CUSTOMIZED FOREIGN KEY(MODEL_ID) REFERENCES ML_MODEL(MODEL_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

# HYPER_PARAMETER
CREATE TABLE IF NOT EXISTS ML_HYPER_PARAMETER(
MODEL_ID BIGINT,
NAME VARCHAR(50),
TENANT_ID INT,
VALUE VARCHAR(50),
LAST_MODIFIED_USER VARCHAR(50),
LAST_MODIFIED_TIME TIMESTAMP,
CONSTRAINT FK_MODEL_HYPER_PARAMETER FOREIGN KEY(MODEL_ID) REFERENCES ML_MODEL(MODEL_ID)
ON UPDATE CASCADE ON DELETE CASCADE
);