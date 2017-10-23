congbio_elected <- read_csv("congbio_elected.csv")

congbio_elected <- congbio_elected %>%
  select(-meae_id, -district) %>%
  filter(congbio_position != "Senator")

winners <- congbio_elected %>%
  group_by(congress, state) %>%
  summarize(previous_congress = list(unique(congbio_id))) %>%
  ungroup() %>%
  mutate(congress = congress + 1)

congbio_elected_inc <- congbio_elected %>%
  left_join(winners, by = c("congress", "state")) %>%
  rowwise() %>%
  mutate(incumbent_winner = congbio_id %in% previous_congress[[1]]) %>%
  ungroup()

overall_incumbency_rate <- congbio_elected_inc %>%
  group_by(congress) %>%
  summarize(total_elected = n(),
            incumbents_elected = sum(incumbent_winner),
            percent_elected_incumbents = incumbents_elected / total_elected)

ggplot(overall_incumbency_rate, aes(x = congress, y = percent_elected_incumbents)) +
  geom_point() + geom_line() +
  scale_x_continuous(breaks = 1:20) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.5)) +
  labs(title = "Rates of incumbency in the early House of Representatives",
       subtitle = "Percentage of Representatives who served in the House from the\nsame state in the previous Congress.",
       caption = "Mapping Early American Elections",
       y = "% incumbents",
       x = "Congress") +
  theme_bw()

state_incumency_rates <- congbio_elected_inc %>%
  group_by(congress, state) %>%
  summarize(total_elected = n(),
            incumbents_elected = sum(incumbent_winner),
            percent_elected_incumbents = incumbents_elected / total_elected)

ggplot(state_incumency_rates, aes(x = congress, y = percent_elected_incumbents)) +
  geom_point() + geom_line() +
  facet_wrap(~factor(state), ncol = 3) +
  scale_x_continuous(breaks = 1:20) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Rates of incumbency in the early House of Representatives",
       subtitle = "Percentage of Representatives who served in the House from the\nsame state in the previous Congress.",
       caption = "Mapping Early American Elections",
       y = "% incumbents",
       x = "Congress") +
  theme_classic()



