setwd("C:/Users/mangmangyuzhou/Desktop/2016 Spring/data science")
react=readRDS("react.RDS")
###filter to select zip code

reaction_meadian <- filter(react, react$"i" == "10025")

#output:(median reaction time, rank in the whole zip code, the top percent in the whole zip code)
m_reaction=reaction_meadian$median_calc;m_reaction
zrank=reaction_meadian$rank;zrank
top_percent=reaction_meadian$rank/nrow(react)*100;top_percent
