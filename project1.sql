CREATE TABLE Agency (
    agency_code INTEGER PRIMARY KEY,
    agency_abbr VARCHAR(5),
    agency_name VARCHAR(100)
);

CREATE TABLE Purchaser (
    purchaser_type INTEGER PRIMARY KEY,
    purchaser_type_name VARCHAR(100)
);

CREATE TABLE Census_data (
    state_code INTEGER NOT NULL,
    county_code INTEGERnNOT NULL,
    census_tract_number VARCHAR(20) NOT NULL,
    population INTEGER,
    minority_population DECIMAL(10,6),
    hud_median_family_income  INTEGER,
    tract_to_msamd_income DECIMAL(10,6),
    number_of_owner_occupied_units INTEGER,
    number_of_1_to_4_family_units INTEGER,
    PRIMARY KEY (state_code, county_code, census_tract_number)
);

CREATE TABLE Lender (
    respondent_id VARCHAR(20) PRIMARY KEY,
    agency_code INTEGER NOT NULL REFERENCES Agency (agency_code)
);

CREATE TABLE Property (
    locationID INTEGER PRIMARY KEY,
    property_type INTEGER,
    property_type_name VARCHAR(100),
    owner_occupancy INTEGER,
    owner_occupancy_name VARCHAR(100),
    state_name VARCHAR(15),
    state_abbr VARCHAR(2),
    state_code INTEGER,
    county_name VARCHAR(40),
    county_code INTEGER,
    census_tract_number VARCHAR(10),
    msamd INTEGER,
    msamd_name VARCHAR(60),
    FOREIGN KEY (state_code, county_code, census_tract_number) REFERENCES Census_data (state_code, county_code, census_tract_number)
);

CREATE TABLE Application (
    sequence_number INTEGER PRIMARY KEY,
    as_of_year INTEGER NOT NULL CHECK (as_of_year = 2017),
    action_taken INTEGER,
    action_taken_name VARCHAR(100),
    preapproval INTEGER,
    preapproval_name VARCHAR(100),
    application_date_indicator INTEGER,
    edit_status INTEGER,
    edit_status_name VARCHAR(100),
    respondent_id VARCHAR(20) NOT NULL,
    locationID INTEGER NOT NULL,
    FOREIGN KEY (locationID) REFERENCES Property (locationID),
    FOREIGN KEY (respondent_id) REFERENCES Lender (respondent_id),
    UNIQUE (locationID)
);

CREATE TABLE Loan_Terms (
    sequence_number INTEGER PRIMARY KEY,
    loan_type INTEGER,
    loan_type_name VARCHAR(100),
    loan_purpose INTEGER,
    loan_purpose_name VARCHAR(100),
    loan_amount_000s INTEGER CHECK (loan_amount_000s > 0),
    purchaser_type INTEGER NOT NULL,
    FOREIGN KEY (sequence_number) REFERENCES Application (sequence_number),
    FOREIGN KEY (purchaser_type) REFERENCES Purchaser (purchaser_type)
);

CREATE TABLE Compliance (
    sequence_number INTEGER PRIMARY KEY,
    rate_spread DECIMAL(8,4),
    hoepa_status INTEGER,
    hoepa_status_name VARCHAR(100),
    lien_status INTEGER,
    lien_status_name VARCHAR(100),
    FOREIGN KEY (sequence_number) REFERENCES Loan_Terms (sequence_number)
);

CREATE TABLE Applicant (
    sequence_number INTEGER PRIMARY KEY,
    applicant_ethnicity INTEGER,
    applicant_ethnicity_name VARCHAR(50),
    applicant_race_1 INTEGER,
    applicant_race_name_1 VARCHAR(50),
    applicant_race_2 INTEGER,
    applicant_race_name_2 VARCHAR(50),
    applicant_race_3 INTEGER,
    applicant_race_name_3 VARCHAR(50),
    applicant_race_4 INTEGER,
    applicant_race_name_4 VARCHAR(50),
    applicant_race_5 INTEGER,
    applicant_race_name_5 VARCHAR(50),
    applicant_sex INTEGER,
    applicant_sex_name VARCHAR(50),
    applicant_income_000s INTEGER,
    FOREIGN KEY (sequence_number) REFERENCES Application (sequence_number)
);

CREATE TABLE Co_Applicant (
    sequence_number INTEGER PRIMARY KEY,
    co_applicant_ethnicity INTEGER,
    co_applicant_ethnicity_name VARCHAR(50),
    co_applicant_race_1 INTEGER,
    co_applicant_race_name_1 VARCHAR(50),
    co_applicant_race_2 INTEGER,
    co_applicant_race_name_2 VARCHAR(50),
    co_applicant_race_3 INTEGER,
    co_applicant_race_name_3 VARCHAR(50),
    co_applicant_race_4 INTEGER,
    co_applicant_race_name_4 VARCHAR(50),
    co_applicant_race_5 INTEGER,
    co_applicant_race_name_5 VARCHAR(50),
    co_applicant_sex  INTEGER,
    co_applicant_sex_name VARCHAR(50),
    FOREIGN KEY (sequence_number) REFERENCES Applicant (sequence_number)
);

CREATE TABLE Denial_Reasons (
    sequence_number INTEGER PRIMARY KEY,
    denial_reason_1 INTEGER,
    denial_reason_name_1 VARCHAR(100),
    denial_reason_2 INTEGER,
    denial_reason_name_2 VARCHAR(100),
    denial_reason_3 INTEGER,
    denial_reason_name_3 VARCHAR(100),
    FOREIGN KEY (sequence_number) REFERENCES Application (sequence_number)
);

INSERT INTO Agency (agency_code, agency_abbr, agency_name) VALUES
    (1, 'OCC',  'Office of the Comptroller of the Currency'),
    (2, 'FRS',  'Federal Reserve System'),
    (3, 'FDIC', 'Federal Deposit Insurance Corporation'),
    (5, 'NCUA', 'National Credit Union Administration'),
    (7, 'HUD',  'Department of Housing and Urban Development'),
    (9, 'CFPB', 'Consumer Financial Protection Bureau');

INSERT INTO Purchaser (purchaser_type, purchaser_type_name) VALUES
    (0, 'Loan was not originated or was not sold in calendar year covered by register'),
    (1, 'Fannie Mae (FNMA)'),
    (2, 'Ginnie Mae (GNMA)'),
    (3, 'Freddie Mac (FHLMC)'),
    (4, 'Farmer Mac (FAMC)'),
    (5, 'Private securitization'),
    (6, 'Commercial bank, savings bank or savings association'),
    (7, 'Life insurance company, credit union, mortgage bank, or finance company'),
    (8, 'Affiliate institution'),
    (9, 'Other type of purchaser');
