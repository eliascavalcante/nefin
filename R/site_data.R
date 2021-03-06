site_data <- function (data, category, portfolio) 
{
  url = list()
  url[["COE"]][["Products"]] = "http://nefin.com.br/Cost%20of%20Capital/Basic%20Products.xls"
  url[["COE"]][["Construction"]] = "http://nefin.com.br/Cost%20of%20Capital/Construction.xls"
  url[["COE"]][["Consumer"]] = "http://nefin.com.br/Cost%20of%20Capital/Consumer.xls"
  url[["COE"]][["Energy"]] = "http://nefin.com.br/Cost%20of%20Capital/Energy.xls"
  url[["COE"]][["Finance"]] = "http://nefin.com.br/Cost%20of%20Capital/Finance.xls"
  url[["COE"]][["Manufacturing"]] = "http://nefin.com.br/Cost%20of%20Capital/Manufacturing.xls"
  url[["COE"]][["Other"]] = "http://nefin.com.br/Cost%20of%20Capital/Other.xls"
  url[["dividend_yield"]][["unique"]] = "http://nefin.com.br/Predictability/dividend_yield.xls"
  url[["illiquidity_index"]][["unique"]] = "http://www.nefin.com.br/Risk%20Factors/Market_Liquidity.xls"
  url[["loan_fees"]][["unique"]] = "http://www.nefin.com.br/Predictability/loan_fees.xls"
  url[["portfolios"]][["size"]] = "http://www.nefin.com.br/Portfolios/3_portfolios_sorted_by_size.xls"
  url[["portfolios"]][["btm"]] = "http://www.nefin.com.br/Portfolios/3_portfolios_sorted_by_book-to-market.xls"
  url[["portfolios"]][["momentum"]] = "http://www.nefin.com.br/Portfolios/3_portfolios_sorted_by_momentum.xls"
  url[["portfolios"]][["illiquidity"]] = "http://www.nefin.com.br/Portfolios/3_portfolios_sorted_by_illiquidity.xls"
  url[["portfolios"]][["size_btm"]] = "http://www.nefin.com.br/Portfolios/4_portfolios_sorted_by_size_and_book-to-market_2x2.xls"
  url[["portfolios"]][["size_momentum"]] = "http://www.nefin.com.br/Portfolios/4_portfolios_sorted_by_size_and_momentum_2x2.xls"
  url[["portfolios"]][["size_illiquidity"]] = "http://www.nefin.com.br/Portfolios/4_portfolios_sorted_by_size_and_illiquidity_2x2.xls"
  url[["portfolios"]][["industry"]] = "http://nefin.com.br/Portfolios/7_portfolios_sorted_by_industry.xls"
  url[["risk_factors"]][["Rm_minus_Rf"]] = "http://nefin.com.br/Risk%20Factors/Market_Factor.xls"
  url[["risk_factors"]][["SMB"]] = "http://nefin.com.br/Risk%20Factors/SMB_Factor.xls"
  url[["risk_factors"]][["HML"]] = "http://nefin.com.br/Risk%20Factors/HML_Factor.xls"
  url[["risk_factors"]][["WML"]] = "http://nefin.com.br/Risk%20Factors/WML_Factor.xls"
  url[["risk_factors"]][["IML"]] = "http://nefin.com.br/Risk%20Factors/IML_Factor.xls"
  url[["risk_factors"]][["Risk_free"]] = "http://nefin.com.br/Risk%20Factors/Risk_Free.xls"
  url[["short_interest"]][["unique"]] = "http://www.nefin.com.br/Predictability/short_interest.xls"
  url[["volatility_index"]][["IVolBR"]] = "http://www.nefin.com.br/Volatility%20Index/IVol-BR.xls"
  url[["volatility_index"]][["variance_premium"]] = "http://www.nefin.com.br/Volatility%20Index/Variance%20Premium.xls"
  url[["volatility_index"]][["risk_aversion"]] = "http://www.nefin.com.br/Volatility%20Index/Risk%20Aversion.xls"
  destfile <- tail(strsplit(url[[data]][[category]], "/")[[1]], 
                   1)
  destfile <- gsub("%20", " ", destfile)
  curl_download(url[[data]][[category]], destfile)
  if (data == "portfolios") {
    sht <- paste(portfolio, "Weighted Returns")
    data_set <- read_excel(destfile, sht, col_types = "numeric")
  }
  else {
    data_set <- read_excel(destfile)
  }
  if (data == "COE") {
    list_str <- strsplit(data_set$`Month/Year`, "/")
    month <- strtoi(sapply(list_str, "[", 1))
    year <- strtoi(sapply(list_str, "[", 2))
    date <- as.Date(paste(year, month, 1, sep = "-"))
    data_set$`Month/Year` <- NULL
    colnames(data_set) = paste(category, gsub(pattern = " ", 
                                              ".", x = colnames(data_set)), sep = ".")
    data_set <- xts(x = data_set, order.by = date)
  }
  else if (data == "dividend_yield") {
    date <- as.Date(paste(data_set$year, data_set$month, data_set$day, 
                          sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$month <- NULL
    data_set$year <- NULL
    data_set$day <- NULL
  }
  else if (data == "illiquidity_index") {
    date <- as.Date(paste(data_set$year, data_set$month, 
                          1, sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$year <- NULL
    data_set$month <- NULL
  }
  else if (data == "loan_fees") {
    date <- as.Date(paste(data_set$year, data_set$month, data_set$day, 
                          sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$year <- NULL
    data_set$month <- NULL
    data_set$day <- NULL
  }
  else if (data == "portfolios") {
    date <- as.Date(paste(data_set$year, data_set$month, 
                          data_set$day, sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$year <- NULL
    data_set$month <- NULL
    data_set$day <- NULL
  }
  else if (data == "risk_factors") {
    date <- as.Date(paste(data_set$year, data_set$month, 
                          data_set$day, sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$year <- NULL
    data_set$month <- NULL
    data_set$day <- NULL
  }
  else if (data == "short_interest") {
    date <- as.Date(paste(data_set$year, data_set$month, data_set$day, 
                          sep = "-"))
    data_set <- xts(x = data_set, order.by = date)
    data_set$year <- NULL
    data_set$month <- NULL
    data_set$day <- NULL
  }
  else {
    if (category == "IVolBR") {
      date <- as.Date(paste(data_set$year, data_set$month, 
                            data_set$day, sep = "-"))
      data_set <- xts(x = data_set, order.by = date)
      data_set$year <- NULL
      data_set$month <- NULL
      data_set$day <- NULL
    }
    else {
      date <- as.Date(paste(data_set$year, data_set$month, 
                            data_set$day, sep = "-"))
      data_set <- xts(x = data_set, order.by = date)
      data_set$year <- NULL
      data_set$month <- NULL
      data_set$day <- NULL
    }
  }
  columns = colnames(data_set)
  columns = gsub("Industry_1", "Basic_Products", columns)
  columns = gsub("Industry_2", "Construction", columns)
  columns = gsub("Industry_3", "Consumer", columns)
  columns = gsub("Industry_4", "Energy", columns)
  columns = gsub("Industry_5", "Finance", columns)
  columns = gsub("Industry_6", "Manufacturing", columns)
  columns = gsub("Industry_7", "Other", columns)
  colnames(data_set) <- columns
  return(data_set)
}
