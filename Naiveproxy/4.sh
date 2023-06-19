read -p "Please Enter your Domain: " $domain
wget https://raw.githubusercontent.com/salesforce/jarm/master/jarm.py
python3 jarm.py $domain
