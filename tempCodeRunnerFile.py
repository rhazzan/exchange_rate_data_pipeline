import yfinance as yf
import pandas as pd
from yfinance.domain.industry import Industry
from yfinance.domain.sector import Sector
import yfinance.const as const

# print(yf.Industry("software-infrastructure"))
pd.DataFrame(const.SECTOR_INDUSTY_MAPPING)