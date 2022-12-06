# Analysis for battles
battles <- read_csv("source_data/battles.csv") 
attackers <- battles_kings %>%
        group_by(attacker_king) %>%
        summarise( n = n()) %>%
        rename(king = attacker_king) %>%
        rename(n_attact = n)
defenders <- battles_kings %>% 
        group_by(defender_king) %>% 
        summarise( n = n()) %>%
        rename( king = defender_king) %>%
        rename(n_defend = n)
total <- full_join(attackers, defenders, type = "right") %>%
        mutate(n_attact = replace(n_attact,is.na(n_attact),0)) %>%
        mutate(n_total = n_attact + n_defend) %>%
        mutate(perc= n_total/sum(n_total))  %>% 
        arrange(perc) %>%
        mutate(labels = scales::percent(perc))
# pie graph of the proportion that each king enrolled into those battles
ggplot(data = total, aes(x="", y = n_total, fill = king)) +
        geom_bar(stat = "identity", width=1) +
        coord_polar("y", start=0) +
        theme_void() + geom_text(aes(label = labels),
                                 position = position_stack(vjust = 0.5))
# Counts of wining for each king
attacker_win <- battles_kings %>% filter(attacker_outcome == "win") %>%
        group_by(attacker_king) %>% summarise( n = n()) %>% 
        rename(King = attacker_king, nwin_attack = n)
defender_win <- battles_kings %>% filter(attacker_outcome == "win") %>%
        group_by(defender_king) %>% summarise( n = n()) %>% 
        rename(King = defender_king, nwin_defend = n)
king_win <- full_join(attacker_win, defender_win, type = "right", by = "King") %>%
         mutate(nwin_attack = replace(nwin_attack,is.na(nwin_attack),0)) %>%
         mutate(nwin = nwin_attack + nwin_defend )
ggplot(data = king_win, aes(x = nwin , y= King, fill = King)) + 
        geom_bar(, stat = "identity", show.legend = FALSE) + xlab ("Counts of win")

# The most attactive kings

ggplot(data = attacker_win, aes(x = nwin_attack , y= King, fill = King)) + 
        geom_bar(, stat = "identity", show.legend = FALSE) + xlab ("Counts of win")

# Does affect size and defender size affact the result?

battle_results <- battles %>% 
        select(attacker_size, defender_size, attacker_outcome) %>%
        mutate(size_diff = attacker_size - defender_size, 
               outcome_num = ifelse(attacker_outcome == "win", 1,0))


ggplot(data = battle_results, aes(x = attacker_size, y = defender_size, color = attacker_outcome))+
        geom_point()

# Logistic regression for battle outcome
logit_fit <- glm(outcome_num ~ size_diff,data = battle_results)
summary(logit_fit)

