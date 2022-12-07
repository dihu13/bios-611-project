# Clustering analysis
library(rpart)
library(corrplot)
library(Hmisc)
library(reshape2)
library(fpc)
library(factoextra)
char <- read.csv("source_data/character-deaths.csv", stringsAsFactors = F)
char.pred <- read.csv("source_data/character-predictions.csv", stringsAsFactors = F)

names(char.pred)[which(names(char.pred) == "name")] <- "Name"

char1 <- inner_join(char, char.pred, by = "Name")
char1$age[187] <- 20 #Correction of obvious outlier
popular  <- char1 %>% filter(isPopular ==1)
 numb <- popular[, which(sapply(popular,class) != "character")]
 #numb <- char1[, which(sapply(char1,class) != "character")]
numb$Death.Year[is.na(numb$Death.Year)]=max(na.omit(numb$Death.Year))+1
for(i in 1:ncol(numb)) {
        numb[ , i][is.na(numb[ , i])] <- mean(numb[ , i], na.rm=TRUE)
}

numb <- as.data.frame(scale(numb))
numb <- cbind("Allegiances" = popular$Allegiances, numb)

# numb <- cbind("Allegiances" = char1$Allegiances, numb)
numb$Allegiances <- gsub("House ", "", numb$Allegiances)

to.remove <- c("Book.of.Death", "Death.Chapter", "pred", "plod", 
               "male", "book1", "book2", "book3", "book4", "book5", "isAliveMother", 
               "isAliveHeir", "isAliveSpouse", "isNoble", 
               "numDeadRelations", "boolDeadRelations", "isPopular"
               ,"S.No" ,"DateoFdeath","alive","isAliveFather","dateOfBirth","actual","Death.Year")
numb <- numb[ , -which(names(numb) %in% to.remove)]

M <- rcorr(as.matrix(numb[,-1]))
corrplot(M$r, type="upper")
tri <- upper.tri(M$r)
corr.values <- data.frame(row = rownames(M$r)[row(M$r)[tri]],
                          column = rownames(M$r)[col(M$r)[tri]],
                          cor  =(M$r)[tri])
corr.values[which(abs(corr.values$cor) > 0.5),]


Lannister.team <- c("Lannister", "Tyrell")
Stark.team <- c("Arryn", "Baratheon", "Stark", "Tully")
Against.all.team <- c("Martell", "Greyjoy", "Targaryen", "Wildling")
Neutral.team <- c("Night's Watch", "None")
numb$Team <- ifelse(numb$Allegiances %in% Lannister.team, numb$Team <- "Lannister team",
                    ifelse(numb$Allegiances %in% Stark.team, numb$Team <- "Stark team",
                           ifelse(numb$Allegiances %in% Against.all.team, 
                                  numb$Team <- "Against all", "Neutral")))
table(numb$Team)

shannon <- function(tokens){
        tbl <- table(tokens);
        p <- (tbl %>% as.numeric())/sum(tbl %>% as.numeric());
        sum(-p*log(p));
}
mutinf <- function(a,b){
        sa <- shannon(a);
        sb <- shannon(b);
        sab <- shannon(sprintf("%d:%d", a, b));
        sa + sb - sab;
}
normalized_mutinf <- function(a,b){
        2*mutinf(a,b)/(shannon(a)+shannon(b));
}

set.seed(14)

data <- numb[,-c(1,14)]
a <- list()
for (i in 2:6){
        r<-mapply(function(x) kmeans(data, centers = i)$cluster,1:5)
        out <- c()
        for (j in 1:5){
                for (k in 1:5){
                        out <- cbind(out, normalized_mutinf(r[,j], r[,k]))
                }
        }
        a[[i-1]] <- matrix(out,ncol=5)
}

nmi <- tibble(n.cluster = 2:6, mean.nmi = colMeans(mapply(function(x) (colSums(x)-1)/4, a)))
ggplot(nmi, aes(x = n.cluster, y = mean.nmi, fill = n.cluster)) +
        geom_bar(stat = "identity") + 
        geom_text(aes(label=sprintf("%0.2f", round(mean.nmi, digits = 2))), vjust=-0.5,
                  colour = '#16338d')

# We choose 6 clusetrs

plot.team <- function(data){
        dat.clust <- melt(cbind(data, Cluster = rownames(data)), id.vars = c('Cluster'))
        ggplot(dat.clust, aes(x = variable, y = value, fill = Cluster)) + 
                geom_bar(position = "fill", stat = "identity") + 
                scale_y_continuous(labels = percent_format()) + 
                labs(x = "Team", y = "Percentage")
}
k6 <- kmeans(data, 6)
dat.6 <- as.data.frame.matrix(table(k6$cluster, numb$Team))
plot.team(dat.6)
# rownames(data) <- popular$Name
fviz_cluster(k6, data = data)

pc <- princomp(data, cor=TRUE, scores=TRUE)
plot_3d <- as_tibble(cbind(pc$scores[,1:3],k4$cluster))
colnames(plot_3d)[4] <- "Cluster"
plot_3d$Cluster <- factor(plot_3d$Cluster)
library(plotly)
plot_ly(plot_3d, x=~Comp.1, y=~Comp.2, 
             z=~Comp.3, color=~Cluster) %>%
        add_markers(size=1.5)

