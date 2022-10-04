import pandas as pd 

pmu_original = pd.read_csv("Phasor_data.csv")

# Create sub samples datasets 
one_thousand_lines = pmu_original.iloc[0:1000,:]
five_thousand_lines = pmu_original.iloc[0:5000,:]
ten_thousand_lines = pmu_original.iloc[0:10000,:]
fifty_thousand_lines = pmu_original.iloc[0:50000,:]
hundred_thousand_lines = pmu_original.iloc[0:100000,:]

# Create over sample datasets

# Save new datasets 
one_thousand_lines.to_csv("1klines.csv",index=False)
five_thousand_lines.to_csv("5klines.csv",index=False)
ten_thousand_lines.to_csv("10klines.csv",index=False)
fifty_thousand_lines.to_csv("50klines.csv",index=False)
hundred_thousand_lines.to_csv("100klines.csv",index=False)
# five_hundred_thousand_lines.to_csv("500klines.csv",index=False)
# six_hundred_thousand_lines.to_csv("648klines.csv",index=False)
# one_million.to_csv("1Mlines.csv".index=False)
