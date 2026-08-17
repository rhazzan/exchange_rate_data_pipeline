select  er.date as Date,
        er.base as Base,
        er.quote as Quote,
        cd.Country,
        cd.currency,
        er.rate as Rate
from Exchange_Rates as er
join currency_dim as cd
on cd.iso_code = er.quote;


-- select  er.date as Date, 
--         er.base as Base,
--         er.quote as Quote,
--         cd.name as Quote_Name,
--         er.rate as Rate,
--         substr(cd.name,1, instr(cd.name,' ')) as Country,
--         substr(cd.name,instr(cd.name,' ')+1) as Currency
-- from Exchange_Rates as er
-- join currency_dim as cd
-- on cd.iso_code = er.quote;