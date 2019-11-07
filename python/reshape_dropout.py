"""
Reshape cps dropout data from wide to long
"""

# load necessary packages ----
import pandas as pd


# load necessary functions ----
def clean_int_text(x):
    """Replace .0 values with empty spaces"""
    return x.replace(".0", "")


# load necessary data ----
cps_dropout_df = pd.read_csv("raw_data/raw_cps_dropout_rate_2011_2019.csv")

# data preprocessing ----
# make all column names lower case and
# replace space with underscore & ".0" with empty space (i.e. "")
cps_dropout_df.columns = [col.lower().replace(" ", "_").replace(".0", "")
                          for col in cps_dropout_df.columns]

# transform school_id from int to str
cps_dropout_df["school_id"] = cps_dropout_df["school_id"].apply(str).apply(clean_int_text)

# reshape data from wide to long ----
cps_dropout_df_long = pd.melt(cps_dropout_df,
                              id_vars=["school_id",
                                       "school_name",
                                       "status_as_of_2019"],
                              value_vars=[str(num)
                                          for num in range(2011, 2020)])


# clean data frame ----

# rename columns
cps_dropout_df_long.rename(columns={"variable": "school_year",
                                    "value": "dropout_rate"},
                           inplace=True)

# sort the data such that each record is paired by school and school year
cps_dropout_df_long.sort_values(by=["school_id", "school_year"], inplace=True)

# reset the index
cps_dropout_df_long.reset_index(drop=True, inplace=True)

# export the data frame as a .csv file ----
cps_dropout_df_long.to_csv("write_data/clean_cps_dropout_rate_2011_2019.csv",
                           index=False)

# end of script #
