# download the ~20GB Chicago ride share data
# note: takes ~1.5 hours depending on internet speed

echo "Start downloading the Chicago rideshare data at $(date)"

cd raw_data/
wget -O rideshare_2018_2019.csv https://data.cityofchicago.org/api/views/m6dm-c72p/rows.csv?accessType=DOWNLOAD

echo "Finish downloading the Chicago rideshare data at $(date)"
