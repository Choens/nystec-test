options(scipen = 99999)
library(DBI)
library(lubridate)
library(readxl)
library(tidyverse)
source("./R/connect_to_duck.R")
con <- connect_to_duck()

## Imports claim_trans from binary Excel (xls).
## The old binary format isn't as well supported by readxl, so it imports
## everything as a string variable. The mutate command only alters those columns
## which I can see should be ints, floats, or dates. No columns are removed from
## the data. If not listed, they are just left alone.
claim_trans <- read_xls(
  "./data/Research_Question_1.xls",
  sheet = "CLAIM_TRANS"
) |>
  mutate(
    CLAIM_TRANS_ID = as.integer(CLAIM_TRANS_ID),
    BILL_NPI = as.integer(BILL_NPI),
    BILL_PROV_ID = as.integer(BILL_PROV_ID),
    SRV_RNDR_NPI = as.integer(SRV_RNDR_NPI),
    ATTEND_NPI = as.integer(ATTEND_NPI),
    PRESC_ORD_NPI = as.integer(PRESC_ORD_NPI),
    COS_CD = as.integer(COS_CD),
    SRV_DT = mdy(SRV_DT),
    PMT_DT = mdy(PMT_DT),
    ADMIT_DT = mdy(ADMIT_DT),
    DSCH_DT = mdy(DSCH_DT),
    PAID_AMOUNT = as.numeric(PAID_AMOUNT),
    MBR_AGE_ON_DOS = as.numeric(MBR_AGE_ON_DOS)
  )

## Moves the data to the duck database so we can use SQL on the data,
## rather than dplyr code.
dbWriteTable(con, "CLAIM_TRANS", claim_trans, overwrite = TRUE)

dbDisconnect(con, shutdown = TRUE)
