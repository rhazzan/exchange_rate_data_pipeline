import pandas as pd
import requests as rq
import sqlite3 as sq

rate_URl = "https://api.frankfurter.dev/v2/rates?base=USD&from=2024-01-01"
currency_URL = "https://api.frankfurter.dev/v2/currencies?scope=all"

# Load the Exchange Rates fact data from the API
json_file = rq.get(url=rate_URl)
fact_data = pd.DataFrame(json_file.json())

# Load the currency dimension data from the API
currency_dim = rq.get(url=currency_URL)
currency_dim = pd.DataFrame(currency_dim.json())

currency = []
splitted = currency_dim["name"].str.split(" ",n=3)
for i in splitted:
    currency.append(i[-1])
currency_dim["Currency"] = currency

country = []
splitted2 = currency_dim["name"].str.split(" ",n=3)
for i in splitted2:
    if len(i) == 4:
        country.append(i[0] + " " + i[1] + " " + i[2])
    elif len(i) == 3:
        country.append(i[0] + " " + i[1])
    else:
        country.append(i[0])
currency_dim["Country"] = country

currency_dim.drop(columns="name",inplace=True)
currency_dim = currency_dim[["start_date","end_date","Country","Currency","symbol","iso_code","iso_numeric"]]

conn = sq.connect("exchange_rates.db")
fact_data.to_sql("Exchange_Rates",con=conn, if_exists="replace", index=False)
currency_dim.to_sql("currency_dim",con=conn, if_exists="replace", index=False)

dataset =pd.read_sql_query(sql='''select er.date as Date,
                            er.base as Base,
                            er.quote as Quote,
                            cd.Country,
                            cd.Currency,
                            er.rate as Rate
                        from Exchange_Rates as er
                        join currency_dim as cd
                        on cd.iso_code = er.quote''',con=conn)
conn.close()
dataset.to_csv("exchange_rates.csv",index=False,)
print(dataset)