library(tidyverse)
library(readxl)

# # This is for databasing for Samual's data
# english_titles <- read_csv("/Users/joeystanley/Desktop/Projects/Hymns/English titles for combined data.csv") %>%
#     print()
# 
# hymns1 <- read_excel("Combined Hymns Data.xlsx", sheet = 1) %>%
#     print()

# Frequency Analysis ------------------------------------------------------

# This is recreating what I've done in the Excel Spreadsheet since I know it better.
hymns_raw <- read_excel("Combined Hymns Data.xlsx", 
                         sheet = "Combined Hymns Data",
                         col_types = "text") %>%
    select(id,
           `date` = SHymnDate,
           `week_num` = WeekNum,
           `unit_num` = UnitNumber,
           `ward` = WardName,
           `ward_type` = WardType,
           `city` = WardCity,
           `state` = WardState,
           `country` = WardCountry,
           `lang` = HyBoLanguage,
           `type` = SHymnType,
           `num_int` = SHymnNumber_International,
           `song_id` = SongID,
           `us_name` = USoName,
           `is_in_english` = SHymnIsInEnglishHymnbook,
           `num_eng` = SHymnNumber_English,
           `holiday` = SHymnSpecialWeek,
           `is_fast_sunday` = SHymnIsFastSunday) %>%
    filter(type %in% c("Opening", "Sacrament", "Intermediate", "Closing"), # removes some special musical numbers
           is_in_english == "1") %>% # removes 33 international ones or ones not in the hymnal
    mutate(type = factor(type, levels = c("Opening", "Sacrament", "Intermediate", "Closing")),
           is_fast_sunday = if_else(is_fast_sunday == "1", TRUE, FALSE)) %>% 
    mutate_at(vars(song_id, num_eng), as.numeric) %>%
    select(-is_in_english) %>%
    print()

ward_info <- hymns_raw %>%
    select(unit_num, ward, ward_type, city, state, country) %>%
    distinct() %>%
    print() 

hymn_info <- hymns_raw %>%
    select(num_eng, date, us_name, lang, num_int, song_id) %>%
    filter(lang == "eng") %>%
    select(-lang) %>%
    distinct() %>%
    mutate(is_sacrament = if_else(num_eng %in% seq(169, 196), TRUE, FALSE)) %>%
    print()

hymns <- hymns_raw %>%
    # Rename and select
    select(week_num, date, unit_num, type, num_eng, holiday, is_fast_sunday) %>%
    # Filter out stuff I don't need.
    filter(type %in% c("Opening", "Sacrament", "Intermediate", "Closing")) %>%
    print()

# Wards with lots of data
wards_with_lots_of_data <- hymns %>%
    select(unit_num, date) %>%
    distinct() %>%
    group_by(unit_num) %>%
    tally() %>%
    arrange(-n) %>%
    filter(n > 45) %>%
    print(n = 23)
hymns_per_week <- hymns %>%
    filter(unit_num %in% wards_with_lots_of_data$unit_num) %>%
    group_by(unit_num, date) %>%
    tally() %>%
    ungroup() %>%
    summarize(mean_per_day = mean(n)) %>%
    pull(mean_per_day) %>%
    print()
hymns_per_year <- hymns_per_week * 48
    
hymns %>%
    filter(unit_num %in% wards_with_lots_of_data$unit_num) %>%
    group_by(num_eng, type) %>%
    tally() %>%
    spread(type, n, fill = 0) %>%
    left_join(hymn_info, by = "num_eng") %>%
    select(num_eng, us_name, Opening, Sacrament, Intermediate, Closing) %>%
    distinct() %>%
    group_by(num_eng) %>%
    mutate(total = sum(Opening, Sacrament, Intermediate, Closing)) %>%
    ungroup() %>%
    arrange(-total) %>%
    mutate(n_per_year_per_ward = total / hymns_per_year) %>% #<- this is not right...
    print()

# What are the top sacrament hymns?
hymn_info %>%
    View()
    



