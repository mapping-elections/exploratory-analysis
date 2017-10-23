library(tidyverse)
library(mappingelections)

results <- read_csv("congressional-candidate-totals-all.csv")

candidates_per_election <- results %>%
  count(election_id) %>%
  left_join(meae_elections, by = "election_id") %>%
  mutate(unopposed = n == 1) %>%
  filter(!is.na(state))

state_unopposed <- candidates_per_election %>%
  group_by(state, year) %>%
  summarize(percent_unopposed = sum(unopposed) / n())

national_unopposed <- candidates_per_election %>%
  group_by(year) %>%
  summarize(percent_unopposed = sum(unopposed) / n())

ggplot(state_unopposed, aes(x = year, y = percent_unopposed)) +
  facet_wrap(~state, ncol = 4) +
  geom_line() + geom_point()

ggplot(national_unopposed, aes(x = year, y = percent_unopposed)) +
  geom_line() + geom_point()
